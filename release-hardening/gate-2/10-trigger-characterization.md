# Gate 2 — 10: Trigger Characterization

Date: 2026-09-23. Method: `release-hardening/evals/gate2/run-gate2-trigger-suite.sh`
— stages the cases into `packaging/claude/evals/` at run time so the **public
namespace under test is the real one** (`iaa:iaa`, `/iaa:orchestrate`), runs
`claude plugin eval` with two-arm ablation (plugin arm + no-plugin baseline
arm), then removes the staging (gitignored). 68 real model sessions total.

**Metadata:** Claude Code 2.1.274 · plugin `iaa` 0.1.0-rc.1 (byte-exact core v3,
sha256 `73f7b887…`) · model string `opus[1m]` as recorded by the harness =
GLM-5.3 via the local z.ai provider profile · duration 5,267 s · cost $15.74 ·
`partial: false`. Evidence: `/var/tmp/iaa-gate2-evals/full/aggregate.json`
(machine-local per the evidence-disposition policy).

## Results per class (plugin arm; baseline arm in prose where informative)

| # | Prompt class | Case | n (×2 arms) | Skill fired | Agents | Score | Classification |
|---|---|---|---|---|---|---|---|
| 1 | explicit `/iaa:orchestrate` | explicit-orchestrate | 3 | **3/3** | 0 (3/3) | 1.00 | correct: entry resolves, zero-agent fallback holds |
| 2 | obvious positive ("use subagents where appropriate" + 3 independent modules) | trigger-positive | 5 | **5/5** | 2 runs: exactly 3; 3 runs: 0 (see below) | 0.73* | skill triggers reliably; delegation choice splits (both in-policy) |
| 3 | ambiguous delegation-flavored ("parallelize if it helps" + 2 tiny configs) | ambiguous-delegation | 5 | 0/5 | 0–2 | 1.00 | no false trigger; no overdelegation |
| 4 | trivial + mentions subagents | anti-overdelegation-trivial | 5 | 0/5 | 0 (5/5) | 1.00 | zero-agent fallback 5/5 |
| 5 | normal coding request | ordinary-task-no-overclaim | 5 | 0/5 | 0 | 1.00 | no false positive 5/5 |
| 6 | explicit SDD request (yield side; SDD absent in sandbox) | explicit-sdd-yield | 3 | **0/3** | — | 1.00 | yield held 3/3 |
| 7 | explicit GSD request (conceptual: not installed) | explicit-unknown-workflow-yield | 3 | **0/3** | — | 1.00 | no substitute-authority grab 3/3 |
| 8 | explicit foreign workflow (generic unknown) | covered by 6+7 | 6 | 0/6 | — | 1.00 | both by-name yields hold |
| — | shim-simulated instruction channel (same positive prompt) | shim-sim-trigger | 5 (+5) | **5/5** | **5/5 runs: exactly 3** | 1.00 | loads AND delegates 5/5 (baseline arm 0.8: rubric variance, no skill) |

\* score decomposition below.

## Reading

1. **False positives: 0/13** across the negative/ambiguous/trivial classes
   (ordinary coding, ambivalent parallelism, trivial-with-subagent-wording):
   the narrow description does not over-claim.
2. **False negatives on obvious positives: 0/5** — the skill fired on every
   obvious-positive run (plugin-only, description-routed). This **revises the
   Gate-1 pilot's 1/2** measurement: that number was small-sample variance,
   exactly why the brief refused to treat n=2 as a rate.
3. **Explicit invocation: 3/3** resolution + 3/3 zero-agent on a trivial task
   (also proven live once outside the sandbox, $0.10, transcript-verified).
4. **Yield: 6/6** across SDD-named and unknown-workflow-named requests — İAA
   never loaded as authority in native mode.
5. **Anti-overdelegation: 5/5** trivial + 5/5 ambiguous caps respected.

## The trigger-positive score decomposition (0.73 — read before reacting)

The four scored grader failures across three runs decompose into:

- **3× `no-overdelegation-cap` "Agent called 0× (expected 1..3)"** — the skill
  loaded (fired 5/5) and the model then chose **inline execution** for the
  three-module read-only analysis. İAA's own policy makes delegation on such a
  task *permitted when it materially improves execution, not mandatory*
  (scenario E; "choose the smallest useful number"). The Gate-1 grader asserts
  a stricter band (1..3 agents) than the policy requires — written when both
  pilots happened to produce exactly 3 agents. **Decision: the grader was NOT
  weakened to improve the number.** Recorded as an owner decision: either
  accept 0..3 as the pass band for this class (a grader/test-contract change,
  not a semantic one) or keep the strict band as a deliberate under-delegation
  tripwire knowing it will flag in-policy variance.
- **1× judge failure** — z.ai 529 (server overload) during the llm rubric:
  infrastructure, not behavior (2 more 529s hit other arms' rubrics; baseline
  arm unaffected by chance).
- The **baseline arm scored 1.00** on the same prompt (the base model also
  delegates 1–3 agents on it): the negative Δ is fully explained by the grader
  band + judge failure, not by the plugin degrading behavior.

## Shim A/B contribution (input to gate-2/05 §4)

Same prompt, same class, two channels (n=5 each):

| Channel | Skill loaded | Delegated (≥1 agent) | Agents when delegating |
|---|---|---|---|
| description-only (plugin arm, no instruction file) | 5/5 | **2/5** | exactly 3 |
| shim-simulated instruction channel (`append_system_prompt`) | 5/5 | **5/5** | exactly 3 |

The channels agree on *skill loading*; they diverge on the *decision the loaded
policy then makes* — the instruction channel ("when the user requests
subagents … delegate") correlates with honoring the delegation request, while
description-only loading weighs the policy's own materiality test and chose
inline in 3/5 runs (small modules: an in-policy reading). Both outcomes are
within policy (scenario E: delegation permitted, not mandatory), and the
unmeasurable property — contest resolution against a co-installed orchestration
engine — remains evidenced only in the real-machine shim configuration.
Determination B in gate-2/05 stands, now with a measured channel-dependent
behavioral delta in addition to the structural and boundary-evidence
arguments.

## Topology categories observed (plugin arm, where observable)

- explicit-orchestrate: inline, 0 agents (trivial task).
- trigger-positive: mixed adaptive — 0 agents (3 runs, in-policy inline) or
  exactly 3 parallel read-only agents (2 runs); shim-sim channel: 3 agents 5/5.
- ambiguous: 0–2 agents (cap held).
- all others: 0 agents.
- No nested spawns anywhere; no seat-prescribing component appeared.

## Conclusion for owner decision D1 (trigger model)

Status quo (B: model-invocable + narrow description + instruction-channel
integration) is supported by measurement: zero observed false positives, zero
false negatives on obvious positives, explicit-entry reliability 3/3, and both
yield directions intact. The open item is the *grader band* question above,
not the description. No trigger-text patch is proposed — nothing measured here
indicates problematic wording.
