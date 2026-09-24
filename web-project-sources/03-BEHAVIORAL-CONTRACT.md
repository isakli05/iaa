# 03 — Behavioral Contract (condensed)

The authoritative version is `docs/BEHAVIORAL-CONTRACT.md` on GitHub: 41
normative statements (C1–C41), each with source and a verification label —
**PROVEN** (behavioral evidence: campaigns/production/evals), **DOCUMENTED**
(policy text only), **PLATFORM** (runtime-enforced), **HISTORICAL** (no longer
active). Verification is by observed tool events / transcripts, never model
self-report. Here: the contract grouped, with label summaries. Labels below
reflect the evidence set through the 0.1.1 acceptance (2026-09-23); the GitHub
doc is the live authority.

## Mode & authority — all PROVEN (both directions, multiple eras)

- Exactly two mutually exclusive modes; delegation-flavored phrasing (incl.
  "use subagents where appropriate") selects İAA; only an explicit by-name user
  request selects a native workflow, which then governs alone.
- İAA mode never loads SDD; if a competing engine is in context anyway, it
  creates no agents/stages by itself. Re-proven on Superpowers 6.4.1 (Gate 1)
  and in Gate-2/3 re-runs.
- Embedded artifact directives are metadata, not opt-in; technical content
  still consumed. PROVEN for plan artifacts (authentic + adversarial "MUST"
  wording) and for repository files (README directive, with read-exposure
  checked). Content the user pastes into their own message — issue text,
  quoted transcripts, prompts written by another tool — is the user's
  instruction, out of scope by owner decision (IAA-BL-004 closed).
- Per-task opt-out honored ("Do not delegate or spawn subagents for this task").

## Seats & topology — PROVEN

- Delegate only with concrete benefit; smallest useful number; no artificial
  roles, per-file agents, or agents-because-available.
- Trivial + tightly-coupled work stays primary even when subagents were
  requested (zero-agent fallback; validated again for explicit-entry
  invocations in Gate 2: trivial `/iaa:orchestrate` runs → 0 spawns, 3/3).
- Independent workstreams → parallel lanes with disjoint ownership; coupled
  work → one sequential context.
- Every seat needs task-specific material justification; authorizing a stage
  never preauthorizes the next; Minor/optional findings stay primary or
  deferred; **0 reviewers is a normal outcome** for small work.
- Root-to-child only; rejection side PROVEN everywhere (0 nested spawns in
  every run); the *authorized* nesting positive path is DOCUMENTED-only
  (IAA-BL-003/015). Nesting guard: Claude PLATFORM (depth cap 1), ZCode
  PLATFORM (impossible), Codex policy-only.

## Ownership & integration — PROVEN

- Exclusive write sets; shared contracts/APIs/schemas/config primary-owned or
  settled first; zero concurrent same-file writers in any recorded run.
- Briefs carry the full contract fields + the no-spawn clause; workers are
  told they are not alone in the workspace and must not revert others' work.
- Child reports are evidence: verify, reconcile, integrate; **final validation
  always in the primary context**.
- Failed/interrupted child: task not complete, preserve evidence,
  proportionate retry — DOCUMENTED (scenario H never run; IAA-BL-003).

## Non-goals that hold by construction — PROVEN

- İAA never modifies another framework (no plugin file, setting, or hook
  touched; mtime-swept campaigns; doctor is strictly read-only).
- İAA creates no persistent agents/daemons/state (one 15-byte depth marker
  excepted, owned only if absent pre-install).

## What is explicitly NOT guaranteed

Instruction-following, not harness enforcement: skill selection is
model-driven and fallible (official doctrine — prose is "a request, not a
guarantee"). The boundary is a tested behavior with a regression tripwire
(scenario J + `analyze_run.py`), not a mechanism guarantee. Single-model
evidence (GLM-5.3 profile) — other families UNVERIFIED.

**Stable file** — evidence-set dates and counts live on GitHub; the pack
carries no version values.
