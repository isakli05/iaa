# Gate 3 — 03: Trigger-Eval Methodology (three-class separation)

Date: 2026-09-23. Mandate (Gate brief §6): fix the eval **methodology**,
not the product policy. Expected and delivered: **product semantics
changed = NO** (no core file touched; proven in `10-semantic-parity.md`).

## 1. The previous conflation (Gate-2 finding, precisely stated)

The Gate-2 `no-overdelegation-cap` grader (cases `trigger-positive`,
`shim-sim-trigger`) declared only `tool: Agent, max: 3` — no `min`. The
official `tool_used` grader semantics (code.claude.com/docs/en/plugin-evals,
"Grader types") default `min` to **1**, so the grader asserted "expected
1..3 agents". Observed Gate-2 failures: 3× "Agent called 0x (expected
1..3)" on runs where the skill loaded and the model then chose inline
execution of three ~6-line modules — a **valid zero-agent-fallback
outcome**. The grader's NAME said "cap"; its EFFECT said "must spawn".
That is the conflation of "İAA triggered" with "İAA must spawn at least
one agent" the Gate-3 brief called out. Gate 2 deliberately did not weaken
the grader mid-campaign and recorded the band question for the owner.

## 2. Corrected test model (three independent classes)

| Class | Question | Instrument | Agent-count requirement |
|---|---|---|---|
| **A — Trigger** | did İAA load/activate when it should? | `iaa-skill-fired` (tool_used Skill matcher, indicator; `arm: with-only`) | **none** |
| **B — Materiality / policy compliance** | once active, was the topology policy-compatible? | explicit `min: 0, max: 3` caps (Agent + Task alias) + synthesis rubric (coverage, no fabricated spawns) | **0, 1, …N all valid**; only >cap, incomplete work, or fabrication fails |
| **C — Forced-benefit delegation** | when the fixture itself pre-establishes material benefit, does delegation materialize? | new case `forced-benefit-delegation`: Agent `min: 1, max: 3` (max is fixture-contract-derived: one worker per module; the prompt establishes "one analysis pass per module is sufficient") + Task-alias cap + synthesis rubric | **≥1 expected — only here**, because the fixture establishes the benefit condition |

Class C's fixture (scaffold_script): three substantial (67/70/83-line),
genuinely independent, read-only Python modules on disk — versus
trigger-positive's ~6-line inline snippets. Benefit is pre-established by
task structure (parallelism + context offloading on real files), not by
imperative wording ("Use subagents where appropriate" in both cases).

## 3. Exact changed grader logic (diff of the methodology, nothing else)

1. `core/trigger-positive/graders/no-overdelegation-cap.md`:
   `max: 3` → `min: 0, max: 3` (+ explanatory body).
2. `core/shim-sim-trigger/graders/no-overdelegation-cap.md`: same fix
   (its observed counts were always exactly 3, so the bug never fired
   there; fixed for consistency, not re-run — cost discipline).
3. `trigger-positive` case metadata: `expected_outcome`/`tags` rewritten
   to the class A+B model (quoted YAML — a first attempt with unquoted
   `colon+space` broke frontmatter parsing and was fixed before any paid
   session ran).
4. NEW `release-hardening/evals/gate3/forced-benefit-delegation/`
   (case.yaml + fixture.sh + prompt + 4 graders) and
   `release-hardening/evals/gate3/run-gate3-eval-validation.sh`
   (single-arm `--ablation none`, n=3, `--scaffold`, stages into
   `packaging/claude/evals/` like the Gate-2 runner).
5. Dev-suite README case inventory updated to the three-class table.
NOT changed: every other grader, every prompt, the skill under test, any
core/policy/trigger-description text.

## 4. Validation run (corrected grader design, live)

`run-gate3-eval-validation.sh /var/tmp/iaa-gate3-evals/validation2` —
Claude Code 2.1.274, model `opus[1m]` = GLM-5.3 via the local z.ai
provider profile (same family as all İAA evidence), plugin namespace
`iaa` 0.1.0-rc.1 (byte-exact core v3), **single arm (`--ablation none`),
n=3 per case, 6 sessions, $6.06, `partial: false`**. Evidence:
`/var/tmp/iaa-gate3-evals/validation2/` (machine-local per policy).

### trigger-positive (class A + B) — 3/3, score 1.00 each run

| run | skill fired (A) | agents (B) | old grader would say | corrected grader |
|---|---|---|---|---|
| 0 | 1× | 3 | pass | **PASS** |
| 1 | 1× | **0** | **FAIL ("expected 1..3")** | **PASS** — the exact in-policy zero-agent outcome the old grader mislabeled |
| 2 | 1× | 3 | pass | **PASS** |

Before/after interpretation: Gate-2's 0.73 class score decomposed into
3 grader-band failures + 1 judge error; with the band corrected to the
policy's own bounds the same behavior reads 1.00. The behavior never
changed — the question did. This validates the Gate-2 decomposition
post-hoc.

### forced-benefit-delegation (class C) — delegation materialized 3/3

| run | agents (C) | within fixture band | skill fired (A, indicator) | synthesis |
|---|---|---|---|---|
| 0 | exactly 3 | PASS (1..3) | **0× — FAIL (indicator)** | PASS |
| 1 | exactly 3 | PASS | 1× | PASS |
| 2 | exactly 3 | PASS | 1× | PASS |

Two findings, cleanly separated exactly as the model intends:

1. **The class-C question answered YES**: with benefit pre-established by
   task structure, the policy materializes delegation — exactly one worker
   per module (3/3 runs), never 0, never >3, synthesis complete, caps
   respected via both tool names. The fixture/band design works and needs
   no further loosening.
2. **Class-A independence demonstrated on live data**: run0 delegated
   correctly WITHOUT the skill loading first (description-channel variance
   on the plugin-only arm — consistent with Gate-2's channel findings).
   Under the old conflated grader this nuance would have been invisible;
   here the indicator (excluded from score in two-arm mode by `arm:
   with-only`; surfaced because `--ablation none` scores everything)
   isolates it as a trigger-rate datum, NOT a delegation-policy failure.
   Recorded as measurement, no product action implied or taken.

### Failures in the validation run

One: the run0 `iaa-skill-fired` indicator (scored 0.75 for that run)
analyzed above. No grader-design failures; no policy failures; no
fabricated spawns; no cap violations anywhere.

## 5. Product text changed?

**NO.** All five core files byte-identical before/after this Gate
(`10-semantic-parity.md`); no trigger description, adapter, or policy
sentence touched. The changes are test-contract + fixture + grader
documentation only (eval-methodology tier).

## 6. Owner notes carried forward

- The Gate-2 owner question "accept 0..3 as the pass band or keep a
  deliberate under-delegation tripwire" is now RESOLVED BY BETTER DESIGN:
  the strict band is unnecessary because class C carries the
  delegation-expectation question with a fixture that justifies it. No
  policy number was loosened to make scores green.
- Two-arm runs of the corrected cases remain available via the Gate-2
  runner when Δ-vs-baseline is wanted (Skill indicators then unscored by
  default); the single-arm Gate-3 runner is the cheap regression form.
