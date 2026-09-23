#!/bin/sh
# İAA package builder — regenerates every distribution projection from the
# authoritative sources (repo iaa/ + VERSION + packaging/templates/).
#
# Nothing under packaging/ (outside templates/ and release-pins/) is
# hand-edited; running this script must leave a clean tree
# (scripts/check-parity.sh enforces). packaging/release-pins/ holds authored
# published-artifact records and is never written by this script.
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

# MIT notice travels with every distributed copy (owner-approved Phase A):
# each package's plugin root carries the repository LICENSE + NOTICE verbatim.
copy_license() { # $1 plugin root
  cp -- "$REPO_ROOT/LICENSE" "$REPO_ROOT/NOTICE" "$1/"
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
  copy_license "$CLAUDE_PKG"
  stamp "$TEMPLATES/PROVENANCE" "$CLAUDE_PKG/PROVENANCE"

  # ---- Codex package -------------------------------------------------------
  # Marketplace root IS the package root (mirrors the official codex-warp /
  # openai-plugins layout): .agents/plugins/marketplace.json + ./plugin source.
  CODEX_PKG="$REPO_ROOT/packaging/codex"
  rm -rf -- "$CODEX_PKG"
  mkdir -p -- "$CODEX_PKG/plugin/.codex-plugin" "$CODEX_PKG/.agents/plugins"
  stamp "$TEMPLATES/codex-plugin.json" "$CODEX_PKG/plugin/.codex-plugin/plugin.json"
  copy_core "$CODEX_PKG/plugin/skills/iaa"
  stamp "$TEMPLATES/codex-marketplace.json" "$CODEX_PKG/.agents/plugins/marketplace.json"
  copy_license "$CODEX_PKG/plugin"
  stamp "$TEMPLATES/codex-README.md" "$CODEX_PKG/README.md"

  # ---- ZCode package -------------------------------------------------------
  # Official layout (zai-org/zcode-plugins): marketplace.json at the package
  # root + plugins/<name>/ with .zcode-plugin/plugin.json; source ./plugins/iaa.
  # Since 0.1.1 the explicit entry point is a Command (commands/orchestrate.md,
  # ZCode resolves plugin commands to a flat /name), NOT a second skill:
  # ZCode's documented Skill frontmatter carries only name+description, so a
  # skills/orchestrate entry would be exposed as a second auto-discoverable
  # skill (observed live at 3.14.3; post-release/zcode-official/ F4).
  # README_CN.md is mandatory for an official contribution and for parity of
  # the installable docs. marketplace.remote.json is the public remote form
  # (url/zip/sha256/path), sha-pinned to the published release artifact.
  ZCODE_PKG="$REPO_ROOT/packaging/zcode"
  rm -rf -- "$ZCODE_PKG"
  mkdir -p -- "$ZCODE_PKG/plugins/iaa/.zcode-plugin" "$ZCODE_PKG/plugins/iaa/commands"
  stamp "$TEMPLATES/zcode-plugin.json" "$ZCODE_PKG/plugins/iaa/.zcode-plugin/plugin.json"
  copy_core "$ZCODE_PKG/plugins/iaa/skills/iaa"
  cp -- "$TEMPLATES/zcode-orchestrate-COMMAND.md" "$ZCODE_PKG/plugins/iaa/commands/orchestrate.md"
  stamp "$TEMPLATES/zcode-plugin-README.md" "$ZCODE_PKG/plugins/iaa/README.md"
  stamp "$TEMPLATES/zcode-plugin-README_CN.md" "$ZCODE_PKG/plugins/iaa/README_CN.md"
  copy_license "$ZCODE_PKG/plugins/iaa"
  stamp "$TEMPLATES/zcode-marketplace.json" "$ZCODE_PKG/marketplace.json"
  # remote marketplace: the sha256 pin is stamped FROM THE RELEASE-PIN RECORD
  # of the published artifact (packaging/release-pins/<version>.json), never
  # from a fresh build. DEFLATE bytes are zlib-implementation-dependent
  # (IAA-BL-016), so ordinary regeneration must not be able to rewrite the
  # published pin; records are written only by an explicit release step
  # (scripts/release-pin.py write).
  IAA_PIN_RECORD="$REPO_ROOT/packaging/release-pins/$VERSION.json"
  [ -f "$IAA_PIN_RECORD" ] || fail "no release-pin record for v$VERSION ($IAA_PIN_RECORD); the marketplace.remote.json pin is written only by an explicit release step"
  IAA_ZIP_SHA=$(jq -r '.sha256 // empty' "$IAA_PIN_RECORD")
  [ -n "$IAA_ZIP_SHA" ] || fail "$IAA_PIN_RECORD: missing sha256"
  mkdir -p -- "$ZCODE_PKG"
  sed -e "s/__VERSION__/$VERSION/g" -e "s/__PLUGIN_ZIP_SHA256__/$IAA_ZIP_SHA/g" \
      -- "$TEMPLATES/zcode-marketplace-remote.json" > "$ZCODE_PKG/marketplace.remote.json"
  stamp "$TEMPLATES/zcode-README.md" "$ZCODE_PKG/README.md"
  # content guard: the freshly built dist zip must carry the same archive
  # CONTENT as the published artifact (compressed bytes are deliberately not
  # compared). A mismatch means the plugin tree changed — a release step is
  # required; the pin above is never rewritten to match.
  python3 "$REPO_ROOT/scripts/build-plugin-zip.py" "$ZCODE_PKG/plugins/iaa" \
      "$REPO_ROOT/dist/iaa-$VERSION-plugin.zip" >/dev/null
  python3 "$REPO_ROOT/scripts/release-pin.py" compare \
      "$REPO_ROOT/dist/iaa-$VERSION-plugin.zip" "$IAA_PIN_RECORD" \
      || fail "plugin content no longer matches the published v$VERSION artifact; the pin is not rewritten; a release step is required"

  # ---- Gate-1 dev plugin skill copy (joins the parity umbrella) ------------
  DEVPLUGIN="$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/skills/iaa"
  copy_core "$DEVPLUGIN"

fi

# ---- Repo-root Claude marketplace (always restamped) ------------------------
stamp "$TEMPLATES/claude-marketplace.json" "$REPO_ROOT/.claude-plugin/marketplace.json"

printf 'built projections for version %s\n' "$VERSION"
printf 'next: scripts/check-parity.sh && claude plugin validate packaging/claude --strict\n'
