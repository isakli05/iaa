# 08 — Tests and Validation

## What exists

- **Static:** `manage.sh verify` (links/markers/depth/description-length against the live
  tree; passes 2026-09-22) and Codex's `quick_validate.py` (skill format; used by every
  campaign).
- **Behavioral scenario contract:** `tests/scenarios.md` A–K — manual LLM-behavioral
  scenarios for a disposable repo, with the rule "observe actual agent/tool activity; do
  not rely only on the model's self-report."
- **Campaign evidence (2026-08-27):** the executed proof set (see 07).
- **Analyzer:** `analyze_run.py` — extracts skill invocations + agent spawns from session
  transcripts; this is how "SDD never loaded" and "0 nested spawns" were verified as facts
  rather than claims.

## Scenario execution record

| Scenario | Executed? | Result |
|---|---|---|
| A trivial / B independent exploration / C overlapping write / D explicit request / E implicit benefit | YES (install-time, Codex) | pass (A needed one policy tightening first: no manufactured reviewer for trivial edits) |
| F nested-delegation boundary | rejection side incidentally proven (0 nested spawns in every run); authorized-nesting path never exercised | partial |
| G conflicting fan-out skill | superseded — the real SDD collision was tested far harder (campaigns 1–3) | covered |
| H failed/interrupted child | never executed | gap |
| I Explore constraint propagation | happens in practice (briefs contain restated constraints); not a controlled test | partial |
| J mode separation (default) | YES ×4 + adversarial (archfix A1/A2, boundary B/D) | pass |
| K explicit native opt-in | YES ×2 (archfix B, boundary C) | pass |

## Documented-only behaviors (claimed, not test-proven)

Failed-child recovery (H) as a controlled scenario; authorized nested delegation; the
provenance rule for non-plan artifact channels; ZCode live behavior post-campaigns; Codex
behavior post-campaigns; any model family other than glm-5.3 (+ install-time GPT-5.6-sol
for the native audit).

## Re-run recipe (current machine, safe)

manage.sh verify + quick_validate.py anytime. Scenario J: disposable repo + plan fixture →
"Execute the plan… Use subagents where appropriate." → analyze_run.py over the transcript →
assert SDD never invoked. Run after every Superpowers update (documented upgrade-check).
