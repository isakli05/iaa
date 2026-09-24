#!/bin/sh
# Unit tests for scripts/release-pin.py (release pin record + archive-content
# parity — IAA-BL-016). Fully offline: builds synthetic plugin archives in a
# disposable sandbox; never touches the repository tree or the network.
# Usage: tests/release-pin/run-tests.sh — exits non-zero on the first failure.
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd -P)
PIN="$REPO_ROOT/scripts/release-pin.py"
ZIPBUILDER="$REPO_ROOT/scripts/build-plugin-zip.py"
WORK=$(mktemp -d "${TMPDIR:-/tmp}/iaa-release-pin-tests.XXXXXX")
PASS=0

say()  { printf '\n== %s\n' "$1"; }
ok()   { printf '   PASS: %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '   FAIL: %s\n' "$1" >&2; exit 1; }

# ---------------------------------------------------------------- fixtures
# Synthetic plugin trees (directory named "iaa" so the archive top-level dir
# matches the real plugin layout; version 9.9.9 has no tag in this repo).
python3 - "$WORK" <<'PY'
import json, os, sys
w = sys.argv[1]
for ver in ("9.9.9", "0.1.1"):
    root = os.path.join(w, f"tree-{ver}", "iaa")
    os.makedirs(os.path.join(root, ".zcode-plugin"))
    os.makedirs(os.path.join(root, "skills", "iaa"))
    json.dump({"name": "iaa", "version": ver, "description": "test plugin"},
              open(os.path.join(root, ".zcode-plugin", "plugin.json"), "w"))
    # long, compressible content so different deflate levels give different bytes
    open(os.path.join(root, "skills", "iaa", "SKILL.md"), "w").write(
        "# policy text\n" + ("delegation decisions depend on the task shape.\n" * 200))
    open(os.path.join(root, "PROVENANCE"), "w").write(f"version: {ver}\n")
PY

# base.zip via the real builder (fixed conventions); record from it.
SHA_BASE=$(python3 "$ZIPBUILDER" "$WORK/tree-9.9.9/iaa" "$WORK/base.zip" 2>/dev/null)

# mutate <in.zip> <out.zip> <mode>: rebuild an archive with one content-level
# mutation, preserving entry metadata (or deliberately changing exactly one
# metadata field). mode "recompress" keeps content identical but forces
# deflate level 1 (different compressed bytes — the accepted cross-zlib case).
python3 - "$WORK" "$WORK/mutate.py" <<'PY'
import sys
src = '''\
import sys, zipfile
src_path, dst_path, mode = sys.argv[1], sys.argv[2], sys.argv[3]
with zipfile.ZipFile(src_path) as zf:
    entries = [(i.filename, zf.read(i.filename), i.date_time,
                i.external_attr, i.compress_type) for i in zf.infolist()]
if mode == "bytes":
    n, data, dt, ea, ct = entries[1]
    entries[1] = (n, data + b"content drift\\n", dt, ea, ct)
elif mode == "rename":
    n, data, dt, ea, ct = entries[2]
    entries[2] = (n + ".renamed", data, dt, ea, ct)
elif mode == "extra":
    entries.append(("iaa/EXTRA.md", b"extra entry\\n",
                    entries[0][2], entries[0][3], entries[0][4]))
elif mode == "missing":
    del entries[2]
elif mode == "timestamp":
    n, data, dt, ea, ct = entries[1]
    entries[1] = (n, data, (2026, 1, 2, 0, 0, 0), ea, ct)
elif mode == "attr":
    n, data, dt, ea, ct = entries[1]
    entries[1] = (n, data, dt, 0o755 << 16, ct)
elif mode != "recompress":
    sys.exit(f"unknown mode {mode}")
with zipfile.ZipFile(dst_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for n, data, dt, ea, ct in entries:
        info = zipfile.ZipInfo(n, date_time=dt)
        info.external_attr = ea
        info.compress_type = ct
        if mode == "recompress":
            zf.writestr(info, data, compresslevel=1)  # portable kwarg (3.7+)
        else:
            zf.writestr(info, data)
'''
open(sys.argv[2], "w").write(src)
PY
mutate() { python3 "$WORK/mutate.py" "$1" "$2" "$3"; }

sha_of() { sha256sum -- "$1" | cut -d' ' -f1; }

# ---------------------------------------------------------------- T1 record shape
say 'T1: write creates a record with version/url/sha256 + 7-field manifest'
[ -f "$WORK/base.zip" ] || bad "builder produced no base.zip"
python3 "$PIN" write "$WORK/base.zip" --out "$WORK/record.json" >/dev/null \
  || bad "write failed on a fresh record"
[ "$(jq -r '.version' "$WORK/record.json")" = "9.9.9" ] || bad "record version wrong"
[ "$(jq -r '.sha256' "$WORK/record.json")" = "$SHA_BASE" ] || bad "record sha256 != archive sha256"
[ "$(jq -r '.asset_url' "$WORK/record.json")" = \
  "https://github.com/isakli05/iaa/releases/download/v9.9.9/iaa-9.9.9-plugin.zip" ] \
  || bad "record asset_url is not the canonical versioned release URL"
[ "$(jq -r '.manifest | length' "$WORK/record.json")" = "3" ] || bad "manifest entry count != archive entry count"
[ "$(jq -r '.manifest[0].name' "$WORK/record.json")" = "iaa/.zcode-plugin/plugin.json" ] \
  || bad "manifest is not in archive order (first entry)"
jq -e '[.manifest[] | keys | sort] | all(. == ["compress_type","crc32","date_time","external_attr","file_size","name","sha256"])' \
  "$WORK/record.json" >/dev/null || bad "manifest entries must carry exactly the 7 record fields"
[ -z "$(jq -r '.manifest[].name | select(endswith("/"))' "$WORK/record.json")" ] \
  || bad "record manifest contains directory entries"
ok "record: version, canonical url, archive sha256, ordered 7-field manifest"

# ---------------------------------------------------------------- T2 accept
say 'T2: compare ACCEPTS identical content with different compressed bytes'
mutate "$WORK/base.zip" "$WORK/variant.zip" recompress
[ "$(sha_of "$WORK/base.zip")" != "$(sha_of "$WORK/variant.zip")" ] \
  || bad "test fixture degenerated: recompressed archive is byte-identical"
python3 "$PIN" compare "$WORK/variant.zip" "$WORK/record.json" >/dev/null \
  || bad "compare must accept content-identical archives across deflate levels"
ok "content parity accepts different compressed bytes"

# ---------------------------------------------------------------- T3–T8 rejects
reject_case() { # $1 mode, $2 description
  say "T$((PASS + 1)): compare REJECTS $2"
  mutate "$WORK/base.zip" "$WORK/mut.zip" "$1"
  if python3 "$PIN" compare "$WORK/mut.zip" "$WORK/record.json" > "$WORK/mut.out" 2>&1; then
    bad "compare accepted $2"
  fi
  grep -q 'release-pin' "$WORK/mut.out" || bad "rejection output does not name the check"
  ok "rejected: $2"
}

reject_case bytes   'changed entry bytes'
reject_case rename  'renamed entry'
reject_case extra   'extra entry'
reject_case missing 'missing entry'
reject_case timestamp 'changed entry timestamp'
reject_case attr    'changed external attributes'

# ---------------------------------------------------------------- T9 immutability
say 'T9: write refuses to write for a PUBLISHED version (remote-or-local tag)'
SHA_011=$(python3 "$ZIPBUILDER" "$WORK/tree-0.1.1/iaa" "$WORK/v011.zip" 2>/dev/null)
# Hermetic publication state: a local bare repo is the "remote" (via
# IAA_RELEASE_PIN_REMOTE) and the tool runs from a tag-less scratch repo —
# mirroring CI checkouts, where local tags prove nothing.
HERM="$WORK/hermetic"
mkdir -p "$HERM/scripts"
cp -- "$PIN" "$HERM/scripts/release-pin.py"
git -C "$HERM" init -q
git -C "$HERM" -c user.email=tests@iaa.invalid -c user.name=iaa-tests \
  commit -q --allow-empty --allow-empty-message -m ""
REM="$WORK/rem.git"
SEED="$WORK/seed"
git init -q --bare "$REM"
git init -q "$SEED"
git -C "$SEED" -c user.email=tests@iaa.invalid -c user.name=iaa-tests \
  commit -q --allow-empty --allow-empty-message -m ""
HPIN="$HERM/scripts/release-pin.py"
export IAA_RELEASE_PIN_REMOTE="$REM"

# (d) remote lacks the tag → pre-release: write succeeds and creates the record
python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" >/dev/null \
  || bad "(d) write must succeed while v0.1.1 has no tag anywhere"

# publish: push v0.1.1 to the bare "remote"
git -C "$SEED" tag v0.1.1
git -C "$SEED" push -q "$REM" refs/tags/v0.1.1

# (a) record exists, version published remotely → refuse, file unchanged
cp -- "$WORK/r011.json" "$WORK/r011.before"
if python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" > "$WORK/w.out" 2>&1; then
  bad "(a) write overwrote a record for remotely-tagged v0.1.1"
fi
grep -q 'published' "$WORK/w.out" || bad "refusal must state the version is published"
cmp -s "$WORK/r011.before" "$WORK/r011.json" || bad "(a) record modified despite refusal"

# (b) record deleted, version still published → refuse, nothing created
rm -f -- "$WORK/r011.json"
if python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" > "$WORK/w.out" 2>&1; then
  bad "(b) write re-created a record for remotely-tagged v0.1.1"
fi
[ ! -e "$WORK/r011.json" ] || bad "(b) record file created despite refusal"

# (c) publication state indeterminable → refuse (fail closed)
if IAA_RELEASE_PIN_REMOTE="$WORK/no-such-repo.git" python3 "$HPIN" write "$WORK/v011.zip" \
    --out "$WORK/r011c.json" > "$WORK/w.out" 2>&1; then
  bad "(c) write must refuse when publication state cannot be determined"
fi
[ ! -e "$WORK/r011c.json" ] || bad "(c) record file created despite refusal"
ok "published version: overwrite + re-creation refused; unknown state refused; pre-release allowed"
unset IAA_RELEASE_PIN_REMOTE

# ---------------------------------------------------------------- T10 published-artifact pin check
say 'T10: verify-published decision logic (offline: --archive + remote override)'
# bare "remote" carrying tag v9.9.9 (the fixture record's version);
# base.zip/record.json are the T1 fixtures
git init -q --bare "$WORK/rem2.git"
SEED2="$WORK/seed2"
git init -q "$SEED2"
git -C "$SEED2" -c user.email=tests@iaa.invalid -c user.name=iaa-tests \
  commit -q --allow-empty --allow-empty-message -m ""
git -C "$SEED2" tag v9.9.9
git -C "$SEED2" push -q "$WORK/rem2.git" refs/tags/v9.9.9
# scratch record with a deliberately wrong recorded sha (same manifest)
jq '.sha256 = "856df55337c9d542b5a6e44af4d4ad287223c38fcdba9ef4913adf947b86df97"' \
  "$WORK/record.json" > "$WORK/record-wrong-sha.json"

# (i) published + correct pre-downloaded asset (--archive) -> pass
IAA_RELEASE_PIN_REMOTE="$WORK/rem2.git" python3 "$PIN" verify-published \
    "$WORK/record.json" --archive "$WORK/base.zip" >/dev/null \
  || bad "(i) verify-published must pass for the correct published asset"
# (ii) published + wrong recorded sha -> fail, naming both shas
if IAA_RELEASE_PIN_REMOTE="$WORK/rem2.git" python3 "$PIN" verify-published \
    "$WORK/record-wrong-sha.json" --archive "$WORK/base.zip" > "$WORK/vp.out" 2>&1; then
  bad "(ii) verify-published must fail on a wrong recorded sha"
fi
grep -q "$SHA_BASE" "$WORK/vp.out" || bad "(ii) failure must name the downloaded asset's sha"
grep -q '856df55337c9d542b5a6e44af4d4ad287223c38fcdba9ef4913adf947b86df97' "$WORK/vp.out" \
  || bad "(ii) failure must name the recorded sha"
# (iii) tag absent on the remote -> pre-release: pass with a note, no asset needed
git init -q --bare "$WORK/rem3.git"
IAA_RELEASE_PIN_REMOTE="$WORK/rem3.git" python3 "$PIN" verify-published \
    "$WORK/record.json" > "$WORK/vp.out" 2>&1 \
  || bad "(iii) unpublished version must pass with a note"
grep -q 'not published' "$WORK/vp.out" || bad "(iii) expected a pre-release note"
# (iv) publication state indeterminable -> fail
if IAA_RELEASE_PIN_REMOTE="$WORK/no-such.git" python3 "$PIN" verify-published \
    "$WORK/record.json" >/dev/null 2>&1; then
  bad "(iv) verify-published must fail when publication state is unknown"
fi
ok "verify-published: pass/fail/pre-release/fail-closed all correct (offline)"

printf '\nALL %s RELEASE-PIN TESTS PASSED\n' "$PASS"
rm -rf -- "$WORK"
