# İAA Backlog — canonical work queue

This file is the repository-owned, long-term work queue for İAA. It holds
**product/project intent and prioritization** across all future versions — it is
not tied to any release. GitHub Issues/PRs are execution artifacts and never
replace this file (relationship model: [GOVERNANCE.md](GOVERNANCE.md) §7).

- **Last reviewed:** 2026-09-24 · against `main` @ `479cea7` (package 0.1.1, policy v3)
- **Current state of the product** lives in [README.md](../README.md) and
  [COMPATIBILITY.md](COMPATIBILITY.md), not here. This file is intent, not state.

## Rules

1. An idea is not a commitment. Items carry a status; only `OPEN` items are
   accepted work. `PROPOSED`/`RESEARCH` items exist to be evaluated, not scheduled.
2. Research candidates stay `RESEARCH` until evidence supports adoption; adoption
   is an owner decision (lifecycle: [GOVERNANCE.md](GOVERNANCE.md) §2).
3. No arbitrary release numbers. A target release is recorded only when actually
   decided by the owner.
4. No item is marked complete without repository evidence (commit, report, or
   recorded decision linked from the item).
5. External waits name exactly **what** is awaited and **from whom**. A wait is
   not a blocker unless the dependent work cannot proceed without it.
6. Settled decisions (§SETTLED) are not re-proposed without new evidence.
7. Completed items with lasting value move to §ARCHIVED as one-line pointers;
   nothing here is deleted silently.
8. Every nontrivial item states: problem, evidence, why it matters,
   dependencies/blockers, and acceptance criteria.

## Status vocabulary

| Status | Meaning |
|---|---|
| `OPEN` | accepted; actionable now or next |
| `WAITING (external: …)` | actionable only on an external event; names what/whom |
| `OWNER DECISION` | gated on an owner choice, not on engineering work |
| `PROPOSED` | candidate; evaluation pending; not a commitment |
| `RESEARCH` | investigation required before any adoption decision |
| `STANDING` | recurring discipline with a trigger; not a finite task |
| `DEFERRED` | recognized, deliberately not scheduled (reopen condition stated) |
| `CLOSED` | done or decided, with evidence; retained until archived |

---

## ACTIVE

### IAA-BL-001 — Monitor and respond to zai-org/zcode-plugins PR #42
- **Status:** `WAITING (external: zai-org/zcode-plugins maintainer review of PR #42 — opened 2026-09-23, still open with no comments as of 2026-09-24)` · **Category:** upstream / distribution
- **Problem / motivation:** the İAA ZCode plugin is submitted to the upstream
  marketplace; maintainer feedback may require changes, and upstream `main` may
  move before merge.
- **Evidence:** [FINAL-0.1.1-PUBLICATION-REPORT.md](../release-hardening/0.1.1/FINAL-0.1.1-PUBLICATION-REPORT.md)
  §26–27, §32 (names this as the recommended next engineering task);
  [upstream-pr.patch](../release-hardening/0.1.1/upstream-pr.patch);
  PR state re-verified 2026-09-24.
- **Why it matters:** the only distribution channel that depends on a third
  party; silence here stalls the official-marketplace path.
- **Dependencies / blockers:** none — nothing İAA-side is blocked; this is a wait.
- **Acceptance criteria:** every maintainer comment is answered; if upstream
  `main` moves: rebase `feat/iaa-plugin` (fork `isakli05/zcode-plugins`), keep
  the `iaa` marketplace entry last, re-run upstream `validate.py` /
  `build_dist.py` / `git diff --check`, push. On merge or rejection: record the
  disposition here and close.
- **Links:** https://github.com/zai-org/zcode-plugins/pull/42

### IAA-BL-016 — Static CI red on main: plugin.zip sha not reproducible on GitHub runners
- **Status:** `OPEN` · **Category:** maintenance / CI (category-A infrastructure; no semantic impact)
- **Problem / motivation:** the `static` workflow fails on every `main` push since
  the 0.1.1 merge (runs 35915378608, 35917592138):
  `check-parity: FAIL: marketplace.remote.json sha256 (621bdd1f…) != freshly
  built plugin.zip (856df553…)`.
