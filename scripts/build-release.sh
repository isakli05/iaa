#!/bin/sh
# İAA private release-candidate builder (Gate 2 §21).
#
# Produces, deterministically from a clean git commit:
#   dist/iaa-<version>-src.tar.gz        full repository source (git archive)
#   dist/iaa-<version>-claude-plugin.tar.gz  the Claude plugin package
#   dist/iaa-<version>-codex.tar.gz      the Codex package (plugin + marketplace)
#   dist/iaa-<version>-zcode.tar.gz      the ZCode plugin + marketplace
#   dist/SHA256SUMS                      checksums
#
# Reproducibility: `git archive` content is a pure function of the commit tree;
# gzip is fed a fixed timestamp. Rebuilding from the same commit yields
# byte-identical artifacts (verifiable via SHA256SUMS).
#
# Usage: scripts/build-release.sh [commit-ish]   (default: HEAD)
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
VERSION=$(sed -n '1p' "$REPO_ROOT/VERSION"); VERSION=${VERSION%%[[:space:]]}
COMMIT=${1:-HEAD}

cd "$REPO_ROOT"

# gate: refuse to build from a dirty tree (the RC must be reproducible)
if [ -n "$(git status --porcelain -- iaa packaging scripts VERSION .claude-plugin docs tests)" ]; then
  printf 'build-release: working tree dirty for release inputs; commit first\n' >&2
  exit 1
fi
SHA=$(git rev-parse "$COMMIT")
printf 'building RC %s from %s\n' "$VERSION" "$SHA"

mkdir -p dist
GZIP='gzip -n'

git archive --format=tar --prefix="iaa-$VERSION/" "$COMMIT" | $GZIP > "dist/iaa-$VERSION-src.tar.gz"
git archive --format=tar --prefix="iaa-$VERSION/" "$COMMIT":packaging/claude | $GZIP > "dist/iaa-$VERSION-claude-plugin.tar.gz"
git archive --format=tar --prefix="iaa-$VERSION/" "$COMMIT":packaging/codex | $GZIP > "dist/iaa-$VERSION-codex.tar.gz"
git archive --format=tar --prefix="iaa-$VERSION/" "$COMMIT":packaging/zcode | $GZIP > "dist/iaa-$VERSION-zcode.tar.gz"

(cd dist && sha256sum "iaa-$VERSION"-*.tar.gz > SHA256SUMS)
printf 'artifacts:\n'
sed 's/^/  /' dist/SHA256SUMS
printf '\ntag when ready: git tag -s v%s %s -m "İAA %s" && git push origin v%s\n' "$VERSION" "$SHA" "$VERSION" "$VERSION"
