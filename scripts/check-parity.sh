#!/bin/sh
# İAA one-core parity + identity + version enforcement (CI layer A).
#
# Fails (non-zero) when:
#  - any packaging projection of the behavioral core is not byte-exact to iaa/
#  - a projection lacks its PROVENANCE marker or the version disagrees
#  - any manifest name/version disagrees with VERSION / the fixed identity
#  - the marketplace.remote.json pin disagrees with the published-artifact
#    release-pin record, or a fresh build's archive content differs from it
#  - the shim text in scripts/iaa drifts from iaa/scripts/manage.sh
#  - the tree would change if build-packages.sh were re-run (non-deterministic
#    or hand-edited projections)
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
CORE="$REPO_ROOT/iaa"
VERSION=$(sed -n '1p' "$REPO_ROOT/VERSION"); VERSION=${VERSION%%[[:space:]]}

fail() { printf 'check-parity: FAIL: %s\n' "$1" >&2; exit 1; }
note() { printf 'check-parity: %s\n' "$1"; }

[ -f "$CORE/SKILL.md" ] || fail "missing core"

# 1. byte-exact core projections ------------------------------------------------
check_projection() { # $1 skill dir, $2 label
  iaa_pc_dir=$1; iaa_pc_label=$2
  [ -f "$iaa_pc_dir/SKILL.md" ] || fail "$iaa_pc_label: missing $iaa_pc_dir/SKILL.md"
  (cd "$CORE" && find . -type f) | while IFS= read -r f; do
    cmp -s "$CORE/$f" "$iaa_pc_dir/$f" || { printf 'check-parity: FAIL: %s: %s differs from core\n' "$iaa_pc_label" "$f" >&2; exit 1; }
  done || exit 1
  [ -f "$iaa_pc_dir/PROVENANCE" ] || fail "$iaa_pc_label: missing PROVENANCE"
  grep -q "version: $VERSION" "$iaa_pc_dir/PROVENANCE" || fail "$iaa_pc_label: PROVENANCE version != VERSION ($VERSION)"
  note "OK $iaa_pc_label byte-exact + provenance $VERSION"
}

check_projection "$REPO_ROOT/packaging/claude/skills/iaa" "packaging/claude"
check_projection "$REPO_ROOT/packaging/codex/plugin/skills/iaa" "packaging/codex"
check_projection "$REPO_ROOT/packaging/zcode/plugins/iaa/skills/iaa" "packaging/zcode"
check_projection "$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/skills/iaa" "dev-plugin"

# 2. orchestrate entry: claude skill == template; zcode command == template ----
TEMPLATES="$REPO_ROOT/packaging/templates"
cmp -s "$TEMPLATES/orchestrate-SKILL.md" "$REPO_ROOT/packaging/claude/skills/orchestrate/SKILL.md" \
  || fail "claude orchestrate entry skill differs from template"
cmp -s "$TEMPLATES/zcode-orchestrate-COMMAND.md" \
       "$REPO_ROOT/packaging/zcode/plugins/iaa/commands/orchestrate.md" \
  || fail "zcode commands/orchestrate.md differs from template"
[ -e "$REPO_ROOT/packaging/zcode/plugins/iaa/skills/orchestrate" ] \
  && fail "zcode package still contains skills/orchestrate (must be a Command since 0.1.1)"
iaa_pc_zskills=$(ls -- "$REPO_ROOT/packaging/zcode/plugins/iaa/skills" | tr '\n' ' ')
[ "$iaa_pc_zskills" = "iaa " ] || fail "zcode package skills/ must contain exactly 'iaa' (found: $iaa_pc_zskills)"
sed "s/__VERSION__/$VERSION/g" -- "$TEMPLATES/zcode-plugin-README_CN.md" | \
  cmp -s - "$REPO_ROOT/packaging/zcode/plugins/iaa/README_CN.md" \
  || fail "zcode README_CN.md differs from template stamp"