- **Evidence / root cause (diagnosed 2026-09-24):** DEFLATE output is
  zlib-implementation-dependent. The released, sha-pinned zip was built on the
  owner machine (Python 3.14.7, **zlib-ng** 1.3.1.zlib-ng); GitHub ubuntu-24.04
  runners use stock zlib; identical plugin content compresses to different
  bytes. Fresh-checkout reproduction on the owner machine **passes**
  (worktree of the same commit), proving content parity — only the compressed
  bytes differ per environment.
- **Why it matters:** CI is red on every push to `main` (noise hides real
  failures); the cross-environment reproducibility implied by
  "deterministic build" evidence holds only per zlib implementation (the
  upstream `build_dist.py` byte-parity evidence was likewise produced on the
  zlib-ng machine — honest, but same-environment).
- **Impact boundary:** none on published 0.1.1 artifacts — the pin equals the
  published release asset and ZCode's client-side sha gate verified it in GUI
  acceptance; this is purely a CI-side reproduction check.
- **Dependencies / blockers:** none; fix direction is an owner decision
  (candidates: build release artifacts in a stock-zlib/CI environment; make
  the CI regeneration check compare archive *content* rather than raw sha
  while keeping the raw-sha pin for distribution; or a pinned build container).
- **Acceptance criteria:** `static` green on a `main` push again; the chosen
  direction recorded here; determinism wording in evidence docs qualified if
  needed.
- **Links:** run 35917592138 (failure log); `scripts/build-plugin-zip.py`
  (fixed-timestamp builder — content-deterministic, zlib-sensitive);
  `scripts/check-parity.sh` (remote marketplace pin check).

## NEXT

### IAA-BL-002 — ZCode feedback #699 confirming comment: post or drop
- **Status:** `OWNER DECISION` · **Category:** upstream / external
- **Problem / motivation:** ZCode 3.14.x provider bug (model requests fail
  ETIMEDOUT on IPv4-only networks) is root-caused, matched upstream, and forced
  a documented `api.z.ai` hosts workaround in every İAA GUI validation window.
  A confirming comment with reproduction + workaround is drafted but unposted.
- **Evidence:** [NETWORK-DIAGNOSTIC.md](../post-release/zcode-official/NETWORK-DIAGNOSTIC.md)
  (draft comment); publication report §30 (`NOT POSTED`, awaiting separate
  owner approval); issue open as of 2026-09-24.
- **Why it matters:** a second-environment confirmation helps upstream fix the
  bug that taxes İAA's own ZCode validation legs.
- **Dependencies / blockers:** owner approval only.
- **Acceptance criteria:** owner approves → the (possibly amended) draft is
  posted and the item closes with the comment link; owner declines → closes
  with the decision recorded here.
- **Links:** https://github.com/zai-org/feedback/issues/699

### IAA-BL-003 — Controlled scenario runs F, H, I
- **Status:** `PROPOSED` · **Category:** validation
- **Problem / motivation:** three contract scenarios were never executed as
  controlled tests: **F** nested-delegation judgment (positive authorized path),
  **H** failed/interrupted child recovery, **I** Explore constraint propagation.
- **Evidence:** [TESTING-AND-VALIDATION.md](TESTING-AND-VALIDATION.md) scenario
  table + "known gaps"; [KNOWN-LIMITATIONS.md](KNOWN-LIMITATIONS.md) #5.
- **Why it matters:** these are the largest DOCUMENTED-only regions of the
  behavioral contract (C15, C33-positive, C35-as-scenario).
- **Dependencies / blockers:** none structural — a disposable-repo harness
  (boundary companion) and the transcript analyzer exist.
- **Acceptance criteria:** each scenario executed per
  [tests/scenarios.md](../iaa/tests/scenarios.md) with tool-event verification
  (never model self-report); results recorded in TESTING-AND-VALIDATION;
  verification labels updated in [BEHAVIORAL-CONTRACT.md](BEHAVIORAL-CONTRACT.md).

