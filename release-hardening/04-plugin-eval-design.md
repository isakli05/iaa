# Release Hardening 04 — `claude plugin eval` regression foundation

Date: 2026-09-23. Controller: main Claude Code session. Task: Gate 1, §5 —
minimum non-public dev plugin/eval scaffold to test MAO behavior with
`claude plugin eval`, with an honest grader strategy where the harness cannot
observe a property directly. **This is not public packaging** (that is
deliberately deferred; nothing here is published or listed anywhere).

## 1. CLI availability and version facts (recorded, not assumed)

- `claude --version` → **2.1.274**. `claude plugin eval` is fully present
  (the comparison noted plugin eval from 2.1.269+; locally verified:
  case.yaml/prompt.md+graders formats, six grader types, two-arm ablation,
  `--json`, `--threshold` exit codes, HTML report).
- Format authority used: local `claude plugin eval --help` + the official
  docs page (code.claude.com/docs/en/plugin-evals), both read this session.
- No server-side early-access gate was encountered: cases ran locally on this
  machine under the local provider profile (`glm-5.3[1m]` via z.ai), each run
  as a `claude -p` child. The HTML report's claude.ai publishing step
  auto-detected "started by a Claude Code session rather than a person" and
  stayed local — no external publication occurred.
- `claude plugin validate .` on the dev plugin: passes (one cosmetic warning:
  no author field — intentional for a non-public scaffold).

## 2. What was built

```
release-hardening/evals/mao-dev-plugin/        # dev-only plugin (NOT for distribution)
├── .claude-plugin/plugin.json                 # name: mao-dev, version 0.1.0
├── skills/multi-agent-orchestration/          # byte-identical copy of the canonical skill
│                                              # (hash-verified; re-copy on every canonical change)
└── evals/
    ├── README.md                              # run commands + honest scope statement
    ├── core/                                  # LIVE cases (run today)
    │   ├── trigger-positive/                  # positive MAO trigger
    │   ├── shim-sim-trigger/                  # same + shim text via append_system_prompt (SIMULATION)
    │   ├── anti-overdelegation-trivial/       # zero-agent case (scenario A)
    │   └── ordinary-task-no-overclaim/        # unrelated task ⇒ skill must not fire
    ├── boundary/                              # DORMANT cases (need co-loaded Superpowers; see §4)
    │   ├── boundary-j-plan-fixture/           # REQUIRED SUB-SKILL artifact case (scenario J)
    │   ├── boundary-k-explicit-sdd/           # explicit SDD yield (scenario K)
    │   └── boundary-inline-executing-plans/   # explicit other-workflow selection (inline)
    └── companion/
        └── run-boundary-companion.sh          # the real-machine boundary tripwire (see §5)
```

Grader strategy per required case class:

| Required class | Case | Graders | Honest notes |
|---|---|---|---|
| positive MAO trigger | `trigger-positive` | `tool_used: Skill` (mao, indicator), `tool_used: Agent/Task max:3` (both arms), `llm` synthesis rubric | spawn-count cap asserts anti-overdelegation without over-constraining legitimate 0/1/3-way choices |
| zero-agent / anti-overdelegation | `anti-overdelegation-trivial` | `Agent`/`Task` `min:0 max:0` (arm both), `file_exists`, file `regex` | the exact scenario-A contract, fully observable |
| unrelated ordinary task | `ordinary-task-no-overclaim` | `Skill` mao `min:0 max:0` (arm both), file `regex` | scored in BOTH arms — a baseline-arm firing would itself be a routing false positive |
| explicit SDD yield | `boundary-k-explicit-sdd` | SDD `tool_used` (indicator), mao `min:0 max:0`, `llm` cadence rubric | **dormant** — needs real Superpowers |
| plan artifact w/ REQUIRED SUB-SKILL | `boundary-j-plan-fixture` | SDD `min:0 max:0`, mao indicator, `llm` trace rubric | authentic fixture vendored; **dormant** |
| explicit other-workflow selection | `boundary-inline-executing-plans` | executing-plans discipline assertions, SDD `min:0 max:0`, mao `min:0 max:0` | **dormant** |

No test was weakened for automatability: where the harness cannot observe the
property (the three boundary classes), the cases are kept at full strength and
marked dormant rather than approximated by a weaker proxy.

## 3. Pilot results (run this session, cheap)

1. **`core/anti-overdelegation-trivial`** — `--runs 1 --ablation none
   --allow-tools Write`: **score 1.00, $0.07, 26 s**. All four graders passed:
   README created, spelling corrected, `Agent` called 0×, `Task` called 0×.
   Proves: case loading, Skill/tool graders, file graders, cost model, and
   the zero-agent property are all observable and assertable.
