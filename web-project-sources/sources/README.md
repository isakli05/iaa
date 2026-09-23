# sources/ — provenance snapshots (NOT part of the upload set)

These are **byte-exact snapshots of the repository canonical core**, verified
identical by `cmp`/sha256 at the pack refresh date. They exist for provenance
and for environments without repository access.

- Snapshot verified: 2026-09-24, against `main` @ `479cea7` (package 0.1.1,
  policy v3; SKILL.md sha256 `73f7b887…` — the frozen v3 core).
- **Live GitHub canonical source always wins** if anything here drifts.
- With the GitHub repository connected to the Claude Project, these copies are
  redundant — fetch `iaa/SKILL.md`, `iaa/references/*`,
  `iaa/scripts/manage.sh`, `iaa/tests/scenarios.md`, `CANONICAL-README.md`
  from `main` instead. The MANIFEST therefore marks them DO NOT UPLOAD.
- `CANONICAL-README.md` here is the install-era (2026-08-26) project README —
  a historical document preserved byte-exact by policy; its runtime versions
  describe that era, not the present.

Re-verify before any use after core changes: `cmp` each file against its
`iaa/…` counterpart (or `sha256sum` against the gate-2/00 table).