### IAA-BL-004 — Provenance rule for non-plan artifact channels
- **Status:** `PROPOSED` · **Category:** validation
- **Problem / motivation:** the artifact trust boundary is behaviorally proven
  for **plan** artifacts only; issue text, READMEs, and quoted transcripts share
  the policy wording but were never exercised.
- **Evidence:** [KNOWN-LIMITATIONS.md](KNOWN-LIMITATIONS.md) #4;
  [ADR-0003](adr/0003-artifact-trust-boundary.md) scope;
  [COEXISTENCE-AND-ORCHESTRATION-OWNERSHIP.md](COEXISTENCE-AND-ORCHESTRATION-OWNERSHIP.md) P5.
- **Why it matters:** closes the widest injection-adjacent flank that one of
  İAA's two flagship differentiators claims to cover.
- **Dependencies / blockers:** none.
- **Acceptance criteria:** adversarial fixture per channel, run, transcript-
  verified, labels updated — same standard as the plan-artifact tests.

### IAA-BL-005 — Explicit-yield path for a non-SDD workflow
- **Status:** `PROPOSED` · **Category:** validation
- **Problem / motivation:** by-name yield to a foreign workflow is proven for
  Superpowers SDD only; the generic wording has never met a second controller
  (e.g. `/gsd-*` commands).
- **Evidence:** COEXISTENCE doc P4 GAP;
  [FINAL-COMPARISON-REPORT.md](../comparison/FINAL-COMPARISON-REPORT.md) §8
  (E5); GSD rows in [COMPATIBILITY-MATRIX.md](COMPATIBILITY-MATRIX.md) unknown.
- **Why it matters:** the public contract promises generic yield; the evidence
  is single-framework.
- **Dependencies / blockers:** requires a second framework installed in a
  disposable environment (GSD is UNVERIFIED against İAA — run isolated).
- **Acceptance criteria:** scenario-K mirror with a non-SDD named workflow;
  İAA-absent verified from the transcript.

## RESEARCH / EXPERIMENTS

### IAA-BL-006 — JEV as an optional typed decision backend (experiment design)
- **Status:** `RESEARCH` (recorded candidate; **not adopted; no dependency**) · **Category:** research
- **Problem / motivation:** evaluate Jev (TypeSafe) as an OPTIONAL typed backend
  for İAA's materiality, seat-justification, and topology-selection gates.
- **Evidence:** [FINAL-GATE-3-REPORT.md](../release-hardening/gate-3/FINAL-GATE-3-REPORT.md)
  Q26; publication report §23 (both record it as future-only).
- **Why it matters:** could make orchestration decisions more reliable — but
  only benchmark evidence can say; it must never quietly become a runtime
  dependency.
- **Constraints (Q26, binding on any experiment):** İAA retains orchestration
  authority; the primary LLM retains task understanding and final integration;
  native decision mode stays the baseline/fallback; JEV starts EXPERIMENTAL and
  optional; benchmark **native vs JEV** before any adoption on the metrics:
  unnecessary delegation, missed useful delegation, topology quality, decision
  latency/cost, confidence calibration, fallback behavior; privacy/API-key/
  network dependencies reviewed before adoption.
- **Dependencies / blockers:** none to design the benchmark; adoption blocked by
  design on benchmark evidence + owner acceptance.
- **Acceptance criteria (research phase):** benchmark design + results document;
  owner decision recorded (adopt / reject / extend research).

### IAA-BL-007 — Model-family coverage sampling
- **Status:** `RESEARCH` · **Category:** compatibility / validation
- **Problem / motivation:** all behavioral evidence is single-model (GLM-5.3
  profile on Claude Code; GPT-5.6-sol only for the pre-install native audit).
- **Evidence:** [KNOWN-LIMITATIONS.md](KNOWN-LIMITATIONS.md) #7;
  COMPATIBILITY.md "Non-GLM model families: UNVERIFIED".
- **Why it matters:** the largest generalization gap behind the public claims.
- **Dependencies / blockers:** access to a second model family; no design work.
- **Acceptance criteria:** boundary scenarios (J/K + anti-overdelegation) run on
  at least one additional family; version-pinned results recorded; claims
  updated or scope restated.