2. **`core/trigger-positive`** — two single-run pilots:
   - pilot 1 ($0.54): MAO skill invoked 1×, exactly 3 parallel agents, llm
     rubric PASS — description-only routing fired.
   - pilot 2 ($0.69): 3 parallel agents and a PASS rubric again, but the
     Skill tool was **not** invoked — the model applied the policy reasoning
     without loading the skill body.
   - Measurement meaning: description-only trigger firing is **1/2 in these
     samples** — genuine trigger-rate variance, the exact quantity the
     harness exists to measure (owner decision D1 becomes empirical once
     multi-run arms exist). Note on run modes: with `--ablation none`, a
     `tool_used: Skill` grader counts toward the score (hence 0.75 in pilot
     2); in the default two-arm mode it is automatically an unscored
     plugin-fired indicator — use the two-arm mode for trigger-rate
     reporting and `--runs 3` for stable rates. The grader was NOT weakened
     to make pilot 2 pass.
3. **YAML gotcha fixed:** colons inside unquoted frontmatter prose break case
   loading (cases initially failed to parse; reworded).
4. **`--case` matches the case NAME** (frontmatter `name`), not the path
   (`--case 'anti-over*'`, not `--case 'core/anti…'`).
5. **Gated tools:** `Write`/`Edit`/`Bash` need `--allow-tools`; listing `Edit`
   in frontmatter without the grant prints a per-case warning. The README's
   run commands carry the grants.

## 4. The boundary-case limitation (empirically established, not assumed)

The eval sandbox gives each run "a throwaway home directory … and Claude Code
configuration … with **only your plugin loaded**": no user CLAUDE.md (so
MAO's shim — the historically strongest routing layer — is absent), no other
plugins (so no Superpowers/SDD). Attempts to co-load the real Superpowers
6.4.1 as a second plugin under test, this session:

- case-level `plugins:` entry with a relative path outside the enclosing
  plugin → rejected ("resolves to … outside the containment root …");
- symlink from inside the plugin to the installed cache → rejected
  ("does not exist" — symlinks not followed);
- real directory at the plugin root → rejected (a plugins entry "names the
  case directory, its graders or mocks, or a directory covering them — a
  plugin shipped with a case must sit in its own subdirectory");
- a full 2.5 MB unmodified copy vendored **inside a case directory** would
  satisfy containment, but would duplicate the third-party tree per case
  (×3–4) and freeze a snapshot that the boundary semantics explicitly do
  NOT want frozen (the upgrade-check exists to track live Superpowers).
  Considered and **rejected for Gate 1**; recorded as a Gate-2 option (a
  single pinned vendored SDD as a deterministic fixture) or an upstream
  feature request (dependency-plugin co-loading in evals).

Therefore the three boundary cases ship **dormant** (tagged `dormant`, not in
the default run set) with graders kept at full strength, and boundary
regression runs through the companion harness below. `shim-sim-trigger`
partially covers instruction-channel routing as a labeled simulation
(`append_system_prompt` is system-prompt tier, not the user-instruction tier
the real shim occupies — bounded above by the sim, below by description-only).

## 5. The behavioral companion harness (automatable boundary tripwire)

`evals/companion/run-boundary-companion.sh <evidence-dir> [j|k|d]` automates
the campaigns' proven method on the real machine, where the shim, the
personal skill, and the live Superpowers plugin all coexist exactly as
installed:

1. builds the disposable notectl seed + fixture plan per case (adversarial
   MUST/strictly-prohibited header variant for case `d`);
2. runs the scenario-J/K/D prompts through the same harness the campaigns
   used (`cc-zai -p --dangerously-skip-permissions --output-format json`);
3. copies the session transcripts out of `~/.claude/projects/…`;
4. asserts on **actual tool-call events** via `tests/tools/analyze_run.py`
   (never model self-report): `j`: SDD never loaded; `k`: SDD loaded and MAO
   not; `d`: SDD never loaded;
5. exits non-zero on any boundary failure (CI-able) and records per-run
   analyze output for reviewer inspection.

Cost: three full plan-execution sessions (historically $2.90–11.24 each
depending on mode; recorded per run for provenance only — no cross-model
comparisons). This is the harness that produced
`01-superpowers-6.4.1-upgrade-check.md` (the script is the formalized version
of the procedure this Gate ran by hand).

## 6. What is automatable today vs not (summary)

- **Automatable now, cheap, CI-able:** trigger rates (positive/negative),
  zero-agent anti-overdelegation, spawn-count caps, shim-sim routing bound.
- **Automatable now, costlier, real-machine:** the three boundary behaviors
  (companion script; transcripts + tool-event assertions).
- **Not automatable at all today:** boundary behaviors inside the
  plugin-eval sandbox itself (platform containment); Codex/ZCode legs
  (different CLIs; Codex additionally auth-blocked locally right now).
- **Gate-2 options recorded, not decided:** vendored pinned SDD fixture for
  in-sandbox boundary cases; upstream request for eval dependency-plugins;
  multi-model trigger-rate arms (plugin eval runs real sessions per model).

## 7. Sync discipline for the dev plugin

The `skills/multi-agent-orchestration/` copy inside `mao-dev-plugin` is
byte-identical to the canonical tree by hash. Whenever the canonical source
changes (as it did in this Gate for the two adapter corrections), re-copy and
re-verify:

```sh
diff -r ~/.local/share/ai-agent-orchestration/multi-agent-orchestration \
        release-hardening/evals/mao-dev-plugin/skills/multi-agent-orchestration
```

(The copy in this commit reflects the post-Gate-1 corrected core; see
05-core-semantics-diff.md.)
