#!/bin/sh
# İAA package builder — regenerates every distribution projection from the
# authoritative sources (repo iaa/ + VERSION + packaging/templates/).
#
# Nothing under packaging/ (outside templates/) is hand-edited; running this
# script must leave a clean tree (scripts/check-parity.sh enforces).
#
# Usage: scripts/build-packages.sh [--version-only]
#   --version-only  only re-stamp manifests from VERSION (no tree rebuild)
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
CORE="$REPO_ROOT/iaa"
TEMPLATES="$REPO_ROOT/packaging/templates"
VERSION=$(sed -n '1p' "$REPO_ROOT/VERSION")
VERSION=${VERSION%%[[:space:]]}

fail() { printf 'build-packages: %s\n' "$1" >&2; exit 1; }

[ -f "$CORE/SKILL.md" ] || fail "missing core $CORE/SKILL.md"
[ -f "$TEMPLATES/claude-plugin.json" ] || fail "missing templates"

stamp() { # $1 template, $2 destination
  mkdir -p -- "$(dirname -- "$2")"
  sed "s/__VERSION__/$VERSION/g" -- "$1" > "$2"
}

copy_core() { # $1 destination skill dir
  rm -rf -- "$1"
  mkdir -p -- "$1"
  (cd "$CORE" && find . -type f | LC_ALL=C sort) | while IFS= read -r f; do
    mkdir -p -- "$1/$(dirname -- "${f#./}")"
    cp -- "$CORE/${f#./}" "$1/${f#./}"
  done
  stamp "$TEMPLATES/PROVENANCE" "$1/PROVENANCE"
}

case "${1:-build}" in
  --version-only) ;;
esac

if [ "${1:-build}" != "--version-only" ]; then

  # ---- Claude plugin -------------------------------------------------------
  CLAUDE_PKG="$REPO_ROOT/packaging/claude"
  rm -rf -- "$CLAUDE_PKG"
  mkdir -p -- "$CLAUDE_PKG/.claude-plugin" "$CLAUDE_PKG/bin"
  stamp "$TEMPLATES/claude-plugin.json" "$CLAUDE_PKG/.claude-plugin/plugin.json"
  copy_core "$CLAUDE_PKG/skills/iaa"
  mkdir -p -- "$CLAUDE_PKG/skills/orchestrate"
  cp -- "$TEMPLATES/orchestrate-SKILL.md" "$CLAUDE_PKG/skills/orchestrate/SKILL.md"
  cp -- "$REPO_ROOT/scripts/iaa" "$CLAUDE_PKG/bin/iaa"
  chmod 0755 -- "$CLAUDE_PKG/bin/iaa"
  stamp "$TEMPLATES/claude-README.md" "$CLAUDE_PKG/README.md"
  stamp "$TEMPLATES/PROVENANCE" "$CLAUDE_PKG/PROVENANCE"

  # ---- Codex package -------------------------------------------------------
  CODEX_PKG="$REPO_ROOT/packaging/codex"
  rm -rf -- "$CODEX_PKG"
  mkdir -p -- "$CODEX_PKG/plugin/.codex-plugin" "$CODEX_PKG/marketplace/.agents/plugins"
  stamp "$TEMPLATES/codex-plugin.json" "$CODEX_PKG/plugin/.codex-plugin/plugin.json"
  copy_core "$CODEX_PKG/plugin/skills/iaa"
  stamp "$TEMPLATES/codex-marketplace.json" "$CODEX_PKG/marketplace/.agents/plugins/marketplace.json"
  stamp "$TEMPLATES/codex-README.md" "$CODEX_PKG/README.md"

  # ---- ZCode package -------------------------------------------------------
  ZCODE_PKG="$REPO_ROOT/packaging/zcode"
  rm -rf -- "$ZCODE_PKG"
  mkdir -p -- "$ZCODE_PKG/plugin/.zcode-plugin" "$ZCODE_PKG/marketplace"
  stamp "$TEMPLATES/zcode-plugin.json" "$ZCODE_PKG/plugin/.zcode-plugin/plugin.json"
  copy_core "$ZCODE_PKG/plugin/skills/iaa"
  mkdir -p -- "$ZCODE_PKG/plugin/skills/orchestrate"
  cp -- "$TEMPLATES/orchestrate-SKILL.md" "$ZCODE_PKG/plugin/skills/orchestrate/SKILL.md"
  stamp "$TEMPLATES/zcode-marketplace.json" "$ZCODE_PKG/marketplace/marketplace.json"
  stamp "$TEMPLATES/zcode-README.md" "$ZCODE_PKG/README.md"

  # ---- Gate-1 dev plugin skill copy (joins the parity umbrella) ------------
  DEVPLUGIN="$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/skills/iaa"
  copy_core "$DEVPLUGIN"

fi

# ---- Repo-root Claude marketplace (always restamped) ------------------------
stamp "$TEMPLATES/claude-marketplace.json" "$REPO_ROOT/.claude-plugin/marketplace.json"

printf 'built projections for version %s\n' "$VERSION"
printf 'next: scripts/check-parity.sh && claude plugin validate packaging/claude --strict\n'