### IAA-BL-008 — Deterministic topology/dependency aids (GSD-inspired)
- **Status:** `RESEARCH` (low priority; default expectation negative) · **Category:** research
- **Problem / motivation:** some systems mechanize dependency-aware topology
  (DAG + file-overlap waves) where İAA reasons in prose; the comparison
  concluded İAA's actual deficit is instrumentation, not enforcement.
- **Evidence:** FINAL-COMPARISON-REPORT §4 (H9 partial), §14, §17 (KEEP prose
  waves; DO NOT engine-ize topology).
- **Why it matters:** worth one honest research pass only if a non-framework
  aid could make decisions more *reliable* — not to make İAA a larger system.
- **Dependencies / blockers:** none; any proposal must pass the governance
  lifecycle and the default evaluation question.
- **Acceptance criteria:** research note with evidence; explicit adopt/reject.

### IAA-BL-009 — Agent Teams / peer-coordination characterization
- **Status:** `RESEARCH` (deferred until upstream stabilizes) · **Category:** research / compatibility
- **Problem / motivation:** Claude Agent Teams (experimental, flag-gated, off
  locally) is untested against İAA; auto-formation would change topology
  assumptions and conflicts with root-to-child by design.
- **Evidence:** COMPATIBILITY-MATRIX "UNVERIFIED"; comparison §9 (E10), §17
  (mesh topologies: DO NOT ADOPT as a default shape).
- **Why it matters:** to know what happens *if a user enables teams* beside
  İAA — characterization only; no adoption intent.
- **Dependencies / blockers:** stable upstream feature + owner-enabled flag.
- **Acceptance criteria:** one characterization run + note, or an explicit
  wont-research decision recorded.

## MAINTENANCE (standing)

### IAA-BL-010 — Superpowers upgrade check
- **Status:** `STANDING` — **not due** (6.4.1 installed, tested, and current
  upstream as of 2026-09-23) · **Category:** maintenance
- **Trigger:** any Superpowers release lands locally.
- **Procedure:** re-check `executing-plans`/`writing-plans` for new redirects
  into SDD; re-scan whitelisted component skills for new agent-prescribing
  text; re-run scenario J; update adapter wording if trigger descriptions
  changed.
- **Evidence:** upgrade-check procedure in
  [CANONICAL-README.md](../CANONICAL-README.md); Gate-1 execution in
  [release-hardening/01](../release-hardening/01-superpowers-6.4.1-upgrade-check.md).

### IAA-BL-011 — Runtime version-movement re-verification
- **Status:** `STANDING` · **Category:** maintenance / compatibility
- **Rule:** TESTED claims are version-pinned, not latest-tracking. When support
  for a newer runtime version is claimed or a release ships, re-run the
  boundary regression + `iaa doctor` and update the matrix.
- **Current deltas (2026-09-23, gate-3/07):** upstream latest Claude Code
  2.1.280 and Codex 0.156.1 vs tested 2.1.274 / 0.156.0 — recorded; no action
  due merely because upstream moved.
- **Evidence:** "Re-verification discipline" in [COMPATIBILITY.md](COMPATIBILITY.md).

### IAA-BL-012 — Claude Project pack hygiene (sources/ parity)
- **Status:** `STANDING` · **Category:** maintenance
- **Rule:** the Claude Project pack is durable by design and carries no
  current-state snapshot — current operational state is read live from this
  repository, and nothing is refreshed or re-uploaded after releases
  (design change 2026-09-24; the earlier refresh-and-re-upload obligation is
  retired). Remaining standing hygiene: re-verify
  `web-project-sources/sources/` byte parity whenever the behavioral core
  changes; re-review pack files only when their durable content (charter,
  architecture, governance, history narrative) itself changes.
- **Evidence:** staleness model in
  [MANIFEST.md](../web-project-sources/MANIFEST.md);
  `web-project-sources/11-CURRENT-STATE.md` (repo-side dated snapshot, not
  uploaded).

## DEFERRED

### IAA-BL-013 — Codex consumer plugin-portal submission
- **Status:** `DEFERRED` · **Category:** release / distribution
- **Problem:** the consumer portal would widen Codex reach; submission gates on
  a maintained 5+3 test-case set.
