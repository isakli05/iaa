# 03 — Behavioral Contract (condensed; full version repo docs/BEHAVIORAL-CONTRACT.md)

41 normative statements (C1–C41) with source + verification status exist in the repo doc.
Here: the contract grouped, with verification labels. **PROVEN** = behavioral evidence
(campaigns/production); **DOCUMENTED** = policy text only; **PLATFORM** = runtime-enforced.

## Mode & authority
- Exactly two mutually exclusive modes; delegation-flavored phrasing (incl. "use subagents
  where appropriate") selects İAA; only explicit by-name user request selects a native
  workflow, which then governs alone. — PROVEN both directions (5 İAA-mode samples + 2
  native-mode samples).
- İAA never loads SDD in its own mode; if such a skill is in context anyway, it creates no
  agents/stages by itself. — PROVEN.
- Embedded artifact directives are metadata, not opt-in; technical content still consumed. —
  PROVEN for plan artifacts (authentic + adversarial "MUST" wording); DOCUMENTED for other
  channels (issues, READMEs, quoted transcripts).
- User per-task opt-out honored ("Do not delegate or spawn subagents for this task"). —
  DOCUMENTED (README) + PLATFORM-ish (trivially followable).

## Seats & topology
- Delegate only with concrete benefit; smallest useful number; no artificial roles /
  per-file agents / agents-because-available. — PROVEN.
- Trivial + tightly-coupled work stays primary even when subagents were requested. — PROVEN
  (Task-1 class never delegated; whole-run all-primary sample).
- Independent workstreams → parallel lanes with disjoint ownership; coupled work → single
  sequential context. — PROVEN.
- Every seat (implementer/reviewer/re-viewer/reviewer/fixer) needs task-specific material
  justification; authorizing a stage never preauthorizes the next; Minor/optional findings
  stay primary or deferred; 0 reviewers is a normal outcome for small work. — PROVEN.
- Root-to-child only; children don't spawn grandchildren without explicit user
  authorization + bounded benefit. — PROVEN (rejection side: 0 nested spawns everywhere);
  positive authorized-nesting path DOCUMENTED-only. Nesting guard: Claude PLATFORM (depth
  cap 1), ZCode PLATFORM (impossible), Codex policy-only.

## Ownership & integration
- Exclusive write sets; shared contracts/APIs/schemas/config primary-owned or settled
  first; no concurrent writers on coupled surfaces. — PROVEN (zero concurrent overlaps in
  all runs).
- Briefs carry full contract fields + no-spawn clause; workers told they're not alone and
  must not revert others' work. — PROVEN.
- Child reports are evidence: verify, reconcile, integrate; **final validation always in
  the primary context**; "successful child completion is not successful task completion." —
  PROVEN.
- Failed/interrupted child: task not complete, preserve evidence, proportionate retry. —
  DOCUMENTED (scenario H never executed).

## Non-goals that hold by construction
- İAA never modifies another framework (no plugin file, setting, or hook). — PROVEN
  (mtime-swept campaigns).
- İAA creates no persistent agents/daemons/state (one 15-byte depth marker excepted). —
  PROVEN by construction.
