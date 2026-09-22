# Audit 02 — Provenance and Chronology

All times Europe/Istanbul (UTC+3). Evidence: file hashes (sha256), content diffs, campaign
reports, manage.sh source, backup filenames, session-transcript metadata, and mtimes (as
supporting evidence only — chronology below is anchored on report content + backup stamps +
hash lineage, not mtimes alone).

## 1. Cryptographic lineage of the canonical files (FACT)

SKILL.md versions (all hashes distinct; chain verified end-to-end):

| Version | sha256 (first 8) | Size | Where found | Meaning |
|---|---|---:|---|---|
| v0 | `38128852` | 5,736 B | `collision-smoke-test-evidence/post-fix-20260827/policy-original-SKILL.md` (= attempt-1 `policy-before-SKILL.md`) | as installed 2026-08-26 17:54 (prose-precedence era; "Workflow-skill compatibility" section) |
| v1 | `1a04e5e9` | 7,326 B | same tree `policy-final-SKILL.md` = `mao-sdd-archfix-…/SKILL.md.before` | after campaign-1b prose fix (2026-08-27 08:47) |
| v2 | `0d3ea454` | 7,446 B | `mao-sdd-artifact-boundary-…/SKILL.md.before` | after campaign-2 archfix (2026-08-27 10:28) |
| **v3 (current)** | `fee98091` | 7,913 B | `~/.local/share/ai-agent-orchestration/multi-agent-orchestration/SKILL.md` | after campaign-3 artifact-boundary (2026-08-27 16:22) |

Size arithmetic confirms additions-only application at each step (7,326 + diff → 7,446;
7,446 + 467 B of additions → 7,913). Exact diffs preserved in both evidence trees.

- `manage.sh`: archfix `.before` = `5782b4d9` (14,810 B) → current = `fce2d7bb`
  (14,945 B) = artifact-boundary `.before` (its diff is empty — unchanged since archfix,
  which altered only the embedded shim sentence).
- `platform-adapters.md`: collision original `a3875f20` (3,158 B) → post-fix final
  (3,502 B) → archfix-after `917be4d7` (3,526 B) → current `eba2257a` (3,615 B).
- `scenarios.md`: changed only by archfix (scenarios J, K added); delegation-contract.md
  unchanged since install (mtime 2026-08-26 17:43).
- Superpowers SDD `SKILL.md` mtime **2026-08-17 02:53** — untouched through all campaigns
  ("no plugin file modified" claims in all three reports: verified).

## 2. Reconstructed chronology

