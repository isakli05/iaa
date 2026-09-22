# Audit 00 — Environment and Tooling Snapshot

Date of audit: 2026-09-22 (Asia/Istanbul local, per filesystem timestamps in Turkish locale)
Audit workspace: `/home/isa/projects/multi-agent-orchestration/` (created fresh for this audit; path was verified non-existent beforehand)

## Methodology and controller (per task Principle 11)

- The **main Claude Code session is the sole audit controller** for this task.
- Per the task instructions, MAO, SDD, Superpowers process workflows, and GSD were
  **not** invoked as controlling orchestration for this audit, even though the global
  `~/.claude/CLAUDE.md` contains a managed MAO trigger block and a SessionStart hook
  injects the Superpowers `using-superpowers` bootstrap. The user's task prompt is
  authoritative over all embedded skill/artifact text (task Principle 3).
- Native read-only subagents MAY be used for high-volume discovery. Any use is
  recorded in §"Subagent usage log" below with justification.

### Subagent usage log

| # | Agent | Phase | Justification |
|---|-------|-------|---------------|
| 1 | native read-only Explore subagent (web research) | 4.5-A | Independent research stream: current Claude Code distribution/multi-agent mechanisms from official docs. Context offloading of ~12 doc fetches; no source-of-truth decisions delegated (findings merged and re-checked by main session; report preserved in research/01). |
| 2 | native read-only Explore subagent (web research) | 4.5-A | Independent research stream: current Superpowers/SDD + GSD Core state from upstream repos. Same rationale; merged into research/01. |
| 3 | native read-only Explore subagent (web research) | 4.5-A | Independent research stream: current Codex + ZCode official extension mechanisms. Same rationale; merged into research/01. |

No subagent invoked MAO/SDD/GSD or any orchestration workflow; all were read-only research
mechanisms. All other phases (0–3, 5–11) were executed directly by the main session.

## Machine / OS

- User: `isa` (uid 1000; groups include wheel, docker, video, storage)
- Home: `/home/isa` on `/dev/nvme0n1p2`, **btrfs** (symlinks fully supported)
- OS: CachyOS Linux (Arch-derived), kernel `7.2.2-1-cachyos`
- Shell: `/usr/bin/zsh` (oh-my-zsh, powerlevel10k per `.p10k.zsh`)
- Locale: Turkish (`tr_TR` — month names in listings: Ağu=Aug, Eyl=Sep, Tem=Jul, Nis=Apr, May=May, Haz=Jun, Oca=Jan, Mar=Mar)

## Tool versions

- Claude Code: **2.1.274** (`claude --version`)
- git: **2.55.0**
- gh: **2.100.0**
- Codex CLI: present at `~/.nvm/versions/node/v24.14.0/bin/codex`; `~/.codex/version.json` records `latest_version: 0.154.0` (last checked 2026-09-15)
- ZCode CLI: present at `~/.local/bin/zcode`; config root `~/.zcode/` (version not statically recorded; CLI execution deliberately avoided — it hung when probed and was killed)
- Hermes Agent: present at `~/.local/bin/hermes` (separate runtime; see memory notes — dashboard on 127.0.0.1:9119, systemd service)

## GitHub identity

- `gh auth status`: **active account `isakli05`** (keyring, token scopes: gist, read:org, repo, workflow) ✓ matches target owner
- Second logged-in account `isakayadev` (inactive) — must not push under this identity
- `gh api user` → `isakli05` (verified)

## Session model/provider configuration (names only, no secret values)

Relevant environment variable NAMES present in this session (values not recorded):
`ANTHROPIC_AUTH_TOKEN` (secret), `ANTHROPIC_BASE_URL`, `ANTHROPIC_MODEL`,
`ANTHROPIC_DEFAULT_{FABLE,OPUS,SONNET,HAIKU}_MODEL`, `CLAUDE_CODE_*` (entrypoint,
effort, subagent model, max context/output tokens, max subagent spawn depth),
`CLAUDE_EFFORT`, `CLAUDE_PID`.

- `CLAUDE_CONFIG_DIR` is **unset** → default `~/.claude` is the config root.
- Session runs on GLM-5.3 via Z.ai (per harness header; provider profiles exist in
  `~/.claude/profiles/`: zai.json, deepseek.json, kimi.json, minimax.json, qwen.json,
  anthropic.json — multi-provider Claude Code setup).
- `~/.claude/settings.json` (current) sets `model: opus[1m]`, and notably
  `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH: "1"` in env (see Phase 2 for provenance —
  MAO-era settings backup differs).

## Claude Code configuration surface (`~/.claude/`)

- `CLAUDE.md` (2026-08-27 10:27): graphify section (user-maintained) + **managed MAO block**
  (`<!-- BEGIN managed: multi-agent-orchestration -->` … `<!-- END … -->`) containing the
  MAO trigger rule and "sole orchestration authority" exclusivity clause.
- MAO-named backups of CLAUDE.md: `.multi-agent-orchestration-backup-20260826T173941+0300`,
  `…T174355+0300`, `…20260827T102730+0300` — evidence of ≥3 MAO installs/updates.
