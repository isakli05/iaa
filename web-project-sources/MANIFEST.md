# MANIFEST — İAA Claude Project knowledge upload

**Pack refreshed:** 2026-09-24 · against `main` @ `479cea7` (İAA 0.1.1,
policy v3). Live `main` supersedes this pack wherever they differ.

Model: **uploaded context = orientation; GitHub = current operational truth.**
Because the repository (`isakli05/iaa`) is connected to the project, nothing
large or fetchable-on-demand belongs in the upload set — no source snapshots,
no reports, no compatibility tables.

A ready-to-upload copy of every file below, in order, is exported at
`.claude-web-project-upload/` (not committed) with `UPLOAD-MANIFEST.txt`.

## REQUIRED (upload first, in this order)

1. **`CLAUDE-PROJECT-INSTRUCTIONS.md`** — how the assistant must behave in
   this project (authority, evidence, authorization rules). *Stable.*
2. **`00-READ-ME-FIRST.md`** — operating guide: authority hierarchy,
   current-vs-historical rules, reading order. *Stable.*
3. **`01-IAA-PROJECT-BRIEF.md`** — charter: identity, purpose, non-goals,
   long-term direction; the anti-feature-creep anchor. *Stable.*
4. **`11-CURRENT-STATE.md`** — the ONLY volatile file: version, tested
   matrix, open external work, backlog snapshot; tells every other file's
   staleness apart from real drift. *Volatile — refresh per IAA-BL-012.*
5. **`12-GOVERNANCE-AND-BACKLOG.md`** — decision lifecycle, evaluation
   question, backlog semantics, the what-next / new-idea workflows. *Stable.*

## RECOMMENDED (upload next)

6. **`02-CURRENT-ARCHITECTURE.md`** — repo/package + policy architecture and
   invariant pointers. *Stable.*
7. **`03-BEHAVIORAL-CONTRACT.md`** — condensed C1–C41 contract with
   verification labels. *Stable.*
8. **`05-IAA-SDD-BOUNDARY.md`** — the boundary rules + contrast table the
   product was built against. *Stable.*
9. **`06-INTEGRATIONS-CLAUDE-CODE-CODEX-ZCODE.md`** — mechanism map per
   runtime, both distribution forms. *Stable.*
10. **`07-HISTORY-AND-EVIDENCE.md`** — full timeline + evidence location +
    quality caveats; needed to interpret historical documents correctly.
    *Stable (timeline ends 2026-09-23; later events in 11).*
11. **`08-TESTS-AND-VALIDATION.md`** — validation stack + release principles
    (version-pinned claims, D=NONE parity, publication safety). *Stable.*
12. **`09-KNOWN-LIMITATIONS-AND-OPEN-QUESTIONS.md`** — current limitations
    with resolutions marked; open questions mapped to backlog IDs. *Stable.*

## OPTIONAL (deep context)

13. **`10-COMPARISON-RESEARCH-BRIEF.md`** — research landscape: comparison
    outcomes, adoption verdicts, JEV candidate, competitor-research policy.
    *Stable (dated 2026-09-22 record + standing policy).*
14. **`04-SOURCE-OF-TRUTH-AND-FILE-MAP.md`** — repository map by authority
    class + glossary. *Stable.*

## DO NOT UPLOAD (fetch live from GitHub instead)

- **`sources/*`** (all six snapshots + `sources/README.md`) — byte-exact core
  copies kept for provenance only; with GitHub connected they are a redundant
  second authority waiting to go stale. Fetch `iaa/SKILL.md` etc. live.
- **`MANIFEST.md`** (this file) — owner instructions, not assistant context.
- **`CLAUDE-PROJECT-SETUP.md`** — one-time project-creation material (project
  name, evergreen goal text, first prompt).

## Repository to connect

```text
isakli05/iaa
```

Live canonical anchors the assistant should use on `main`: `VERSION`,
`README.md`, `iaa/` (core), `docs/GOVERNANCE.md`, `docs/BACKLOG.md`,
`docs/COMPATIBILITY.md`, `docs/KNOWN-LIMITATIONS.md`, `docs/SOURCE-OF-TRUTH.md`.

## Refresh discipline

After each release, policy-revision change, or major upstream event
(standing backlog item IAA-BL-012): refresh **only** `11-CURRENT-STATE.md`
(and this manifest if the file set changed), re-verify `sources/` parity if
the core changed, then re-upload the refreshed files. Never scatter version
values into the stable files.
