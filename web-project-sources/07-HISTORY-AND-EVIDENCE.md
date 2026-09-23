# 07 — History and Evidence

## Timeline (all 2026, Istanbul; hash- and report-verified)

| When | Event |
|---|---|
| 08-26 early | Live audit of Codex native multi-agent (MultiAgentV2 tools, fork semantics, roles) — design research before installing anything |
| 08-26 17:39–17:54 | **v0 install** for 3 runtimes (manage.sh; backups; symlinks; shims; depth key). Codex smoke A–E passes (after tightening: no manufactured reviewer on trivial tasks) |
| 08-27 00:55–06:28 | **Campaign 1 — collision smoke test**: İAA vs co-loaded SDD, 6-task seed repo, glm-5.3. İAA keeps topology authority; SDD's review cadence + no-parallel rule leak; ~2.5× cost. PARTIAL PASS |
| 08-27 07:39–08:47 | **Campaign 1b — prose post-fix (v1)**: 4 attempts; identical wording, opposite outcomes across samples ⇒ prose precedence unreliable. PARTIAL PASS; stop the arms race |
| 08-27 10:24–15:22 | **Campaign 2 — structural archfix (v2)**: two-mode separation at skill-selection; shim routing sentence; scenarios J/K. Tests: SDD never loads in İAA mode (3/3); native opt-in intact (15 agents). PASS |
| 08-27 16:22–21:20 | **Campaign 3 — artifact boundary (v3)**: provenance rule. Authentic adversarial plan fixture; incl. strengthened "MUST use SDD" variant. PASS |
| 08-27 21:20 → | source frozen (v3 unchanged since) |
| 09-06 | **Production use**: LCO fifth-audit program under İAA adaptive mode (3 parallel read-only investigators → primary plan → primary sequential TDD), documented in isakli05/llm_council_orchestrator |
| 09-22 | This baseline audit + private GitHub baseline |

## The two 2026-08-27 evidence trees (what the task brief asked about) — and a third

1. `~/mao-sdd-archfix-20260827/` — campaign 2 evidence: before/after snapshots +
   exact diffs (the only surviving pre-git lineage), 4 test runs (repos/transcripts/runs),
   FINAL-REPORT (PASS). Pure evidence; every source change in it is hash-proven present in
   current canonical.
2. `~/mao-sdd-artifact-boundary-20260827/` — campaign 3 evidence: snapshots +
   additions-only diffs, the authentic generated adversarial plan (438 lines, real
   "REQUIRED SUB-SKILL" header), session-a plan generation + tests B/C/D, FINAL-REPORT
   (PASS). Pure evidence.
3. `~/collision-smoke-test-evidence/` (+ report + zip at home root) — the brief
   didn't name this one: campaigns 1 + 1b (taskcli seed repo with git history, 12 session
   transcripts, 4 post-fix attempts, policy snapshots v0/v1). PARTIAL PASS ×2 — the
   *failure* evidence that justifies the current design.

**Disposition:** trees stay byte-identical in place (local-only; transcripts/costs/model
data not for publication). Into the maintained repo went only: condensed ADRs, the lineage
diffs + v0/v1 snapshots, the sanitized plan fixture, and the transcript analyzer tool.
They are *not* runtime content and never were: canonical runtime source is and always was
`~/.local/share/iaa/` alone.

## Evidence quality notes

- Behavioral tests observed actual tool-call events (transcript-extracted), not model
  self-report; an analyzer script (now `tests/tools/analyze_run.py`) did the extraction.
- Cost/model: glm-5.3[1m] via GLM provider on Claude Code 2.1.246; seed commit ff735a6
  reused across campaigns for comparability.
- Known honesty caveats preserved: test D (adversarial) had a priming risk (disclosed);
  reviewer-count variance across samples is called legitimate materiality variance, not
  success/failure; install-session transcript was not preserved (actions reconstructed
  from manage.sh + backups).
