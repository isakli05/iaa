# Gate 3 — 08: Release Artifact Reproducibility

Date: 2026-09-23. Question (Gate brief §14): rebuild the current private RC
artifacts from a clean state and verify determinism, no transient staging,
one authoritative core, projection parity, correct metadata, no private
paths/secrets.

## 1. Finding (the Gate-2 determinism claim, corrected)

The Gate-2 builder archived the three package tarballs as
`git archive "$COMMIT":packaging/<pkg>` — a **tree-ish** archive. `git
archive` stamps commit archives with the commit date but **tree archives
with the current time**, so those three artifacts were
content-reproducible but NOT byte-reproducible across rebuilds (proven: a
fresh-clone rebuild from `v0.1.0-rc.1` diverged at byte 16 — mtime — while
`diff -r` of extracted contents was empty). The Gate-2 "byte-identical
rebuild" verification result held only for the src tarball (commit-based
archive). **Category-A fix shipped this Gate** (commit `fd1b9a7`):
`scripts/build-release.sh` now repacks the three package tarballs
deterministically — fixed mtime = release commit epoch (SOURCE_DATE_EPOCH
convention; `git log -1 --format=%ct` with a numeric sanity guard after the
first attempt captured an annotated tag's message via `git show`), sorted
names, normalized `0/0` ownership, `gzip -n` (unchanged).

## 2. Verification (fresh clone at a different filesystem path, 2026-09-23)

1. `git clone --no-hardlinks <repo> /var/tmp/iaa-g3-repro` → checkout the
   Gate-3 fix commit → `./scripts/build-release.sh v0.1.0-rc.1` (builds
   from the tag tree; VERSION in scope = `0.1.0-rc.1`).
2. Ran the build **twice**, compared every artifact: **all four tarballs +
   SHA256SUMS byte-identical** between independent rebuilds.
3. Content parity vs the Gate-2 shipped artifact set (extract + `diff -r`):
   **IDENTICAL for all three package tarballs** (claude-plugin, codex,
   zcode) and the src tarball is byte-identical outright — no content
   change was introduced by the determinism fix.
4. Canonical artifact set refreshed into `dist/` (local, gitignored) with
   commit-epoch mtimes (2026-09-23 05:01 = the RC commit's time).

## 3. Canonical RC artifacts (`v0.1.0-rc.1`, deterministic build)

| Artifact | sha256 |
|---|---|
| `iaa-0.1.0-rc.1-src.tar.gz` | `a6f1a1d30d488073798ec34e42b48517378eddf57e54ac8c61380e72b4fa2577` (unchanged from Gate 2 — commit-based archive was already deterministic) |
| `iaa-0.1.0-rc.1-claude-plugin.tar.gz` | `9a20f0debbefb20383982637c71d7cfffe1497f6e129e452eff763a5e8939b74` |
| `iaa-0.1.0-rc.1-codex.tar.gz` | `245bde8c20d900769ed5cac2679c5121b0af9ced25940f28c5c66315dd712848` |
| `iaa-0.1.0-rc.1-zcode.tar.gz` | `7a5df6ccb4cbefd30ab25341de59b39d9a2f2fc294f8ebd07f8a611f9abb8c1c` |

Reproduction: checkout `v0.1.0-rc.1`-tree with the fixed builder (Gate-3
branch) → `scripts/build-release.sh v0.1.0-rc.1`.

## 4. Remaining checklist

- **No untracked/transient staging**: archives are `git archive`/repack of
  the committed tree only; verified `evals/` never appears in any archive
  (the campaign staging under `packaging/claude/evals/` is untracked +
  gitignored and absent from the tag tree).
- **No timestamps/randomness** beyond the designed ones: mtime = release
  commit epoch (deliberate, documented), `gzip -n`, sorted entries.
- **One authoritative core**: `scripts/check-parity.sh` green for all four
  projections + manifests (`name=iaa`, `version=0.1.0-rc.1` everywhere) +
  shim byte-parity.
- **No private paths in the packages**: package trees contain no `/home/
  isa` strings (src tarball intentionally contains class-A historical
  documents per `02-historical-path-policy.md` — checked, expected);
  no secrets (see `09-final-publication-safety.md`).

## 5. Effect on the RC record

The Gate-2 shipped tarballs (mtime-unstable form) and this Gate's
deterministic set are content-identical; the deterministic set supersedes
them as the canonical RC artifact hashes above. The 0.1.0 runbook builds
with the fixed script, so the public release is byte-reproducible from its
tag from day one.