| When (2026) | Event | Class |
|---|---|---|
| 08-26 ~02:00–04:00 | Codex native MultiAgentV2 capability audit (`~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md`): verified spawn_agent/send_message/followup_task/wait_agent/interrupt_agent/list_agents, fork_turns isolation semantics, reviewer agent_type, on Codex 0.149.1 | FACT (sanitized doc, thread IDs, timestamps) |
| 08-26 01:56 | `~/.codex/agents/reviewer.toml` created (pre-existing Codex reviewer role; MAO later documents it as not-created-by-MAO) | FACT (mtime; README claim) |
| 08-26 17:39:41 | `manage.sh install` first run: backups of `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.zcode/AGENTS.md`, `~/.claude/settings.json` created; depth state initialized (`managed-absent`); `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` written to settings.json env | FACT (backup filenames; state file; settings diff; manage.sh logic) |
| 08-26 17:43:55 | Second installer pass normalized shims → second set of `…T174355` backups; 3 relative symlinks created (`~/.agents`, `~/.claude`, `~/.zcode` skills); README states later runs byte-identical | FACT |
| 08-26 17:45 | Install-time smoke test session (`-tmp-multi-agent-orchestration-smoke-kHHQnF`) | FACT (session dir) |
| 08-26 17:54 | SKILL.md v0 final (mtime preserved via `policy-original-SKILL.md`) | FACT |
| 08-27 00:55–06:28 | **Campaign 1 — collision smoke test**: taskcli repo at `/tmp/mao-sdd-collision-20260827`, seed `ff735a6`; run 1 (MAO-shaped, 3 workers, $3.76) and run 2 (both skills loaded, 9 agents, $9.57). Verdict PARTIAL PASS: topology authority retained; SDD review-cadence + sequential-implementer leakage. Report: `~/collision-smoke-test-report.md`; evidence tree + zip | FACT |
| 08-27 07:39–08:47 | **Campaign 1b — prose fix attempts 1–4** (SKILL.md v0→v1): attempt 1 partial (12 children), 2 loading-order abort, 3 strong partial (8 children, $7.51), 4 model-variance abort — identical policy, divergent samples ⇒ prose precedence unreliable. Verdict PARTIAL PASS; "no further prose… avoiding an instruction arms race" | FACT |
| 08-27 10:24–10:33 | **Campaign 2 — structural archfix** (v1→v2): "Orchestration modes" replaces "Workflow-skill compatibility"; new frontmatter description (sole-authority routing, 247 chars); manage.sh shim sentence changed → installer re-run rewrote all 3 shims (third backup set `…T102730`); scenarios J/K added; README two-mode docs | FACT (diffs; backups; FINAL-REPORT PASS) |
| 08-27 10:31–15:22 | Archfix validation: tests A1/A2 (MAO mode: SDD never loaded, 3+3 parallel implementers, 0 reviewers, $2.90/$2.91), B (native SDD opt-in: 15 agents, full cadence), C (no agent wording: 0 agents). Transcripts quote the model rejecting `executing-plans`→SDD redirect citing the shim routing sentence | FACT |
| 08-27 16:22–16:42 | **Campaign 3 — artifact-boundary hardening** (v2→v3): "Provenance" paragraph added to SKILL.md; Claude adapter bullet extended to cover `REQUIRED SUB-SKILL` directives embedded in plans. Session A generated a real `writing-plans` PLAN.md (`generated-PLAN.md`, 438 lines, directive at line 3) as authentic fixture | FACT |
| 08-27 20:21–21:20 | Campaign 3 validation: test B (authentic plan + MAO prompt: SDD never loaded, 2 parallel implementers), test C (explicit native SDD: 11 agents, MAO never loaded), test D (adversarially strengthened "MUST use SDD" mandate in plan: still not followed; honesty caveat noted). Verdict PASS | FACT |
| 08-27 21:20 → today | **Canonical tree quiescent**: no file modified after 2026-08-27 16:22 (verified by find -newermt). Live integrations unchanged since (all symlinks/shims verify) | FACT |
| 09-06 | Production usage: LCO fifth-audit program ran under MAO adaptive mode (3 parallel Explore investigators → primary plan → primary sequential TDD), documented in `llm_council_orchestrator/audit-output/**/01-BASELINE-AND-MAO-TOPOLOGY.md` across 14 worktrees | FACT (docs + plans in git repo `isakli05/llm_council_orchestrator`) |
| 09-22 | This audit | — |

## 3. Answers to the mandated questions

**A. Is `~/.local/share/ai-agent-orchestration/multi-agent-orchestration/` still the
authoritative runtime source? — YES (FACT).**
All three live symlinks resolve to it (`readlink -f` verified); the managed shims name the
skill; `manage.sh verify` logic matches observed state; LCO production docs (2026-09-06)
describe exactly this installation; nothing newer exists anywhere on disk.

