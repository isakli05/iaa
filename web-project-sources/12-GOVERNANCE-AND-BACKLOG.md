# 12 — Development Governance and Backlog Guide

Condensed from `docs/GOVERNANCE.md` + `docs/BACKLOG.md` on GitHub (the live
authorities). This file teaches the workflow; the repository holds the rules.

## Decision lifecycle (lightweight, owner-gated)

```text
idea → research candidate → experiment → accepted design → implementation
     → validated behavior → released behavior → (historical evidence)
```

- An idea is not a commitment; research candidates stay labeled RESEARCH until
  evidence supports adoption.
- Experiments never ship as dependencies/defaults without owner acceptance
  backed by evidence.
- Semantic changes (touching the behavioral meaning of the core) require a
  policy-revision bump + justification against the 18 frozen invariants
  (`release-hardening/gate-2/00-semantic-freeze.md`).
- **Default evaluation question for any new capability:** *does this make
  İAA's orchestration decision more reliable or effective, or does it merely
  make İAA a larger framework?* Capabilities that add agents, state, daemons,
  schedulers, roles, cadences, or per-runtime forks are presumed against.
- The owner is the final product decision-maker.

## The backlog

- **Canonical path:** `docs/BACKLOG.md` in the repository (GitHub Issues/PRs
  are execution artifacts; a useful Issue cross-links its `IAA-BL-###`; they
  never replace product intent).
- **Stable IDs** `IAA-BL-001…`; statuses: OPEN / WAITING(external) / OWNER
  DECISION / PROPOSED / RESEARCH / STANDING / DEFERRED / CLOSED.
- Completed requires repository evidence. External waits name what/whom. A
  SETTLED section records do-not-re-propose decisions; an ARCHIVED section
  keeps one-line pointers to completed work.

## Workflow: "check the backlog and tell me what we should work on next"

1. Inspect GitHub `main` (HEAD, recent commits) and `VERSION`.
2. Read `docs/BACKLOG.md`.
3. Check the linked external state where claims depend on it (e.g. `gh pr
   view 42 --repo zai-org/zcode-plugins`), and `docs/COMPATIBILITY.md` for
   version-sensitive items.
4. Separate **actual blockers** from merely **pending external work** (a wait
   that blocks nothing İAA-side is not a blocker).
5. Classify candidates: maintenance vs research vs product development vs
   owner decision.
6. Present the owner the relevant decision with evidence — do not silently
   start implementation.
7. Record any accepted new work in the backlog before executing.
8. Keep external wait states explicit in the answer.

## Workflow: a new idea from the owner

Triage to exactly one, and say which:

- **already covered** by backlog item `IAA-BL-###`;
- **conflicts with invariant/decision** Y (name it — invariants list, SETTLED
  table, or charter non-goals);
- **needs research first** → new RESEARCH item with success metrics;
- **ready for implementation** → new OPEN item with acceptance criteria;
- **duplicate / obsolete** (cite what supersedes it);
- **worthy of a new backlog item** (propose the entry; owner approves).

Proposing a new item = drafting it into `docs/BACKLOG.md` fields (problem,
evidence, why, dependencies, acceptance) — the owner accepts or drops it.

## Rules of conduct for this project (full list: CLAUDE-PROJECT-INSTRUCTIONS)

Long-lived product, GitHub `main` is truth, check current state before status
claims, distinguish current vs historical, explain consequences before
proposing implementation, preserve invariants unless the owner authorizes
change, never promote experiments without evidence, never turn İAA into a
general workflow framework, research upstream when compatibility claims
depend on it, no invented evidence, no irreversible publication actions
without owner authorization.

**Stable file** — the live queue is on GitHub.