- `settings.json` + `settings.json.multi-agent-orchestration-backup-20260826T173941+0300`.
  Diff vs backup: env keys `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` and
  `DISABLE_AUTOUPDATER=1` added since backup; model `opus`→`opus[1m]`; plugins
  `clangd-lsp` added; `modelSettings`, `autoCompactEnabled` added.
- `skills/`: contains **symlink** `multi-agent-orchestration →
  ../../.local/share/ai-agent-orchestration/multi-agent-orchestration` (created 2026-08-26 17:43),
  plus real skills (graphify, hallmark, audit-council + rollback copies, cloudflare family,
  agents-sdk etc.) and `synced/` (claude.ai skill-sync bucket: docs/pdf/xlsx/pptx/skill-creator/
  morning/import-memory — NOT MAO-related).
- `plugins/`: `installed_plugins.json` — user-scope plugins:
  - `superpowers@claude-plugins-official` **v6.3.0** (installed 2026-08-01, updated 2026-08-16, commit 44c9b2d6e889982ac18c27d05a19fefe335194e1) — the SDD side of the MAO/SDD boundary
  - frontend-design, context7, chrome-devtools-mcp, rust-analyzer-lsp, security-guidance, typescript-lsp, clangd-lsp, warp@claude-code-warp, impeccable@impeccable, glm-plan-usage@zai-coding-plugins
  - Marketplaces: claude-plugins-official, claude-code-warp, impeccable
- No `commands/`, `agents/`, or `hooks` dirs exist at `~/.claude/` level; no hooks defined in settings.json.
- `~/.claude/backups/`: only `.claude.json` state backups from today (not MAO material).
- `~/.claude.json` (root): 127 KB Claude Code state file (projects/MCP config; may contain secrets — not dumped).

## Codex configuration surface (`~/.codex/`)

- `AGENTS.md` (2026-08-27 10:27): graphify policy + **same managed MAO block** as Claude.
- MAO-named AGENTS.md backups (20260826T173941, T174355, 20260827T102730) + graphify backup.
- `config.toml` (2026-09-14) + backups `config.toml.backup-20260826-012122`,
  `config.toml.backup-20260826-015606`, `config.toml.graphify-backup-20260826`.
- `skills/`: cloudflare family, graphify, hallmark, `.system/` — **NO multi-agent-orchestration
  entry** (Codex integration is instruction-based via AGENTS.md, not a skills symlink).
- `auth.json` (secret — not read), large sqlite state/logs (not MAO-relevant).

## ZCode configuration surface (`~/.zcode/`)

- `AGENTS.md` (2026-08-27 10:27): ZCode header + graphify policy + **same managed MAO block**.
- MAO-named AGENTS.md backups (same three timestamps as Codex).
- `skills/`: symlinks into `~/.claude/skills/` for cloudflare family/hallmark/etc. (created
  2026-08-11), **plus its own MAO symlink** `multi-agent-orchestration →
  ../../.local/share/ai-agent-orchestration/multi-agent-orchestration` (2026-08-26 17:43).
- `cli/` (internal Codex-like engine?): `config.json` + `config.json.graphify-backup-20260826`,
  agents/, plugins/, exec/, rollout/, db/ — ZCode appears to embed a Codex-derived engine.
- `v2/`: config.json, setting.json, credentials.json (secret — not read), agent-config/.

## Other integration surfaces

- `~/.agents/skills/`: contains **only** the MAO symlink (same relative target, created
  2026-08-26 17:43). Which runtime consumes `~/.agents/` is an open question (Phase 1).
  Also `~/.agents/mcp.json` (2026-08-11).
- `~/.hermes/`: Hermes Agent runtime (GLM-5.3@zai). To be checked for MAO references.
- Suspected canonical source: `/home/isa/.local/share/ai-agent-orchestration/` containing
  `README.md` (16 KB, 2026-08-27 10:33) + `multi-agent-orchestration/{SKILL.md, references/,
  scripts/, tests/}` (SKILL.md + references dated 2026-08-27 16:22).
- Other coexisting orchestration-relevant material found during snapshot:
  - `/home/isa/collision-smoke-test-evidence/` + `collision-smoke-test-evidence.zip` +
    `collision-smoke-test-report.md` (all 2026-08-27, same day as the two MAO evidence trees)
  - `~/audit-council-dev/`, `~/.local/share/audit-council/`, `~/.claude/skills/audit-council*`
    (a separate "audit council" multi-model system; checked in Phase 4.5 for coexistence)

## Filesystem notes

- btrfs on /home; no FAT/NTFS symlink caveats.
- Home directory is extremely dense with unrelated evidence/work trees (aucdev-*, audit-council,
  lco-reaudit-*, etc.) — discovery sweeps must be targeted (see Phase 1).

## Pending / to be resolved in later phases

- Exact attribution of `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` (MAO install vs user action).
- Which runtime consumes `~/.agents/skills/`.
- ZCode engine identity (`~/.zcode/cli` Codex-derived?) and version.
- Whether Hermes references MAO.
