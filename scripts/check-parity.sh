#!/bin/sh
# İAA one-core parity + identity + version enforcement (CI layer A).
#
# Fails (non-zero) when:
#  - any packaging projection of the behavioral core is not byte-exact to iaa/
#  - a projection lacks its PROVENANCE marker or the version disagrees
#  - any manifest name/version disagrees with VERSION / the fixed identity
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
check_projection "$REPO_ROOT/packaging/zcode/plugin/skills/iaa" "packaging/zcode"
check_projection "$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/skills/iaa" "dev-plugin"

# 2. shared orchestrate entry identical across runtimes --------------------------
cmp -s "$REPO_ROOT/packaging/claude/skills/orchestrate/SKILL.md" \
       "$REPO_ROOT/packaging/zcode/plugin/skills/orchestrate/SKILL.md" \
  || fail "orchestrate entry skill differs between claude and zcode packages"

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
check_manifest "$REPO_ROOT/packaging/zcode/plugin/.zcode-plugin/plugin.json"
check_manifest "$REPO_ROOT/packaging/codex/marketplace/.agents/plugins/marketplace.json"
check_manifest "$REPO_ROOT/packaging/zcode/marketplace/marketplace.json"
iaa_mn_cv=$(jq -r '.plugins[0].version // empty' "$REPO_ROOT/packaging/codex/marketplace/.agents/plugins/marketplace.json")
[ "$iaa_mn_cv" = "$VERSION" ] || fail "codex marketplace entry version != VERSION"
iaa_mn_zv=$(jq -r '.plugins[0].version // empty' "$REPO_ROOT/packaging/zcode/marketplace/marketplace.json")
[ "$iaa_mn_zv" = "$VERSION" ] || fail "zcode marketplace entry version != VERSION"
note "OK manifests: name=iaa, version=$VERSION everywhere"

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
  if git -C "$REPO_ROOT" status --porcelain -- packaging .claude-plugin/marketplace.json scripts/iaa VERSION | grep -q .; then
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
