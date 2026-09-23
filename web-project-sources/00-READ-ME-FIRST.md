# 00 — READ ME FIRST (İAA Claude Project pack)

This pack is the **durable orientation layer** for a long-lived Claude Project
about **İAA — İştirak-i A‘mâl-i Ajanîye**, a public, MIT-licensed
delegation-decision policy for agent CLIs. It is not a snapshot of one release
and not a substitute for the repository.

**The division of labor:**

- **Uploaded context (this pack) = orientation.** What İAA is, why it exists,
  its invariants, its vocabulary, how decisions are made, where truth lives.
- **Live public GitHub `main` = operational truth — the sole source of
  current state.** The repository is public, so live public reads (procedure
  below) are the authoritative access path for current `main`/HEAD,
  `VERSION`, canonical files (`iaa/`), `docs/BACKLOG.md`,
  `docs/COMPATIBILITY.md`, `docs/KNOWN-LIMITATIONS.md`, releases/tags,
  PRs/issues, and CI state. The pack deliberately contains **no
  current-state snapshot** — nothing uploaded can go stale.
- **Project GitHub integration = optional convenience snapshot, never an
  authority.** If the Claude Project has the repository connected, its files
  are a copy as of the last manual "Sync now". The project does not depend
  on it, nobody is obliged to sync it, its contents are never current merely
  because they are present, and a live read always overrides it.

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
may simply be stale. "Current GitHub" means a live read of `main`; a Project
GitHub-integration snapshot is a copy, not current GitHub, and yields to a
live read. Historical evidence, however, is never "corrected" to
match current state: a dated report records what was true when written.

## Live-read procedure (current state)

Before answering status questions or proposing work, read live — public,
no authentication needed:

1. **Pin HEAD:** `git ls-remote https://github.com/isakli05/iaa refs/heads/main`
   (add `'refs/tags/*'` for tags). Every current-state answer names this SHA.
2. **Read files at that commit:** preferably `git clone --depth 1
   https://github.com/isakli05/iaa` (one consistent tree); or
   `https://raw.githubusercontent.com/isakli05/iaa/<sha>/<path>`. Read raw
   files by SHA, not by `main` — raw `main` URLs are CDN-cached for up to
   5 minutes. Minimum set: `VERSION`, `README.md`, `docs/BACKLOG.md`,
   `docs/COMPATIBILITY.md`, `docs/KNOWN-LIMITATIONS.md`; canonical files
   (`iaa/SKILL.md`, references, tests) when precision matters.
3. **Releases, PRs/issues, CI:** the public github.com pages (`/releases`,
   `/tags`, `/pull/<n>`, `/issues/<n>`, `/actions`) and the commits Atom
   feed (`/commits/main.atom`); the unauthenticated GitHub REST API only as
   a fallback — it is rate-limited and often exhausted on shared egress.
   State the read time for PR/issue/CI facts.
4. **Failure:** if live reads fail, say so and mark the current-state answer
   UNVERIFIED. Never substitute pack content, a Project GitHub-integration
   snapshot, or memory as current.

Treat a detailed old report as history, not news. The pack's `sources/`
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

Every file here is stable by design and carries no fast-changing values —
no versions, PR/issue states, releases, or backlog statuses anywhere in the
pack. Current operational state is always read live from public GitHub, so
the pack needs **no routine refresh or re-upload** after releases or
upstream events, and no Project GitHub-integration sync is ever required. (The repository separately keeps a dated provenance snapshot,
`11-CURRENT-STATE.md`; it is *not* part of the upload set.)

## Reading order

`01` (charter) → `02` (architecture) → `03` (behavioral contract) →
`12` (governance + backlog workflow) → then as needed:
`05` (SDD boundary), `06` (integrations), `07` (history), `08`
(validation/release principles), `09` (limitations/open questions), `10`
(research landscape), `04` (file map/glossary).

**Pack revised:** 2026-09-24 (access-model revision — live public reads are
the current-state path; the Project GitHub integration is optional and never
authoritative) · against `main` @ `0833081`. Live `main` supersedes anything
here.
