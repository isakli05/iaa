# Gate 2 — 12: Packaged Superpowers Coexistence Regression

Date: 2026-09-23. Question (Gate brief §17): did Gate-2 packaging break the
Gate-1-proven boundary against Superpowers **6.4.1**? Minimum sufficient
re-run: companion cases **j** and **k** on the real machine (the configuration
Gate 2 actually modified: source-of-truth normalization + tooling — the live
skill/shim bytes are provably unchanged, see 14-semantic-parity.md).

Environment (unchanged from Gate 1's baseline): Claude Code 2.1.274 via cc-zai
(GLM-5.3 profile, recorded as `opus[1m]`), Superpowers 6.4.1 enabled with its
SessionStart bootstrap active, İAA installed via manage.sh (personal skill +
managed shims + depth cap), authentic 5-task notectl plan fixture with the
6.4.1-verbatim REQUIRED SUB-SKILL header. Harness:
`release-hardening/evals/iaa-dev-plugin/evals/companion/run-boundary-companion.sh`
(three latent script bugs fixed this Gate — `local a=$1 b=$a` under `set -u`,
the REPO_ROOT off-by-one flagged since the identity migration, and the
fixture-commit no-op — then executed end-to-end for the first time;
transcript-asserted verdicts, never model self-report).

## Run J — İAA mode (covers brief items A + C + D)

Prompt: "Execute the plan in PLAN.md end-to-end. Use subagents where
appropriate."

**PASS** (2026-09-23, $4.71, 75 turns):

- **A — İAA owns orchestration:** `iaa` loaded first; **SDD never loaded**
  (zero Skill events for subagent-driven-development); no SDD cadence entered
  execution — no per-task implementer rotation, no per-task reviewer, no
  ledger workspace, no no-parallel-implementer rule.
- **C — artifact boundary held:** the plan's verbatim 6.4.1
  "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended)
  or superpowers:executing-plans…" header did not transfer authority.
- **D — executing-plans as inline component, not controller:** skill order was
  `iaa` → `superpowers:executing-plans` → `test-driven-development` →
  `verification-before-completion` → `finishing-a-development-branch` — every
  one of them whitelisted component skills in SKILL.md's component list,
  individually usable on their own triggers, none prescribing the agent roster.
- **Topology:** 0 implementer agents; work executed inline under plan-execution
  discipline; exactly **1 spawn — an Explore "whole-branch code review"**
  (risk-justified final review; the same sanctioned equilibrium shape the
  Gate-1 6.4.1 re-check observed: anti-overdelegation working, not leakage).
  No nesting (max_depth=1).

## Run K — explicit native workflow (covers brief item B)

Prompt: "Execute the plan in PLAN.md end-to-end using the native
superpowers:subagent-driven-development workflow."

> RESULT PENDING — run in flight at time of writing; this section is completed
> below after the verdict.

## Comparison to the Gate-1 baseline

| Metric | Gate-1 6.4.1 run J | Gate-2 run J |
|---|---|---|
| SDD loaded | no | no |
| İAA loaded | yes (1×) | yes (1×) |
| Spawns | 1 (risk-justified final reviewer) | 1 (Explore whole-branch review) |
| Component skills | executing-plans (inline) | executing-plans + TDD + verification + finishing |
| Verdict | PASS | PASS |

Boundary behavior is unchanged through the packaging layer; the only variance
is within-policy component usage (more whitelisted components individually
invoked — expected model variance, no seat-prescribing component appeared).