python3 - "$REPO_ROOT/packaging/zcode/plugins/iaa/.zcode-plugin/plugin.json" <<'PY' \
  || fail "zcode plugin.json must declare commands: commands (and exactly one skills dir)"
import json, sys
m = json.load(open(sys.argv[1]))
assert m.get("commands") == "commands", "missing commands declaration"
assert m.get("skills") == "skills", "missing skills declaration"
PY

# 3. manifests: name == iaa, version == VERSION ----------------------------------
check_manifest() { # $1 json path
  command -v jq >/dev/null 2>&1 || fail "jq required"
  iaa_mn_name=$(jq -r '.name // empty' "$1")
  iaa_mn_ver=$(jq -r '.version // empty' "$1")
  [ "$iaa_mn_name" = "iaa" ] || fail "$1: name is '$iaa_mn_name' (expected 'iaa')"
  if [ -n "$iaa_mn_ver" ]; then
    [ "$iaa_mn_ver" = "$VERSION" ] || fail "$1: version $iaa_mn_ver != VERSION $VERSION"
  fi
}
check_manifest "$REPO_ROOT/packaging/claude/.claude-plugin/plugin.json"
check_manifest "$REPO_ROOT/packaging/codex/plugin/.codex-plugin/plugin.json"
check_manifest "$REPO_ROOT/packaging/zcode/plugins/iaa/.zcode-plugin/plugin.json"
check_manifest "$REPO_ROOT/packaging/codex/.agents/plugins/marketplace.json"
check_manifest "$REPO_ROOT/packaging/zcode/marketplace.json"
iaa_mn_cv=$(jq -r '.plugins[0].version // empty' "$REPO_ROOT/packaging/codex/.agents/plugins/marketplace.json")
[ "$iaa_mn_cv" = "$VERSION" ] || fail "codex marketplace entry version != VERSION"
iaa_mn_zv=$(jq -r '.plugins[0].version // empty' "$REPO_ROOT/packaging/zcode/marketplace.json")
[ "$iaa_mn_zv" = "$VERSION" ] || fail "zcode marketplace entry version != VERSION"
note "OK manifests: name=iaa, version=$VERSION everywhere"

# 3b. remote marketplace: pin == published-artifact release-pin record; a fresh
#     build has the same archive CONTENT as the published artifact. DEFLATE
#     bytes are zlib-implementation-dependent (IAA-BL-016), so raw-sha equality
#     with a fresh build is a release-time check (scripts/build-release.sh),
#     not a CI check.
IAA_PIN_RECORD="$REPO_ROOT/packaging/release-pins/$VERSION.json"
[ -f "$IAA_PIN_RECORD" ] || fail "missing release-pin record $IAA_PIN_RECORD"
iaa_rm_pin=$(jq -r '.plugins[0].source.sha256 // empty' "$REPO_ROOT/packaging/zcode/marketplace.remote.json")
[ -n "$iaa_rm_pin" ] || fail "marketplace.remote.json: missing plugins[0].source.sha256"
iaa_rm_rec=$(jq -r '.sha256 // empty' "$IAA_PIN_RECORD")
[ -n "$iaa_rm_rec" ] || fail "$IAA_PIN_RECORD: missing sha256"
[ "$iaa_rm_pin" = "$iaa_rm_rec" ] \
  || fail "marketplace.remote.json sha256 ($iaa_rm_pin) != release-pin record sha256 ($iaa_rm_rec)"
[ "$(jq -r '.version // empty' "$IAA_PIN_RECORD")" = "$VERSION" ] \
  || fail "release-pin record version != VERSION ($VERSION)"
[ "$(jq -r '.asset_url // empty' "$IAA_PIN_RECORD")" = "https://github.com/isakli05/iaa/releases/download/v$VERSION/iaa-$VERSION-plugin.zip" ] \
  || fail "release-pin record asset_url is not the versioned release asset for $VERSION"
iaa_rm_url=$(jq -r '.plugins[0].source.url // empty' "$REPO_ROOT/packaging/zcode/marketplace.remote.json")
[ "$iaa_rm_url" = "https://github.com/isakli05/iaa/releases/download/v$VERSION/iaa-$VERSION-plugin.zip" ] \
  || fail "marketplace.remote.json url is not the versioned release asset for $VERSION"
