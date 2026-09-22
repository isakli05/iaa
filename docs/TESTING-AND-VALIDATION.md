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
~/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh verify
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  ~/.local/share/ai-agent-orchestration/multi-agent-orchestration
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
| A–E (trivial/exploration/overlapping-write/explicit/implicit) | YES — install-time Codex smoke (A needed one policy tightening, then passed) | README validation log; session `-tmp-multi-agent-orchestration-smoke-*` |
| F nested-delegation boundary | NO (rejection side incidentally proven everywhere; authorized-nesting path never exercised) | — |
| G conflicting fan-out skill | SUPERSEDED by the real instance: campaigns 1–3 tested the actual SDD collision far harder | campaign trees |
| H failed/interrupted child | NO | — |
| I Explore constraint propagation | IN PRACTICE (campaign briefs contain restated constraints) but not as a controlled scenario | — |
| J mode separation (default) | YES — archfix A1/A2, boundary B/D (4 samples + adversarial) | campaign trees |
| K explicit native opt-in | YES — archfix B, boundary C | campaign trees |

## Known gaps (frozen baseline; future work, not undertaken here)

- No automated regression harness exists; scenarios are manual by design (they test model
  behavior, not code). The fixture (`tests/fixtures/generated-PLAN.md`) and analyzer
  (`tests/tools/analyze_run.py`) are the building blocks if one is built.
- `manage.sh verify` uses a 1024-B description bound although the operative ZCode constraint
  is ~250 chars (see KNOWN-LIMITATIONS).
- Codex/ZCode not behaviorally re-tested after campaigns 2–3 (Claude-specific demonstrated
  risk; ZCode needs desktop UI).
