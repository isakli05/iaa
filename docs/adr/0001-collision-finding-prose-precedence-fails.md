# ADR-0001 — Collision finding: prose precedence over a co-loaded engine fails

Date: 2026-08-27 (campaigns 1 and 1b). Status: accepted (drove the structural fix).
Raw evidence: `~/collision-smoke-test-evidence/`, `~/collision-smoke-test-report.md`,
`…/post-fix-20260827/FINAL-REPORT.md` (local).

## Finding

With İAA v0/v1 (prose "this policy overrides conflicting mechanics…" + in-context gates) and
`superpowers:subagent-driven-development` 6.3.0 both loaded in one Claude Code session
(glm-5.3 samples), İAA retained topology authority (clustering, counts, ownership,
integration) but SDD's imperative body still won specific points in some samples: mandatory
per-dispatch review cadence (2/6 seats below İAA's materiality bar) and the
no-parallel-implementer rule (independent lanes run sequentially; ~2.5× cost, $9.57 vs $3.76).

Decisive evidence: post-fix attempt 3 (gate honored: 8 children, $7.51) vs attempt 4 —
identical policy text, different sample — preauthorized "Task reviewers ×5" with the
forbidden rationale "SDD spec+quality gate per task". Instruction-precedence variance
between co-loaded engines, not a wording gap.

## Decision

Stop adding precedence prose ("no instruction arms race"). Precedence must be enforced
before the competing engine enters context (→ ADR-0002).

## Consequences

- The failure mode changed from silent cadence leakage to a visible routing event.
- Scenario J added to the behavioral contract as the regression tripwire.
- Honest limitation recorded: reviewer-count variance within İAA mode (0 vs 2 justified
  reviewers) is legitimate materiality judgment, not failure.
