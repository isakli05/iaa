#!/bin/sh
# İAA private release-candidate builder (Gate 2 §21).
#
# Produces, deterministically from a clean git commit:
#   dist/iaa-<version>-src.tar.gz        full repository source (git archive)
#   dist/iaa-<version>-claude-plugin.tar.gz  the Claude plugin package
#   dist/iaa-<version>-codex.tar.gz      the Codex package (plugin + marketplace)
#   dist/iaa-<version>-zcode.tar.gz      the ZCode plugin + marketplace
#   dist/iaa-<version>-plugin.zip        ZCode remote-install archive (content-
#                                         deterministic; compressed bytes depend
#                                         on the zlib implementation, IAA-BL-016)
#                                         (official build_dist discipline; sha256 must
#                                         match the pin in marketplace.remote.json)
#   dist/marketplace.remote.json         the public remote marketplace document from
#                                         the same commit (verification copy; the
#                                         served copy is the raw.githubusercontent
#                                         URL of this file on main)
#   dist/SHA256SUMS                      checksums of the release assets
#
# Reproducibility: the src tarball is `git archive <commit>` (entries stamped
# with the commit date — a pure function of the commit). The three package
# tarballs are repacked deterministically (fixed mtime = release commit epoch,
# sorted names, normalized ownership, `gzip -n`). Rebuilding from the same
# commit yields byte-identical artifacts for all four (Gate 3 §14; the
# Gate-2 builder archived `$COMMIT:<subdir>` tree-ish, which git stamps with
# the current time — content-reproducible but not byte-reproducible).
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

# Determinism note (Gate 3 §14 fix): `git archive <commit>` stamps entries
# with the commit date (deterministic), but `git archive <commit>:<subdir>`
# archives a TREE, which git stamps with the CURRENT time — byte-nondeterministic
# across rebuilds (content stays identical). The package tarballs are therefore
# repacked with a fixed mtime (= the release commit's epoch, SOURCE_DATE_EPOCH
# convention), sorted names, and normalized ownership, making all four
# artifacts byte-reproducible from the same commit.
EPOCH=$(git log -1 --format=%ct "$COMMIT" 2>/dev/null)
case "$EPOCH" in ''|*[!0-9]*) printf 'build-release: cannot resolve commit epoch for %s\n' "$COMMIT" >&2; exit 1;; esac
repack_deterministic() { # <tree-ish> <outfile>
  _tmp=$(mktemp -d)
  git archive --format=tar --prefix="pkg/" "$1" | tar -x -C "$_tmp"
  mkdir -p "$_tmp/out"
  mv "$_tmp/pkg" "$_tmp/out/iaa-$VERSION"
  ( cd "$_tmp/out" && tar --sort=name --mtime="@$EPOCH" \
      --owner=0 --group=0 --numeric-owner -cf - "iaa-$VERSION" ) | $GZIP > "dist/$2"
  rm -rf "$_tmp"
}

git archive --format=tar --prefix="iaa-$VERSION/" "$COMMIT" | $GZIP > "dist/iaa-$VERSION-src.tar.gz"
repack_deterministic "$COMMIT":packaging/claude "iaa-$VERSION-claude-plugin.tar.gz"
repack_deterministic "$COMMIT":packaging/codex  "iaa-$VERSION-codex.tar.gz"
repack_deterministic "$COMMIT":packaging/zcode "iaa-$VERSION-zcode.tar.gz"

# ZCode plugin.zip from the commit's plugin tree (0.1.1+), built with the
# official build_dist discipline (scripts/build-plugin-zip.py). The committed
# marketplace.remote.json sha256 pin must equal the built archive's raw bytes —
# a stale pin aborts the release build. This is the release-time byte
# verification: it holds in the zlib environment that produced the released
# archive (archive bytes are zlib-implementation-dependent — IAA-BL-016;
# CI instead verifies archive-content parity via the release-pin record).
IAA_ZIP_STAGE=$(mktemp -d)
mkdir -p "$IAA_ZIP_STAGE/iaa"
git archive --format=tar "$COMMIT":packaging/zcode/plugins/iaa | tar -x -C "$IAA_ZIP_STAGE/iaa"
IAA_ZIP_SHA=$(python3 "$REPO_ROOT/scripts/build-plugin-zip.py" \
    "$IAA_ZIP_STAGE/iaa" "dist/iaa-$VERSION-plugin.zip")
rm -rf "$IAA_ZIP_STAGE"
git show "$COMMIT":packaging/zcode/marketplace.remote.json > dist/marketplace.remote.json
IAA_ZIP_PINNED=$(jq -r '.plugins[0].source.sha256 // empty' dist/marketplace.remote.json)
if [ -z "$IAA_ZIP_PINNED" ] || [ "$IAA_ZIP_SHA" != "$IAA_ZIP_PINNED" ]; then
  printf 'build-release: marketplace.remote.json sha256 pin (%s) != built plugin.zip (%s)\n' \
      "${IAA_ZIP_PINNED:-missing}" "$IAA_ZIP_SHA" >&2
  printf 'build-release: archive bytes depend on the zlib implementation (IAA-BL-016); this byte check must run in the environment that produced the released archive\n' >&2
  exit 1
fi

(cd dist && sha256sum "iaa-$VERSION"-*.tar.gz "iaa-$VERSION-plugin.zip" > SHA256SUMS)
printf 'artifacts:\n'
sed 's/^/  /' dist/SHA256SUMS
printf '\ntag when ready: git tag -s v%s %s -m "İAA %s" && git push origin v%s\n' "$VERSION" "$SHA" "$VERSION" "$VERSION"
