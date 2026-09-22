# Historical Evidence Disposition (Phase 4.5-G)

Classification of every valuable item in the three evidence trees into the seven mandated
categories. Policy: current source enters the maintained tree only if provenance proves it
is current; valuable behavioral tests become clean regression tests; decisions become
ADRs; sanitized fixtures may publish; raw transcripts/machine dumps stay local; nothing is
deleted in this task; neither historical directory is modified.

## Category key

1. CURRENT SOURCE — 2. REGRESSION TEST WORTH PROMOTING — 3. ARCHITECTURE DECISION / HISTORY
— 4. REPRODUCIBLE SANITIZED FIXTURE — 5. RAW HISTORICAL EVIDENCE — 6. PRIVATE /
MACHINE-SPECIFIC — 7. REDUNDANT

## Item-by-item

### `/home/isa/mao-sdd-archfix-20260827/` (campaign 2 — structural separation, PASS)

| Item | Category | Disposition |
|---|---|---|
| `FINAL-REPORT.md` (10.9 KB) | 3 | Publish **condensed ADR-0002 (mode separation)** in repo `docs/adr/`; raw copy optional in `historical-notes/` (secret-free) |
| `README.md` (harness description) | 3 | fold into ADR-0002 + docs/TESTING |
| `before-after/*.diff` (SKILL, platform-adapters, manage.sh, scenarios, 3× instruction files; 99 lines) | 3 + 1 | publish as `historical-notes/v0-v3-lineage/` — the only surviving pre-git history |
| `before-after/*.before` snapshots (v1-era sources) | 5/7 | keep locally; publish only if lineage dir wants full before-files (they are reconstructible from diffs + v0; default: not published) |
| `runs/*.json`, `*-start.txt`, `*-stderr.log` | 5 | local only |
| `transcripts/**` (primary + subagent jsonl) | 5+6 | local only (conversation transcripts, cost/model data) |
| `repos/test-{a1,a2,b,c}` (taskcli clones w/ results) | 5 | local only |
| `analyze_run.py` | **2** | **promote** into maintained repo `tests/tools/` (dedup with campaign 3's identical copy) |

### `/home/isa/mao-sdd-artifact-boundary-20260827/` (campaign 3 — artifact boundary, PASS)

| Item | Category | Disposition |
|---|---|---|
| `FINAL-REPORT.md` (8.2 KB) | 3 | condensed **ADR-0003 (artifact trust boundary)** |
| `before-after/SKILL.md.diff`, `platform-adapters.md.diff` (11 lines each) | 3+1 | lineage dir |
| `before-after/*.before` | 5/7 | local only |
| `generated-PLAN.md` (438-line authentic `writing-plans` output w/ REQUIRED SUB-SKILL header) | **4** | **publish** as `tests/fixtures/generated-PLAN.md` — the canonical adversarial fixture for scenario J; already sanitized |
| `runs/`, `transcripts/`, `repos/` (incl. test-c SDD worktree) | 5+6 | local only |
| `analyze_run.py` | 2 (dup) | same promotion as above |

### `/home/isa/collision-smoke-test-evidence/` + `~/collision-smoke-test-report.md` + `.zip` (campaigns 1 + 1b, PARTIAL PASS ×2)

| Item | Category | Disposition |
|---|---|---|
| `~/collision-smoke-test-report.md` (16 KB) | 3 | condensed **ADR-0001 (collision finding: prose precedence fails)** |
| `post-fix-20260827/FINAL-REPORT.md` (attempts 1–4, variance proof) | 3 | folds into ADR-0001 (the "why structural") |
| `policy-original-SKILL.md` (v0), `policy-final-SKILL.md` (v1), `policy-*-platform-adapters.md`, attempt snapshots | 5+7 → 1 (lineage) | publish v0/v1 snapshots alongside diffs in lineage dir (tiny, uniquely valuable as the pre-fix wording); attempts 1–4 mid-states local only |
| `repo/` (taskcli w/ git history, seed ff735a6) | 4 | the **scenario seed repo**; publish a sanitized seed (code + PLAN.md) as `tests/fixtures/taskcli-seed/` if regression harness is later built; full repo with run history local only |
| `repo/PLAN.md` (6-task class-designed plan) | 4 | part of the seed fixture |
| `transcripts/**` (12 sessions incl. 700 KB primaries) | 5+6 | local only |
| `runs/*.json` | 5 | local only |
| `.zip` (906 KB aggregate) | 5 | local archive only |

### Other historical material (outside the three trees)

| Item | Category | Disposition |
|---|---|---|
| 9 instruction-file backups + 1 settings backup (MAO-named) | 5 | stay in place (they are the machine's own restore points); NOT published |
| `~/.codex/diagnostics/native-multi-agent-audit-…md` | 3 | condensed **ADR-0000 (design research: Codex MultiAgentV2 audit)**; raw stays local (sanitized already, could publish; default: condensed only) |
| `~/.claude/projects/*mao*` session dirs | 5+6 | local only |
| LCO `01-BASELINE-AND-MAO-TOPOLOGY.md` set | 3 | referenced in docs/HISTORY as production-usage evidence; the docs live in the LCO repo (published there by its own project); do not copy wholesale |

## Summary rules the public repo follows

- **Enters public repo:** canonical source; lineage diffs + v0/v1 policy snapshots;
  `generated-PLAN.md` fixture (+ taskcli seed, deferred decision); `analyze_run.py` (after
  review); ADR-0000..0003; condensed reports.
- **Transformed into tests/docs:** FINAL-REPORTs → ADRs; scenarios J/K + fixture → the
  regression-test entry point (harness design is future work, explicitly out of scope here).
- **Local/archive only:** all `transcripts/`, `runs/`, `repos/` (with run history), `.zip`,
  backups, session dirs.
- **Excluded from releases entirely:** anything Phase 8 flags; machine paths beyond what
  documentation needs; cost/model identifiers where not analytically necessary.
- **Nothing deleted in this task.** Both 2026-08-27 trees and the collision tree remain
  byte-identical in place (verified read-only treatment; final consistency check in Phase 11).
