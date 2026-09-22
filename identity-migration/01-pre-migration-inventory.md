# 01 — Pre-Migration Inventory (2026-09-23, read-only snapshot)

Taken on branch `identity/iaa-rename` at base commit `122dcf1` (Gate 1) before any
mutation. Every occurrence class below was located by exact-token search
(`multi-agent-orchestration`, `Multi-Agent Orchestration`, `Multi-agent orchestration`,
`Multi Agent Orchestration`, `ai-agent-orchestration`, word-boundary `MAO`/`Mao`/`mao`,
`mao-`, `mao_`, `mao-dev`) across: the maintained repo, the live canonical tree,
`~/.claude`, `~/.agents`, `~/.codex`, `~/.zcode`, `~/.config`, git remotes, and GitHub
repository metadata.

## A. Starting-state facts (verified)

- Maintained repo: `/home/isa/projects/multi-agent-orchestration`, branch
  `release-hardening/gate-1` @ `122dcf1`, clean, no tags; branches `main` (787f033),
  `release-hardening/gate-1` (122dcf1).
- Remote: `https://github.com/isakli05/multi-agent-orchestration.git` (https).
- GitHub: `isakli05/multi-agent-orchestration`, **PRIVATE**, default branch `main`,
  description "Multi-Agent Orchestration (MAO): runtime-agnostic adaptive delegation
  policy for Claude Code, Codex CLI, and ZCode — frozen baseline + forensic audit",
  no topics. `isakli05/iaa` does **not** exist. Authenticated account: `isakli05` (active).
- Live canonical tree: `~/.local/share/ai-agent-orchestration/` =
  `README.md` + `multi-agent-orchestration/` (SKILL.md `ade65cf7…`,
  references/delegation-contract.md, references/platform-adapters.md,
  scripts/manage.sh, tests/scenarios.md — 6 files). Byte-identical to repo
  `multi-agent-orchestration/` + `CANONICAL-README.md` (verified by `diff -r`).
  Dev-plugin skill copy (`release-hardening/evals/mao-dev-plugin/skills/…`) also
  hash-identical (`ade65cf7…`).
- Pre-existing drift (NOT introduced by this migration): `web-project-sources/sources/SKILL.md`
  is the pre-Gate-1 snapshot `fee98091…`, not `ade65cf7…`. Recorded; identity-only edits
  will be applied to it without content-syncing it (out of identity scope).

## B. Active runtime integration (project-owned ACTIVE identity — must migrate)

| Surface | Current state |
|---|---|
| `~/.claude/skills/multi-agent-orchestration` | symlink → `../../.local/share/ai-agent-orchestration/multi-agent-orchestration` |
| `~/.agents/skills/multi-agent-orchestration` | symlink → same relative target |
| `~/.zcode/skills/multi-agent-orchestration` | symlink → same relative target |
| `~/.claude/CLAUDE.md` | managed block, markers `<!-- BEGIN/END managed: multi-agent-orchestration -->` (exactly 1 pair) |
| `~/.codex/AGENTS.md` | same managed block (exactly 1 pair) |
| `~/.zcode/AGENTS.md` | same managed block (exactly 1 pair) |
| `~/.config/ai-agent-orchestration/claude-depth.state` | project-owned state dir (content `managed-absent`), mode 0644 |
| `~/.claude/settings.json` `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` | managed depth cap — **identity-neutral, no change** |
| Skill identity | SKILL.md frontmatter `name: multi-agent-orchestration`; H1 `# Multi-Agent Orchestration`; `MAO mode` terminology in SKILL.md + platform-adapters.md |
| Installer | `manage.sh`: markers `managed: multi-agent-orchestration`, link names `skills/multi-agent-orchestration`, state dir `~/.config/ai-agent-orchestration`, future backups `.multi-agent-orchestration-backup-<stamp>` |
| Dev plugin | repo `release-hardening/evals/mao-dev-plugin/` (`plugin.json` name `mao-dev`), NOT registered in `~/.claude/plugins/installed_plugins.json` (path-loaded by `claude plugin eval` only) |

No occurrences in: `~/.claude/settings.json`, `installed_plugins.json`,
`known_marketplaces.json`, shell rc files, `~/.zcode/v2|workspace`, `~/.agents/mcp.json`,
`~/.codex/config.toml` (except stale `[projects."/tmp/multi-agent-orchestration-test-*.kHHQnF"]`
entries — see D), `~/.claude/skills/synced|plugins/synced`.

