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
say 'T9: write refuses to overwrite a record whose version has a tag'
SHA_011=$(python3 "$ZIPBUILDER" "$WORK/tree-0.1.1/iaa" "$WORK/v011.zip" 2>/dev/null)
# Hermetic tag state: the tool's tag check reads the git repo it is checked
# out of, and CI checkouts are shallow with NO tags at all — so T9 runs a
# copy of the tool from a scratch repo whose tags we control.
HERM="$WORK/hermetic"
mkdir -p "$HERM/scripts"
cp -- "$PIN" "$HERM/scripts/release-pin.py"
git -C "$HERM" init -q
git -C "$HERM" -c user.email=tests@iaa.invalid -c user.name=iaa-tests \
  commit -q --allow-empty --allow-empty-message -m ""
git -C "$HERM" tag v0.1.1
HPIN="$HERM/scripts/release-pin.py"
python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" >/dev/null \
  || bad "first write of a not-yet-recorded version must succeed (even tagged)"
cp -- "$WORK/r011.json" "$WORK/r011.before"
if python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" > "$WORK/w.out" 2>&1; then
  bad "write overwrote a record for tagged version v0.1.1"
fi
grep -q 'published' "$WORK/w.out" || bad "refusal must state the record is published/immutable"
cmp -s "$WORK/r011.before" "$WORK/r011.json" || bad "record modified despite refusal"
# control: same scratch repo without the tag → the version is unpublished,
# overwriting the pre-release record is allowed
git -C "$HERM" tag -d v0.1.1 >/dev/null
python3 "$HPIN" write "$WORK/v011.zip" --out "$WORK/r011.json" >/dev/null \
  || bad "overwrite must be allowed while the version has no tag"
ok "tagged-version record immutable; untagged overwrite allowed (hermetic tags)"

printf '\nALL %s RELEASE-PIN TESTS PASSED\n' "$PASS"
rm -rf -- "$WORK"