[ "$(jq -r '.plugins[0].source.path // empty' "$REPO_ROOT/packaging/zcode/marketplace.remote.json")" = "iaa" ] \
  || fail "marketplace.remote.json source.path != iaa"
[ "$(jq -r '.plugins[0].version // empty' "$REPO_ROOT/packaging/zcode/marketplace.remote.json")" = "$VERSION" ] \
  || fail "marketplace.remote.json entry version != VERSION"
# archive-content parity: fresh deterministic build vs the published artifact
iaa_rm_tmp=$(mktemp)
python3 "$REPO_ROOT/scripts/build-plugin-zip.py" \
    "$REPO_ROOT/packaging/zcode/plugins/iaa" "$iaa_rm_tmp" >/dev/null 2>&1 \
  || { rm -f -- "$iaa_rm_tmp"; fail "deterministic plugin.zip build failed"; }
python3 "$REPO_ROOT/scripts/release-pin.py" compare "$iaa_rm_tmp" "$IAA_PIN_RECORD" \
  || { rm -f -- "$iaa_rm_tmp"; fail "plugin content does not match the published v$VERSION artifact (release-pin record); if the content change is intentional, a release step is required (IAA-BL-016)"; }
rm -f -- "$iaa_rm_tmp"
note "OK remote marketplace: pinned to published v$VERSION artifact; fresh build content-identical (sha256 $iaa_rm_pin)"

# 4. shim text parity: scripts/iaa vs iaa/scripts/manage.sh ----------------------
iaa_st_paragraphs() { # $1 file — prints the two routing paragraphs
  python3 - "$1" <<'PY'
import re, sys
t = open(sys.argv[1]).read()
m1 = re.search(r"For non-trivial tasks,.*?before spawning\.", t)
m2 = re.search(r'Interpret "use subagents" as permission.*?requests it by name\.', t)
if not (m1 and m2):
    sys.exit(1)
print(m1.group(0))
print(m2.group(0))
PY
}
iaa_st_ms=$(iaa_st_paragraphs "$CORE/scripts/manage.sh") || fail "could not extract shim paragraphs from manage.sh"
iaa_st_cl=$(iaa_st_paragraphs "$REPO_ROOT/scripts/iaa") || fail "could not extract shim paragraphs from scripts/iaa"
[ "$iaa_st_ms" = "$iaa_st_cl" ] || fail "shim text drift between manage.sh and scripts/iaa"
note "OK shim text parity: scripts/iaa == manage.sh"

# 5. bin/iaa == scripts/iaa in the claude package --------------------------------
cmp -s "$REPO_ROOT/scripts/iaa" "$REPO_ROOT/packaging/claude/bin/iaa" || fail "packaging/claude/bin/iaa differs from scripts/iaa"

# 6. deterministic regeneration (only meaningful in a git checkout) --------------
if command -v git >/dev/null 2>&1 && git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ -d "$REPO_ROOT/packaging/claude/evals" ]; then
    note "NOTE: transient eval staging present (campaign in flight); skipping regeneration determinism check"
  elif git -C "$REPO_ROOT" status --porcelain -- packaging .claude-plugin/marketplace.json scripts/iaa VERSION | grep -q .; then
    note "NOTE: packaging inputs have uncommitted changes; skipping regeneration determinism check"
  else
    sh "$REPO_ROOT/scripts/build-packages.sh" >/dev/null
    if git -C "$REPO_ROOT" status --porcelain -- packaging .claude-plugin/marketplace.json | grep -q .; then
      git -C "$REPO_ROOT" diff --stat -- packaging .claude-plugin/marketplace.json >&2 || true
      fail "build-packages.sh is not deterministic (tree changed on re-run)"
    fi
    note "OK deterministic regeneration"
  fi
fi

note "ALL PARITY CHECKS PASSED"
