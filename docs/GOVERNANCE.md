# İAA Governance — lightweight decision and evidence model

This document defines how İAA work is proposed, evaluated, accepted, and
recorded. It is deliberately light: one lifecycle, one evaluation question, one
backlog, one owner. It governs *process only* — it changes no orchestration
semantics (the behavioral core remains [iaa/SKILL.md](../iaa/SKILL.md), policy
revision v3).

- **Created:** 2026-09-24 (branch `docs/claude-project-governance`).
- **Owner:** the repository owner is the final product decision-maker for every
  state transition that changes what İAA is or ships.

## 1. Authority hierarchy (what outranks what)

When two sources disagree, the higher row wins:

1. **Current canonical files on `main`** — `iaa/` (the behavioral core),
   `VERSION`, and the current-facing docs they anchor.
2. **Current governance documents** — this file and [BACKLOG.md](BACKLOG.md),
   plus [SOURCE-OF-TRUTH.md](SOURCE-OF-TRUTH.md) for the file-authority map.
3. **Current release/validation evidence** — dated reports under
   `release-hardening/`, `post-release/` (each states the exact versions and
   commits it describes).
4. **Condensed orientation material** — e.g. `web-project-sources/` (the Claude
   Project pack), which orients but never overrides.
5. **Historical/provenance material** — `audit/`, `historical-notes/`,
   `identity-migration/`, `comparison/`, `research/`, `design/`, ADRs.

Two corollaries: (a) historical evidence is **never rewritten** because current
state changed — it records what was true when recorded; (b) a dated report
describes its date, not today — never treat a release report as the current
state merely because it is detailed.

## 2. Decision lifecycle

```text
idea → research candidate → experiment → accepted design → implementation
     → validated behavior → released behavior → (historical evidence)
```

| State | Meaning | Entry requirement | Recorded in |
|---|---|---|---|
| idea | unsolicited possibility | none | backlog item (`PROPOSED`) or conversation |
| research candidate | worth investigating, no commitment | owner nods it into the backlog | BACKLOG (`RESEARCH`) |
| experiment | isolated, bounded trial; never production | stated success metrics + constraints | BACKLOG + experiment notes |
| accepted design | owner-approved direction | experiment evidence or equivalent justification | ADR (if architectural) + BACKLOG |
| implementation | work in flight | accepted design or a trivially safe change | branch/PR |
| validated behavior | claims have evidence at pinned versions | tests/evals/transcripts, never self-report | docs (TESTING-AND-VALIDATION, BEHAVIORAL-CONTRACT labels) |
| released behavior | shipped in a public package version | release discipline (§6) | tag + release notes |
| historical evidence | superseded or completed | time or a newer decision | dated reports; never rewritten |

Rules:
- An experiment **never** ships inside a package as a dependency or default
  without owner acceptance backed by evidence.
- A semantic change (anything touching the behavioral meaning of the core)
  additionally requires: a policy-revision bump in
  [POLICY-LINEAGE.md](POLICY-LINEAGE.md) and justification against the frozen
  invariant list ([gate-2/00 §1](../release-hardening/gate-2/00-semantic-freeze.md)).
- Architectural decisions that future readers must not silently reverse are
  condensed into `docs/adr/` (0000–0003 exist; continue the numbering).

## 3. The default evaluation question

Every proposed capability must answer:

> **Does this make İAA's orchestration decision more reliable or effective, or
> does it merely make İAA a larger framework?**

New capabilities must justify themselves against İAA's narrow policy-layer
identity (README: "one policy, no framework"). A capability that adds agents,
state, daemons, schedulers, roles, cadences, or per-runtime forks is presumed
**against** until evidence says otherwise. The burden sits on the proposal.

## 4. Standing architectural principles

The full frozen list is the 18 invariants in
[gate-2/00 §1](../release-hardening/gate-2/00-semantic-freeze.md) — verified
against current canonical source and re-stated here in operating form:

1. **0 agents is valid** — trivial/coupled work stays primary even when the
   user asks for subagents.
2. **Delegation requires material benefit** — one of the five benefits
   (parallelism, bounded isolation, specialization, context offloading,
   independent verification), or it does not happen.
