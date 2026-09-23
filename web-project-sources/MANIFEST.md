# MANIFEST — İAA Claude Project knowledge upload

**Pack revised:** 2026-09-24 (access-model revision) · against `main` @
`0833081`. Live `main` supersedes this pack wherever they differ.

Model:

- **Project Knowledge (this pack) = durable orientation** — charter,
  architecture, invariants, governance, history, research policy.
- **Live public GitHub `main` = current operational truth** — the **sole
  source of current state**. Every current-state question (versions,
  backlog status, releases/tags, PRs/issues, CI, compatibility) is answered
  by a live public read of the repository (procedure in `00`), never from
  the pack.
- **Project GitHub integration = optional convenience snapshot.** Not
  required, no sync obligation, never current merely because present;
  a live read always overrides it.
- The upload set therefore deliberately contains **no current-state
  snapshot** and carries no fast-changing values — nothing to refresh or
  re-upload after releases or upstream events.
- Because the public repository (`isakli05/iaa`) is read live, nothing
  large or fetchable-on-demand belongs in the upload set — no source snapshots, no
  reports, no compatibility tables.

A ready-to-upload copy of every file below, in order, is exported at
`.claude-web-project-upload/` (not committed) with `UPLOAD-MANIFEST.txt`.

## REQUIRED (upload first, in this order)

1. **`CLAUDE-PROJECT-INSTRUCTIONS.md`** — how the assistant must behave in
   this project (live-read rule for current state, authority, evidence,
   authorization rules). *Stable.*
2. **`00-READ-ME-FIRST.md`** — operating guide: authority hierarchy,
   current-vs-historical rules, reading order. *Stable.*
3. **`01-IAA-PROJECT-BRIEF.md`** — charter: identity, purpose, non-goals,
   long-term direction; the anti-feature-creep anchor. *Stable.*
4. **`12-GOVERNANCE-AND-BACKLOG.md`** — decision lifecycle, evaluation
   question, backlog semantics, the what-next / new-idea workflows. *Stable.*

## RECOMMENDED (upload next)

5. **`02-CURRENT-ARCHITECTURE.md`** — repo/package + policy architecture and
   invariant pointers. *Stable.*
6. **`03-BEHAVIORAL-CONTRACT.md`** — condensed C1–C41 contract with
   verification labels. *Stable.*
7. **`05-IAA-SDD-BOUNDARY.md`** — the boundary rules + contrast table the
   product was built against. *Stable.*
8. **`06-INTEGRATIONS-CLAUDE-CODE-CODEX-ZCODE.md`** — mechanism map per
   runtime, both distribution forms. *Stable.*
9. **`07-HISTORY-AND-EVIDENCE.md`** — full timeline + evidence location +
   quality caveats; needed to interpret historical documents correctly.
   *Stable (timeline is a dated record; later events are read live).*
10. **`08-TESTS-AND-VALIDATION.md`** — validation stack + release principles
    (version-pinned claims, D=NONE parity, publication safety). *Stable.*
11. **`09-KNOWN-LIMITATIONS-AND-OPEN-QUESTIONS.md`** — limitations with
    resolutions marked; open questions mapped to backlog IDs. *Stable
    (current statuses are read live from GitHub).*

## OPTIONAL (deep context)

12. **`10-COMPARISON-RESEARCH-BRIEF.md`** — research landscape: comparison
    outcomes, adoption verdicts, JEV candidate, competitor-research policy.
    *Stable (dated 2026-09-22 record + standing policy).*
13. **`04-SOURCE-OF-TRUTH-AND-FILE-MAP.md`** — repository map by authority
    class + glossary. *Stable.*

## DO NOT UPLOAD (fetch live from GitHub instead)

- **`11-CURRENT-STATE.md`** — a dated repository-side provenance snapshot;
  uploading it would reintroduce the manual-staleness burden this design
  removes. Current state comes from a live read of the repository, always.
- **`sources/*`** (all six snapshots + `sources/README.md`) — byte-exact
  core copies kept for provenance only; with live reads available they are
  a redundant second authority waiting to go stale. Fetch `iaa/SKILL.md` etc.
  live.
- **`MANIFEST.md`** (this file) — owner instructions, not assistant context.
- **`CLAUDE-PROJECT-SETUP.md`** — one-time project-creation material (project
  name, evergreen goal text, first prompt).

## Repository (live-read target; Project GitHub integration optional)

```text
isakli05/iaa
```

Live canonical anchors the assistant must read on `main` for current state:
`VERSION`, `README.md`, `iaa/` (core), `docs/GOVERNANCE.md`,
`docs/BACKLOG.md`, `docs/COMPATIBILITY.md`, `docs/KNOWN-LIMITATIONS.md`,
`docs/SOURCE-OF-TRUTH.md`, plus current releases/tags and relevant open
PRs/issues as applicable.

## No routine refresh

The pack is durable. Nothing is refreshed or re-uploaded after releases,
policy-revision changes, or upstream events — current state is read live
from GitHub by design. Update (and re-upload) a pack file only when its
**durable** content itself changes (charter, architecture, governance,
history narrative), and never let version/PR/release/backlog values creep
into it. Residual repo-side hygiene (sources/ parity when the core changes)
is standing backlog item IAA-BL-012.