- **Evidence:** comparison §10 (submission gate); Codex plugin form already
  TESTED locally via the repo channel.
- **Reopen condition:** owner decision + a commitment to maintain the test set.

### IAA-BL-014 — Additional runtime/platform support
- **Status:** `DEFERRED` (undirected) · **Category:** compatibility
- **Problem:** İAA ships 3 runtimes; peers ship 16–47; ecosystems increasingly
  cross-accept manifests, lowering marginal cost.
- **Evidence:** comparison §4 (H7), §15.
- **Reopen condition:** demonstrated demand or an owner strategic decision;
  must clear the default evaluation question. This is not a roadmap commitment.

### IAA-BL-015 — Authorized nested delegation as first-class path
- **Status:** `DEFERRED` (design question) · **Category:** design
- **Problem:** the positive authorized-nesting path is policy-permitted,
  unexercised, and discouraged; whether it should ever be first-class is open.
- **Evidence:** dispatch section of [SKILL.md](../iaa/SKILL.md);
  KNOWN-LIMITATIONS #5; retired open-question list in the web pack (09).
- **Reopen condition:** a concrete owner use case; pairs with the scenario-F
  positive run (IAA-BL-003). Current tested stance: discouraged, explicit-only.

## SETTLED — recorded decisions (do not re-propose without new evidence)

| Decision | Where recorded |
|---|---|
| No framework ledgers / state machines / persistent task state | comparison §17; frozen invariants ([gate-2/00 §1](../release-hardening/gate-2/00-semantic-freeze.md)) |
| No fixed agent rosters, roles, or mandatory review cadences | comparison §17; SKILL.md v3 |
| No hooks over foreign tools; no SessionStart hook in the İAA baseline | comparison §14; [PUBLIC-DISTRIBUTION-ARCHITECTURE.md](PUBLIC-DISTRIBUTION-ARCHITECTURE.md) |
| No mesh/peer topology as a default shape (root-to-child by design) | comparison §17 |
| No engine-ization of topology; deterministic engines are a different product class | comparison §17 |
| No per-runtime semantic forks — one byte-exact core, three projections | [SOURCE-OF-TRUTH.md](SOURCE-OF-TRUTH.md); gate-2/03 |
| No enforcement-grade İAA (GSD-ization); the deficit is instrumentation, not enforcement | comparison §14 |
| Trigger model stays hybrid (measured, not guessed) | gate-2/10 trigger characterization |

## ARCHIVED — completed (pointers, not duplicates)

| Completed work | Evidence |
|---|---|
| Forensic baseline audit + repository migration (2026-09-22) | `audit/` (03 source-of-truth verdict) |
| Competitive comparison (2026-09-22) — 4 differentiators confirmed, no counter-finding | `comparison/FINAL-COMPARISON-REPORT.md` |
| Gate 1: Superpowers 6.4.1 re-verification + eval foundation (2026-09-22/23) | `release-hardening/FINAL-GATE-1-REPORT.md` |
| Identity migration, token-only, semantics proven unchanged (2026-09-23) | `identity-migration/FINAL-IAA-IDENTITY-MIGRATION.md` |
| Gate 2: packaging, invocation, doctor, CI, trigger characterization (2026-09-23) | `release-hardening/gate-2/FINAL-GATE-2-REPORT.md` |
| Gate 3: license (MIT+NOTICE), publication readiness (2026-09-23) | `release-hardening/gate-3/FINAL-GATE-3-REPORT.md` |
| İAA 0.1.0 first public release (2026-09-23) | `release-hardening/gate-3/FINAL-PUBLICATION-REPORT.md` |
| ZCode official validation of 0.1.0 + 0.1.1 corrective findings (2026-09-23) | `post-release/zcode-official/FINAL-ZCODE-OFFICIAL-REPORT.md` |
| İAA 0.1.1 publication: merge, tag, release, upstream PR #42 (2026-09-23) | `release-hardening/0.1.1/FINAL-0.1.1-PUBLICATION-REPORT.md` |
