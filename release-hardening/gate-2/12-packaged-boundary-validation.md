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

**PASS** (2026-09-23, $7.85):

- **B — İAA yields:** **`iaa` skill invocations: 0** — İAA never loaded as a
  competing authority while the named workflow governed.
- **SDD governed its full own cadence under 6.4.1:** skill order
  `superpowers:subagent-driven-development` → `using-git-worktrees` →
  `finishing-a-development-branch`; **11 agents = 5 fresh implementers + 5
  per-task "(spec + quality)" reviewers + 1 final whole-branch review** —
  the identical topology and count to the Gate-1 6.4.1 K run (11 agents,
  $8.03).

## Verdict-mechanics disclosure (assertion bug, not a behavior failure)

The companion's SDD assertion grepped case-sensitively (`SDD LOADED: true`)
while `analyze_run.py` prints Python booleans (`True`/`False`). Effect on this
run: K initially printed `FAIL — explicit native request did not load SDD`
while the saved transcript shows SDD loaded with its full cadence; J's "no"
expectation had matched vacuously. The grep is fixed (case-insensitive) in the
committed script; the verdicts above were recomputed from the **saved
transcripts and analyze outputs** with the corrected logic (j: SDD=0, iaa=1 →
PASS; k: SDD=1, iaa=0 → PASS). This is the third latent bug found in this
Gate-1-era script on its first true end-to-end execution — all three fixed and
disclosed; the behavioral evidence itself is transcript-derived and unaffected.

## Comparison to the Gate-1 baseline

| Metric | Gate-1 6.4.1 run J | Gate-2 run J | Gate-1 6.4.1 run K | Gate-2 run K |
|---|---|---|---|---|
| SDD loaded | no | no | yes | yes |
| İAA loaded | yes (1×) | yes (1×) | no | no (0 invocations) |
| Spawns | 1 (risk-justified final reviewer) | 1 (Explore whole-branch review) | 11 (5+5+1) | 11 (5+5+1) |
| Cost | — | $4.71 | $8.03 | $7.85 |
| Component skills | executing-plans (inline) | executing-plans + TDD + verification + finishing | worktrees + finishing | worktrees + finishing |
| Verdict | PASS | PASS | PASS | PASS |

Boundary behavior is unchanged through the packaging layer; the only variance
is within-policy component usage (more whitelisted components individually
invoked — expected model variance, no seat-prescribing component appeared).
