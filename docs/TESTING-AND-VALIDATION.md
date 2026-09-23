# Testing and Validation

## What exists today

1. **Static checks (runnable, current):**
   - `scripts/manage.sh verify` — links resolve to canonical; shim markers well-formed (one
     ordered pair each); Claude depth == 1; description ≤1024 B. (Runs against the LIVE tree.)
   - `~/.codex/skills/.system/skill-creator/scripts/quick_validate.py <skill-dir>` — SKILL.md
     format validity (Codex's own validator; used by every campaign).
2. **Behavioral scenario contract** — `tests/scenarios.md`, scenarios A–K: manual,
   LLM-behavioral scenarios designed for a disposable repo ("observe actual agent/tool
   activity; do not rely only on the model's self-report"). NOT automated; executed ad hoc
   by the campaigns.
3. **Campaign evidence (2026-08-27)** — 3 trees of runs/transcripts/repos proving the
   boundary behaviors (ADR-0001..0003; per-behavior map in docs/CURRENT-ARCHITECTURE §12).
4. **`tests/tools/analyze_run.py`** (promoted from campaigns) — extracts skill invocations
   and agent spawns from a Claude session transcript (JSONL) — the verification tool that
   made "observe, don't self-report" practical.

## How to re-run key checks (safe, current machine)

```sh
~/.local/share/iaa/iaa/scripts/manage.sh verify
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  ~/.local/share/iaa/iaa
# transcript analysis of any preserved campaign run:
python3 tests/tools/analyze_run.py <path-to-primary-transcript.jsonl>
```

Behavioral scenario J (mode separation) re-run procedure: fresh disposable repo; taskcli
seed or any 6-task plan; prompt "Execute the full plan… Use subagents where appropriate.";
`cc-zai -p --dangerously-skip-permissions --output-format json`-style harness (see
CANONICAL-README + campaign READMEs); then `analyze_run.py` to verify SDD was never invoked.
Re-run after every Superpowers update (upgrade-check procedure in CANONICAL-README).

## Scenario execution record

| Scenario | Ever executed? | Where |
|---|---|---|
| A–E (trivial/exploration/overlapping-write/explicit/implicit) | YES — install-time Codex smoke (A needed one policy tightening, then passed) | README validation log; session `-tmp-iaa-smoke-*` |
| F nested-delegation boundary | NO (rejection side incidentally proven everywhere; authorized-nesting path never exercised) | — |
| G conflicting fan-out skill | SUPERSEDED by the real instance: campaigns 1–3 tested the actual SDD collision far harder | campaign trees |
| H failed/interrupted child | NO | — |
| I Explore constraint propagation | IN PRACTICE (campaign briefs contain restated constraints) but not as a controlled scenario | — |
| J mode separation (default) | YES — archfix A1/A2, boundary B/D (4 samples + adversarial) | campaign trees |
| K explicit native opt-in | YES — archfix B, boundary C | campaign trees |

## Updates since the baseline freeze

- 2026-09-23 (Gate 1): `claude plugin eval` regression foundation exists
  (`release-hardening/evals/iaa-dev-plugin/`) and the behavioral companion
  harness formalizes the campaign method (`…/evals/companion/`).
- 2026-09-23 (Gate 2): static CI (layer A: parity/manifests/frontmatter/secrets/
  identity scopes + `tests/doctor/` + `tests/install-matrix/`), model evals
  (layer B: trigger suite), and the real-machine companion (layer C) — see
  `release-hardening/gate-2/09-ci-regression.md`. The 1024-B vs ~250 bound gap
  is closed at the packaging layer (frontmatter validation enforces the 250-B
  core-description budget).

## Known gaps that remain (documented, deliberate)

- Scenarios F/H/I controlled runs; non-plan artifact channels; GSD/BMAD
  coexistence; non-glm model families (see KNOWN-LIMITATIONS).
- ZCode behavioral re-validation needs the desktop UI (manual checklist
  prepared: gate-2/07 §6).