## C. Maintained repository content (133 tracked files)

Classification per file tree (drives the rename map):

| Tree / file | Class | Action |
|---|---|---|
| `README.md`, `CANONICAL-README.md` (root) | current docs | rename identity |
| `docs/` (16 files incl. `MAO-VS-SDD-BOUNDARY.md`, adr/0000–0003, HISTORY.md) | current docs (+ history narration needing "formerly" framing) | rename identity; 1 file rename |
| `comparison/` (16 files incl. evidence/stream-*.md) | current research/analysis (§12 "comparison conclusions") | rename identity (quotes of third-party product names untouched) |
| `research/` (3) | current research | rename identity |
| `design/COMPATIBILITY-DIAGNOSTIC-PROPOSAL.md` | current design proposal ("mao doctor") | rename identity |
| `release-hardening/04-plugin-eval-design.md`, `05-core-semantics-diff.md`, `FINAL-GATE-1-REPORT.md` | current-state / forward-looking Gate-1 docs (§12) | rename identity |
| `release-hardening/01-…6.4.1-upgrade-check.md`, `02-…fork-turns-verification.md`, `03-…adapter-refresh.md` | dated verification records authored when the product was named MAO | **historical — unchanged** |
| `release-hardening/evals/mao-dev-plugin/**` | current dev/eval scaffold (§13) | dir/file renames + identity |
| `release-hardening/evals/*/evals/results/**` (gitignored) | generated run artifacts (2026-09-22 pilot runs) | historical — moved with parent dir, content unchanged |
| `multi-agent-orchestration/` (5 files) | canonical skill | dir rename + identity |
| `tests/fixtures/generated-PLAN.md` | authentic adversarial artifact (ADR-0003); contains no old-identity tokens | unchanged |
| `tests/tools/analyze_run.py` | tooling; identity-agnostic (0 hits) | unchanged |
| `web-project-sources/` (18 files) | future-upload knowledge pack | rename identity; 2 file renames |
| `audit/` (7 files) | committed frozen-state audit artifacts (§4 committed audit artifacts) | **historical — unchanged** |
| `historical-notes/v0-v3-lineage/` (8 files) | raw v0/v1 snapshots + campaign diffs | **historical — unchanged** |
| `.gitignore` | no identity tokens | unchanged |

## D. Historical / machine-local (retained as-is)

- `~/mao-sdd-archfix-20260827/` — 2026-08-27 campaign evidence tree (referenced by
  CANONICAL-README.md:94).
- `~/mao-sp641-upgrade-check-20260922/` — Gate-1 behavioral evidence tree (repos, runs,
  transcripts, Superpowers 6.3.0/6.4.1 snapshots).
- 10 old-named config backups: `~/.claude/CLAUDE.md.multi-agent-orchestration-backup-*` (3),
  `~/.claude/settings.json.multi-agent-orchestration-backup-*` (1),
  `~/.codex/AGENTS.md.multi-agent-orchestration-backup-*` (3),
  `~/.zcode/AGENTS.md.multi-agent-orchestration-backup-*` (3). Historical backups —
  filenames retained (they document what was backed up, when).
- `~/.claude/projects/**` — 661 session-transcript files matching the old slug;
  conversation history, not product identity (never rewritten).
- `~/.codex/config.toml` `[projects."/tmp/multi-agent-orchestration-test-*.kHHQnF"]` —
  stale Codex-internal trust entries for deleted /tmp test repos from the 2026-08
  campaigns. Legacy residue; not rewritten (would edit Codex-owned config beyond
  identity scope).
- `audit/`, `historical-notes/`, `release-hardening/01–03`, eval `results/` (per C).

## E. Unrelated third-party text (no action)

`~/.config` hits are browser-extension bundles / dolphin session caches containing the
substring by chance; `~/.claude/skills/` third-party skills; MaPos*, llm_council_orchestrator,
lco-reaudit-wt-* project dirs; Superpowers/GSD/BMAD etc. names inside comparison docs
(other products). Generic lowercase "multi-agent" prose is not an identity token.

## F. Scale of in-repo rename (current files)

~120 current files carry identity tokens; frozen trees (audit/, historical-notes/,
release-hardening/01–03, fixtures, results/) are excluded by design. Largest
concentrations: comparison/ (~350 word-MAO hits), release-hardening/evals/mao-dev-plugin/,
CANONICAL-README.md (28 slug + 17 live-path + 6 MAO), docs/, web-project-sources/.