**B. Is `mao-sdd-archfix-20260827` purely evidence, or does it contain source that never
reached canonical? — Purely evidence (FACT), with two promotable artifacts (see §4).**
Every source change it records is present in canonical: SKILL.md v1+diff = v2 = canonical's
pre-campaign-3 state; manage.sh diff applied (current hash = campaign-3's `.before`);
scenarios J/K present in canonical; shim diff applied (current shims match manage.sh's
embedded text). The tree adds no unreconciled source. Repos/transcripts/runs are test
evidence only.

**C. Is `mao-sdd-artifact-boundary-20260827` purely evidence? — Yes (FACT), same method.**
Its SKILL/platform-adapters diffs are additions-only and fully applied (v2+diff = current
v3, hash-verified); its `manage.sh.diff`/`CLAUDE.md.diff` are empty by design; `generated-PLAN.md`
is a fixture, not source.

**D. Did either evidence tree mutate/patch/generate any current canonical file? — YES, and
this is the correct reading of their role (FACT).** They are not just observation: campaign 2
modified SKILL.md, platform-adapters.md, manage.sh (shim string), scenarios.md, README.md and
(via installer re-run) the three global shims; campaign 3 modified SKILL.md and
platform-adapters.md. All modifications are hash-verified as the *direct ancestors* of the
current canonical files. The trees are simultaneously (a) the change records and (b) the
behavioral proof that the changes work.

**E. Later MAO versions elsewhere? — NO (FACT).** No SKILL.md copy anywhere hashes newer
content; all other copies are strict ancestors (v0/v1) or evidence snapshots.

**F. Forks/divergent copies? — NO (FACT).** Every copy of MAO source on disk is v0, v1, v2
snapshot, or v3 canonical. No divergent fork exists. (LCO's `.superpowers/sdd` dirs are
Superpowers artifacts, not MAO forks.)

**G. Which copy does each runtime consume today? — canonical, via (FACT):**
Claude Code → `~/.claude/skills/multi-agent-orchestration` symlink; ZCode →
`~/.zcode/skills/…` symlink; Codex → `~/.agents/skills/…` symlink (per README + Codex docs,
`~/.agents/skills` is Codex CLI's user-skills location; `~/.codex/skills` holds Codex-managed
system skills — both observed). All three resolve to the identical directory (single source,
zero duplication).

**H. Uncommitted work / history that would be lost by treating only canonical as source?**
- No *unapplied* work exists (all diffs applied). (FACT)
- BUT: **canonical has no version control at all** — v0/v1/v2 survive only as evidence-tree
  snapshots. Migrating canonical into a git repository loses nothing and gains history
  capture; the evidence trees must be preserved for the pre-git lineage. (FACT + inference)
- `analyze_run.py` (identical 2,106 B copy in both campaign trees) is test tooling that
  exists ONLY in evidence trees, not canonical — a genuine gap item for the maintained
  project (candidate: promote to `tests/`). (FACT)

## 4. Disposition-relevant items found in evidence trees (input to Phase 4.5-G)

| Item | Location | Classification candidate |
|---|---|---|
| `FINAL-REPORT.md` ×3, `collision-smoke-test-report.md` | campaign roots | ADR/history worth condensing |
| `before-after/*.diff` | campaigns 2–3 | reproduce the v0→v3 lineage; small, publishable |
| `policy-*-SKILL.md`, `*.before` snapshots | campaigns 1b–3 | historical versions; publishable as `historical/` (tiny) |
| `analyze_run.py` | campaigns 2–3 | regression tooling worth promoting |
| `tests/scenarios.md` (A–K) | canonical | already canonical; the executable-regression gap is that they are manual, LLM-behavioral scenarios (see Phase 3) |
| `repos/` (taskcli + notectl clones), `runs/*.json`, `transcripts/**` (jsonl incl. subagents) | all campaigns | raw evidence — local/archive only; contains session content, cost data, model names; large |
| `generated-PLAN.md` | campaign 3 | sanitized reproducible fixture (already redacted: no secrets; contains the SDD directive header — that is its purpose) |
| `.zip` (906 KB collision evidence) | home | archive, local only |

## 5. FACT / INFERENCE / UNRESOLVED summary

- **FACT:** everything in §1–§4 marked FACT, each backed by hash/diff/report/backup-stamp
  evidence cited inline.
- **INFERENCE:** (1) The third shim-backup set (`…T102730`) was produced by the archfix-era
  installer re-run (backup naming scheme + archfix report's "installer re-run rewrote all
  three global shims with timestamped backups" — consistent, not directly observable).
  (2) `~/.agents/skills` is consumed by Codex CLI specifically (README + docs; no other
  runtime claims it). (3) The artifact-boundary `.before` snapshot mtimes postdate the
  canonical write because snapshots were copied without `-p`; content chain is hash-proven
  regardless.
- **UNRESOLVED:** (1) The **install-session transcript** (2026-08-26 ~17:39) is not
  preserved under `~/.claude/projects/-home-isa` (the only Aug-26–28 session there,
  `7fed7c03…`, *begins* with the collision-test prompt at 08-27 ~00:55). The install was
  likely executed in a session whose transcript was cleaned or ran under another cwd/harness
  (possibly Codex-side; its rollout logs are in 100 MB+ sqlite stores not excavated). Install
  actions are nonetheless fully reconstructible from manage.sh + backups + README. (2) Which
  harness ran the 08-26 17:45 smoke test's parent (session dir exists; content not read —
  low value). (3) Whether `cc-zai` (the provider wrapper referenced in campaign READMEs)
  keeps transcripts in a separate location — wrapper script not located in this pass.
