# 00 — READ ME FIRST (İAA Claude Project pack)

This pack is the **durable orientation layer** for a long-lived Claude Project
about **İAA — İştirak-i A‘mâl-i Ajanîye**, a public, MIT-licensed
delegation-decision policy for agent CLIs. It is not a snapshot of one release
and not a substitute for the repository.

**The division of labor:**

- **Uploaded context (this pack) = orientation.** What İAA is, why it exists,
  its invariants, its vocabulary, how decisions are made, where truth lives.
- **GitHub `main` (connected) = operational truth — the sole source of current
  state.** Current source, version, compatibility claims, backlog, evidence.
  For every question involving current state, inspect the live repository as
  applicable: `VERSION`, `docs/BACKLOG.md`, `docs/COMPATIBILITY.md`,
  `docs/KNOWN-LIMITATIONS.md`, current releases/tags, relevant open
  PRs/issues, and the canonical source (`iaa/`). The pack deliberately
  contains **no current-state snapshot** — nothing uploaded can go stale.

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
`README.md`, `docs/BACKLOG.md`, `docs/COMPATIBILITY.md`, and
`docs/KNOWN-LIMITATIONS.md`, plus current releases/tags and the live state of
relevant open PRs/issues. Treat a detailed old report as history, not news.
Fetch canonical files (`iaa/SKILL.md`, references, tests) live when precision
matters — the pack's `sources/` snapshots exist for provenance and are not
uploaded.

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

Every file here is stable by design and carries no fast-changing values —
no versions, PR/issue states, releases, or backlog statuses anywhere in the
pack. Current operational state is always fetched live from GitHub, so the
pack needs **no routine refresh or re-upload** after releases or upstream
events. (The repository separately keeps a dated provenance snapshot,
`11-CURRENT-STATE.md`; it is *not* part of the upload set.)

## Reading order

`01` (charter) → `02` (architecture) → `03` (behavioral contract) →
`12` (governance + backlog workflow) → then as needed:
`05` (SDD boundary), `06` (integrations), `07` (history), `08`
(validation/release principles), `09` (limitations/open questions), `10`
(research landscape), `04` (file map/glossary).

**Pack revised:** 2026-09-24 (durability revision — current-state snapshot
removed from the upload set) · against `main` @ `b913778`. Live `main`
supersedes anything here.
