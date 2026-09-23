# 07 — History and Evidence (provenance guide)

Timeline is hash- and report-verified; every event cites its record in the
repository. Deep versions: `docs/HISTORY.md`, `docs/POLICY-LINEAGE.md`,
`docs/adr/0000–0003`. İAA was **MAO / Multi-Agent Orchestration** during the
August 2026 evidence campaigns; renamed 2026-09-23 before any public release
(token-only rename, semantics proven unchanged — `identity-migration/`). MAO
in an evidence file means the same product, earlier name.

## Timeline (2026, all dates evidence-recorded)

| When | Event |
|---|---|
| 08-26 early | Live audit of Codex native multi-agent — design research before installing anything (ADR-0000) |
| 08-26 17:39–17:54 | **v0 install** for 3 runtimes; Codex smoke A–E passes after one tightening (no manufactured reviewer on trivial tasks) |
| 08-27 00:55–06:28 | **Campaign 1 — collision smoke test**: İAA vs co-loaded SDD. İAA kept topology authority; SDD cadence leaked; ~2.5× cost. PARTIAL PASS (ADR-0001) |
| 08-27 07:39–08:47 | **Campaign 1b — prose post-fix (v1)**: identical wording, opposite outcomes across samples ⇒ prose precedence unreliable. PARTIAL PASS |
| 08-27 10:24–15:22 | **Campaign 2 — structural archfix (v2)**: two-mode separation at skill selection; scenarios J/K. PASS (ADR-0002) |
| 08-27 16:22–21:20 | **Campaign 3 — artifact boundary (v3)**: provenance rule; authentic + adversarial plan fixtures. PASS (ADR-0003) |
| 08-27 21:20 → | policy frozen: v3 unchanged since (hash-pinned lineage) |
| 09-06 | Production use: LCO fifth-audit program under Adaptive İAA mode (documented in the LCO repo) |
| 09-22 | Forensic baseline audit → migration into this repository (private baseline) |
| 09-22 | Competitive comparison vs SDD/GSD/BMAD/native systems: 4 differentiators confirmed, no counter-finding (`comparison/FINAL-COMPARISON-REPORT.md`) |
| 09-22/23 | **Gate 1**: Superpowers 6.4.1 upgrade check + eval foundation |
| 09-23 | **Identity migration** MAO→İAA (token-only; byte-equivalence proof) |
| 09-23 | **Gate 2**: packaging (3 plugin forms), `/iaa:orchestrate` + `/orchestrate` invocation, `iaa doctor`, static CI, trigger characterization (68 sessions: 0/13 false positives, 6/6 yields) |
| 09-23 | **Gate 3**: MIT + NOTICE license, publication readiness |
| 09-23 | **İAA 0.1.0 — first public release** |
| 09-23 | ZCode official validation of 0.1.0: found one-skill-contract failure + raw-URL marketplace resolution failure; 0.1.1 corrective plan (`post-release/zcode-official/`) |
| 09-23 | **İAA 0.1.1 published**: ZCode packaging fix (Command instead of second skill, remote sha256-pinned marketplace), tag + GitHub release, deterministic artifacts, GUI acceptance at ZCode 3.14.3 (one skill, one command, zero-agent runs, clean disable/uninstall) |
| 09-23 | **Upstream PR opened**: zai-org/zcode-plugins#42 (`feat(iaa): add adaptive delegation policy plugin`) |

## Where the evidence lives now

- **In the repository (public):** condensed ADRs 0000–0003; lineage diffs +
  v0/v1 policy snapshots (`historical-notes/v0-v3-lineage/`); the sanitized
  adversarial plan fixture (`tests/fixtures/generated-PLAN.md`); the
  transcript analyzer (`tests/tools/analyze_run.py`); Gate/comparison/release
  reports (`release-hardening/`, `comparison/`, `post-release/`,
  `audit/`, `identity-migration/`); eval suites + results
  (`release-hardening/evals/`).
- **Machine-local only (not published, by disposition policy):** raw campaign
  transcripts/runs/repos, cost dumps, instruction-file backups, session dirs
  (`docs/HISTORICAL-EVIDENCE-DISPOSITION.md`). The authoritative source is the
  repository `iaa/`; the live `~/.local/share/iaa` tree is a deploy projection
  of it (normalized Gate 2 — earlier "edit the live tree" procedure retired).

## Evidence quality notes (permanent)

- Behavioral tests observed actual tool-call events (transcript-extracted),
  never model self-report.
- Honesty caveats are preserved, not laundered: adversarial test D had a
  disclosed priming risk; reviewer-count variance across samples is labeled
  legitimate materiality variance; the install-session transcript was not
  preserved (actions reconstructed from the installer + backups).
- All behavioral evidence is single-model (GLM-5.3 profile on Claude Code);
  no other family sampled (IAA-BL-007).

**Stable file** — events after this timeline and current open external work
are read live from GitHub (`docs/BACKLOG.md`, releases/tags, PRs/issues).