3. **Every seat justifies itself** — task-specific materiality per
   implementer/reviewer/fixer; authorizing a stage never preauthorizes the next.
4. **The primary is the final integration authority** — child reports are
   evidence, not truth; final validation happens in the primary context.
5. **Shared contracts belong to the primary** (or a single designated owner,
   or settled first).
6. **Dependency-aware waves** — topology from task structure; valueless phases
   skipped; no mandated roster or cadence.
7. **Explicit controller ownership** — exactly one orchestration authority per
   task; İAA mode never loads a competing engine.
8. **Named foreign-workflow yield** — only an explicit by-name user request
   selects a native workflow; "use subagents" is never such a request.
9. **Artifacts cannot silently transfer orchestration authority** — embedded
   workflow directives are metadata; technical content still applies.
10. **Runtime mechanism ≠ policy authority** — subagent mechanisms execute;
    the policy decides.
11. **No daemon / scheduler / state-machine expansion without demonstrated
    need** — and non-invasiveness: İAA never mutates another framework,
    plugin, setting, or hook.

These are preserved unless the owner explicitly authorizes a change through the
lifecycle in §2.

## 5. Evidence rules

- **Version-pinned claims only.** "TESTED" means behavioral evidence at named
  versions; upstream "latest" is a different claim (COMPATIBILITY.md).
- **Behavioral vs structural.** Structurally compatible (installs, validates,
  parses) is never reported as tested behavior; the compatibility statuses
  (TESTED / PARTIALLY TESTED / STRUCTURALLY COMPATIBLE / UNVERIFIED) keep the
  distinction.
- **Observe, don't self-report.** Behavioral verification reads tool events /
  transcripts, not the model's summary of itself.
- **No invented evidence.** If a scenario was not run, its label stays
  DOCUMENTED; gaps stay gaps until closed (see BACKLOG validation items).
- **Dated evidence is immutable.** Reports under `audit/`, `comparison/`,
  `release-hardening/`, `post-release/`, `identity-migration/`,
  `historical-notes/` are records, not living documents.

## 6. Change classification and release discipline

Every change is classified before merge (model of
[gate-2/14](../release-hardening/gate-2/14-semantic-parity.md)):

- **A — packaging/infrastructure** · **B — factual adapter corrections** ·
  **C — invocation mechanics** · **D — semantic behavior**.

Discipline:
- Non-release work expects **D = NONE**; if D ≠ NONE, §2's semantic-change
  rules apply before anything ships.
- Two version axes stay separate: package `VERSION` (SemVer, which artifact)
  and policy revision (which semantics) — [POLICY-LINEAGE.md](POLICY-LINEAGE.md).
- One byte-exact core projects into every package; parity is CI-enforced
  (`scripts/check-parity.sh`), and release artifacts are deterministic builds.
- Irreversible/publication actions (tag, release, upstream PR, public post)
  require explicit owner authorization; merges to `main` are fast-forward-only
  by convention, preserving candidate history.

## 7. Backlog and GitHub relationship

Conservative model (do not migrate wholesale; do not create issue noise):

- **[BACKLOG.md](BACKLOG.md)** = product/project intent and prioritization
  (canonical).
- **GitHub Issue** = accepted executable work, opened only when useful
  (cross-linking `IAA-BL-###`).
- **PR** = implementation/integration artifact; its body references the
  backlog item or ADR it executes.

## 8. Staleness defense (for living documents)

Living documents separate **stable** content (charter, architecture, lifecycle)
from **volatile** content (versions, open PRs, current state). The Claude
Project pack carries no volatile values at all: Project Knowledge is durable
orientation only, and every current-state question is answered from the live
repository (`VERSION`, `docs/BACKLOG.md`, `docs/COMPATIBILITY.md`,
`docs/KNOWN-LIMITATIONS.md`, releases/tags, open PRs/issues, canonical
source). Dated snapshots kept for provenance (e.g.
`web-project-sources/11-CURRENT-STATE.md`) state the repository ref they
describe, are not uploaded, and always yield to live `main`.
