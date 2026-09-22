# OLD-NAME-REMAINING-REGISTER — every retained MAO-family occurrence in the repository

Enumerated with: `rg 'multi-agent-orchestration|Multi-Agent Orchestration|Multi-agent
orchestration|ai-agent-orchestration|\bMAO\b|\bmao\b|mao-dev|mao-orchestration'`.
Machine-local (outside-repo) occurrences are covered in `04-post-migration-name-audit.md`.
Success criterion (§17): every entry below is HISTORICALLY REQUIRED; none represents the
current product identity.

## A. Frozen historical evidence trees (committed artifacts authored under the old name)

| Location | Occurrences | Justification |
|---|---|---|
| `audit/00–06` (7 files) | 113 | 2026-09-22 frozen-state forensic audit artifacts — hash-pinned provenance records created when the product was named MAO. Rewriting would falsify provenance (§4). |
| `historical-notes/v0-v3-lineage/` (8 files) | 26 | raw v0/v1 SKILL snapshots and campaign diffs — primary historical evidence. |
| `release-hardening/01-superpowers-6.4.1-upgrade-check.md` | 27 | dated Gate-1 verification record (2026-09-22). |
| `release-hardening/02-codex-fork-turns-verification.md` | 7 | dated Gate-1 verification record. |
| `release-hardening/03-superpowers-adapter-refresh.md` | 12 | dated Gate-1 verification record. |
| `release-hardening/evals/iaa-dev-plugin/evals/results/**` (gitignored) | — | generated pilot-run artifacts (2026-09-22); moved with the parent directory, content untouched. |

## B. Historical-fact references inside current documentation

| Location | Occurrence | Justification |
|---|---|---|
| `CANONICAL-README.md` (+ web copy) | `~/mao-sdd-archfix-20260827/`; "known as MAO / Multi-Agent Orchestration at install time" | machine-local evidence-tree path (real dir name, retained); §4C provenance framing. |
| `comparison/FINAL-COMPARISON-REPORT.md` | "written while the product was named MAO / Multi-Agent Orchestration" | §4C framing of a dated report. |
| `comparison/08-owner-decision-register.md` | `mao-orchestration` in D5 candidates list | preserved decision-history enumeration, explicitly labeled historical; decision recorded as made. |
| `docs/HISTORY.md` | `01-BASELINE-AND-MAO-TOPOLOGY.md`; "pre-rename name MAO" | foreign-repo (isakli05/llm_council_orchestrator) filename — its real name contains MAO; renaming the reference would falsify the pointer. |
| `docs/HISTORICAL-EVIDENCE-DISPOSITION.md` | `~/mao-sdd-*` paths; `*mao*` session-dir glob; LCO `01-BASELINE-AND-MAO-TOPOLOGY.md` | evidence-disposition facts incl. foreign-repo filenames. |
| `docs/adr/0002`, `docs/adr/0003` | `~/mao-sdd-archfix-20260827/`, `~/mao-sdd-artifact-boundary-20260827/` | raw-evidence pointer paths (real dir names). |
| `release-hardening/FINAL-GATE-1-REPORT.md` | `~/mao-sp641-upgrade-check-20260922/` | Gate-1 machine-local evidence-tree path. |
| `web-project-sources/07-HISTORY-AND-EVIDENCE.md` | the two `~/mao-sdd-*` campaign paths | evidence-tree paths. |

## C. LEGACY migration/detection code (§14 allowance, explicitly labeled)

| Location | Occurrence | Justification |
|---|---|---|
| `iaa/scripts/manage.sh` (+ dev-plugin byte-identical copy) | `LEGACY_MANAGED_BEGIN/END` marker literals, `LEGACY_STATE_DIR=~/.config/ai-agent-orchestration`, `LEGACY_SKILL_NAME=multi-agent-orchestration` (+1 comment) | recognize pre-rename installs so they can be migrated/uninstalled cleanly; every use is prefixed `LEGACY` and new installs never create these. |
| `release-hardening/evals/iaa-dev-plugin/evals/companion/run-boundary-companion.sh` | `"multi-agent-orchestration" in … skill` legacy transcript matcher | keeps historical (pre-rename) transcripts analyzable; current name `iaa` matched first, legacy explicitly commented. |

## D. This audit set itself

`identity-migration/01…04`, `02-rename-map.md`, `FINAL-IAA-IDENTITY-MIGRATION.md` quote
old tokens as audit subject matter (classification lists, mappings, counts).

## Verdict

No remaining occurrence in the repository denotes the **current** product identity.
All are historical evidence (§17-A/B), legacy-detection code (§17-C), or
"formerly MAO" provenance documentation (§17-D).
