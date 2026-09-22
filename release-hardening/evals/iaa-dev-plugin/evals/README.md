# İAA dev eval suite (`iaa-dev`)

Development-only regression suite for the İAA skill, run with
`claude plugin eval`. This is **not** public packaging: the `iaa-dev` plugin
exists only so the eval harness can load the skill in its sandbox. The skill
under `skills/iaa/` is a byte-identical copy of the
canonical tree (hash-verified; re-copy it whenever the canonical source
changes — see `../../04-plugin-eval-design.md`).

## Running

From this plugin root (`release-hardening/evals/iaa-dev-plugin/`):

```sh
# core cases only (cheap, no external plugins needed):
claude plugin eval . --case 'trigger*' --case 'anti-over*' --case 'ordinary*' \
  --case 'shim-sim*' --trust-plugin --allow-tools Write Edit

# boundary cases additionally need Bash (plan execution) and --scaffold —
# but see "The boundary-case problem" below before running them:
claude plugin eval . --case 'boundary*' --trust-plugin --scaffold \
  --allow-tools Write Edit Bash
```

(`--case` globs match the case NAME from frontmatter, not its path.)

Notes:

- `--trust-plugin` asserts you trust this directory (CI / non-interactive).
- The core cases pin `model: opus[1m]`, which the local provider profile maps
  to `glm-5.3[1m]` — the same model family as İAA's historical evidence.
- `evals/results/` is git-ignored; each run writes an aggregate JSON and an
  HTML report there.
- Cost: core cases are small (a few cents to ~$0.5 per run). Boundary cases
  execute a real 5-task plan once (`runs: 1`); expect low single-digit USD
  per run.

## Case inventory

| Case | Class | What it asserts | Plugin-eval can observe directly? |
|---|---|---|---|
| `core/trigger-positive` | trigger | delegation-flavored request routes to the skill; ≤3 spawns for a 3-module read-only task | **yes** (Skill `tool_used` indicator + spawn-count graders) |
| `core/shim-sim-trigger` | trigger (shim simulation) | same, with İAA's global shim text injected via `append_system_prompt` — a SIMULATION of the CLAUDE.md routing layer (system-prompt tier ≠ user-instruction tier) | **yes**, with the tier caveat |
| `core/anti-overdelegation-trivial` | anti-overdelegation | trivial task + "use subagents where appropriate" ⇒ zero agent spawns (scenario A) | **yes** (`Agent`/`Task` min:0 max:0, scored in both arms) |
| `core/ordinary-task-no-overclaim` | anti-overclaim | ordinary task, no agent wording ⇒ skill NOT invoked | **yes** (Skill min:0 max:0, scored in both arms) |
| `boundary/boundary-j-plan-fixture` | artifact trust boundary | authentic `writing-plans` fixture with REQUIRED SUB-SKILL ⇒ SDD never invoked, İAA governs (scenario J) | **only with Superpowers co-loaded** — see below |
| `boundary/boundary-k-explicit-sdd` | explicit yield | explicit by-name SDD request ⇒ SDD governs, İAA not loaded (scenario K) | **only with Superpowers co-loaded** |
| `boundary/boundary-inline-executing-plans` | explicit other-workflow selection | explicit inline execution ⇒ executing-plans discipline, no SDD, no İAA authority | **only with Superpowers co-loaded** |

## The boundary-case problem (honest scope statement)

The eval sandbox loads **only the plugin under test**: no user CLAUDE.md (so
İAA's shim — the historically strongest routing layer — is absent except in
the `shim-sim` simulation), and **no other plugins** (so Superpowers/SDD is
absent). Empirically established this Gate (see `../../04-plugin-eval-design.md`
§4): a case-level `plugins:` entry cannot resolve outside the enclosing
plugin (containment root), symlinks out are rejected, and any directory that
covers the case is rejected — so the real Superpowers cannot be co-loaded
today. Therefore:

- The three `boundary/*` cases are **dormant by design** (tagged `dormant`):
  complete and gradable at full strength, but their SDD assertions can only
  be meaningful with a co-loaded Superpowers. Running them without it would
  produce vacuous passes — do not read them as boundary evidence.
- Boundary regression runs through the **behavioral companion harness**:
  `companion/run-boundary-companion.sh` (real machine, real co-install,
  transcript tool-event assertions — the same method as
  `../../01-superpowers-6.4.1-upgrade-check.md`).
- What plugin-eval DOES give İAA today, measured and CI-able: trigger rates
  (positive and negative), anti-overdelegation spawn counts, and (via the
  shim-sim arm) a bounded simulation of instruction-channel routing. Pilot
  results (2026-09-22): `anti-overdelegation-trivial` 1.00 at $0.07 (0
  spawns on a "use subagents where appropriate" trivial task);
  `trigger-positive` fired the skill in pilot 1 (1 Skill call + exactly 3
  parallel agents) and not in pilot 2 (3 agents, rubric PASS, no Skill call)
  — description-only trigger variance of 1/2, a real measurement, not a bug.
  For trigger-rate reporting use the default two-arm mode (Skill graders are
  then unscored indicators) with `--runs 3`.

No grader in this suite was weakened to make automation possible; properties
the harness cannot observe are marked above instead of being approximated.
