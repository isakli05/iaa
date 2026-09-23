# 00 — READ ME FIRST (İAA Claude Project pack)

This pack is the **durable orientation layer** for a long-lived Claude Project
about **İAA — İştirak-i A‘mâl-i Ajanîye**, a public, MIT-licensed
delegation-decision policy for agent CLIs. It is not a snapshot of one release
and not a substitute for the repository.

**The division of labor:**

- **Uploaded context (this pack) = orientation.** What İAA is, why it exists,
  its invariants, its vocabulary, how decisions are made, where truth lives.
- **GitHub `main` (connected) = operational truth.** Current source, version,
  compatibility claims, backlog, evidence. Fetch it before answering anything
  version- or status-dependent.

## Authority hierarchy (memorize this)

When sources disagree, the higher row wins:

1. Current canonical files on GitHub `main` (`iaa/` core, `VERSION`, current docs)
2. Current repository governance docs (`docs/GOVERNANCE.md`, `docs/BACKLOG.md`,
   `docs/SOURCE-OF-TRUTH.md`)
3. Current release/validation evidence (dated reports under `release-hardening/`,
   `post-release/`)
4. This uploaded pack
5. Historical/provenance material (`audit/`, `historical-notes/`,
   `identity-migration/`, `comparison/`, ADRs)

If any pack file conflicts with current GitHub, **GitHub wins** — a pack file
may simply be stale. Historical evidence, however, is never "corrected" to
match current state: a dated report records what was true when written.

## How to use the connected GitHub repository

Before answering status questions or proposing work: check `main`'s `VERSION`,
`README.md`, `docs/COMPATIBILITY.md`, and `docs/BACKLOG.md`. Treat a detailed
old report as history, not news. Fetch canonical files (`iaa/SKILL.md`,
references, tests) live when precision matters — the pack's `sources/`
snapshots exist for provenance and are not uploaded.

## Current vs historical — the traps

- İAA was publicly released 2026-09-23 (0.1.0, then 0.1.1 same day). Anything
  describing it as private, as `0.1.0-rc.1`, or as unreleased is historical.
- İAA was known as MAO before the 2026-09-23 rename; August-2026 evidence
  preserves that name by design. MAO is legacy vocabulary, never current
  identity.
- Gate 1/2/3 and the 0.1.1 packaging fixed many earlier limitations; a
  limitation listed in an old document may since be resolved — check
  `docs/KNOWN-LIMITATIONS.md` on `main`.

## Staleness model

Every file here carries a refresh date + repository ref. **Only
`11-CURRENT-STATE.md` is volatile** (versions, PRs, open work). All other
files are stable by design and must not accumulate version-specific values —
those belong in 11 or on GitHub.

## Reading order

`01` (charter) → `02` (architecture) → `03` (behavioral contract) →
`12` (governance + backlog workflow) → `11` (current state) → then as needed:
`05` (SDD boundary), `06` (integrations), `07` (history), `08`
(validation/release principles), `09` (limitations/open questions), `10`
(research landscape), `04` (file map/glossary).

**Pack refreshed:** 2026-09-24 · against `main` @ `479cea7` (İAA 0.1.1,
policy v3). Live `main` supersedes anything here.
