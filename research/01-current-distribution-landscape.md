# Research 01 — Current Distribution Landscape (as of 2026-09-22)

Synthesized from three parallel read-only web-research streams (official docs preferred;
UNVERIFIED marks preserved). Methodology note: three native Explore subagents, one per
ecosystem; merged and re-checked by the main audit session. Full source URLs inline.

## 1. Claude Code (v2.1.x era docs, code.claude.com/docs)

**Skills** (code.claude.com/docs/en/skills; cross-agent spec agentskills.io/specification):
- Locations/precedence: enterprise > personal `~/.claude/skills` > project `.claude/skills`
  > nested (lazy) > `--add-dir` > plugin `<plugin>/skills` > claude.ai synced. Same-name
  resolution is official: personal beats project; **plugin skills are namespaced
  (`/plugin-name:skill-name`) and BOTH load** — no override either way; skill beats a
  same-named command file.
- Frontmatter: `name`, `description` recommended; also `when_to_use`, `argument-hint`,
  `disable-model-invocation`, `allowed-tools`, `model`, `hooks`, … Listing budget:
  description+when_to_use truncated at **1,536 chars** (Claude Code); agentskills spec:
  name 1–64 chars, description 1–1,024 chars.
- Suppression without editing third parties: `disable-model-invocation: true` (own skills),
  `skillOverrides` in settings (hide others' model invocation — third-party reports say it
  does not apply to plugin skills: UNVERIFIED).
- **Skills-dir plugins:** any folder under a skills dir containing `.claude-plugin/plugin.json`
  loads as `<name>@skills-dir` — a low-friction hybrid install form.

**Plugins** (…/plugins, …/plugins-reference, …/plugin-marketplaces):
- `.claude-plugin/plugin.json` (optional; `name` required, kebab-case = namespace; `version`
  semver pins updates). Bundles: skills/, commands/, agents/, hooks/hooks.json, .mcp.json,
  monitors/, workflows/, settings.json (restricted keys). Root CLAUDE.md in a plugin is NOT
  loaded.
- Install `/plugin install name@marketplace` (user/project/local scope); marketplaces from
  GitHub repos; cache `~/.claude/plugins/cache`; `/plugin uninstall`; `claude plugin
  validate [--strict]`; community marketplace pinned to SHAs + safety screening.
- Plugin agents: project/user `.claude/agents` definitions override same-named plugin agents;
  plugin agents can't use hooks/mcpServers/permissionMode.

**Subagents** (…/sub-agents): `.claude/agents/*.md`, `name`+`description` required; nesting
depth default **3**, 20 concurrent; non-fork subagents inherit all CLAUDE.md levels + git
snapshot + preloaded skills; built-in Explore/Plan skip CLAUDE.md; `omitClaudeMd` option.

**Agent Teams** (…/agent-teams): **experimental, flag-gated**
(`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), interactive-only; teammates = separate full
instances; config `~/.claude/teams/{team}/` (runtime state, no project-level equivalent);
no nested teams; lead fixed. Not present/enabled on this machine.

**Hooks** (…/hooks): SessionStart matchers `startup|resume|clear|compact|fork`; stdout of a
command hook is injected as context — the bootstrap channel Superpowers uses.

**Skill-vs-skill precedence (official position):** for same names, deterministic table; for
overlapping *claims*, "Claude matches task against descriptions… may load the wrong skill";
prose is "a request, not a guarantee — a hook is enforcement." **"Sole orchestration
authority" appears in no official doc** (it is İAA's own phrasing). This is the doctrinal
anchor for İAA's residual-risk documentation.

## 2. Superpowers (github.com/obra/superpowers; claude-plugins-official)

- Current **v6.4.1 (Sep 19, 2026)**; installed here: 6.3.0 (Aug 12). Cadence ~2–6 weeks.
  15 skills at master (installed 6.3.0 has 14; upstream added `diagnosing-superpowers`).
- SDD contract unchanged in shape: fresh implementer per task (batch exception for tiny
  same-shape edits), never-skip task review, scoped re-review (≤5 rounds), one final
  whole-branch review on the most capable model, **never parallel implementers**, ledger
  workspace `<repo>/.superpowers/sdd/<plan>/`, continuous execution with 4 stop classes.
- `using-superpowers` bootstrap: SessionStart hook (startup|clear|compact, sync) injecting
  the full skill text ("invoke skills before ANY response", "1% chance → MUST invoke"), with
  its own concession: user instructions (CLAUDE.md/AGENTS.md) take precedence over skills.
- `writing-plans` still embeds `> **For agentic workers:** REQUIRED SUB-SKILL: …` into every
  generated plan; `executing-plans` is the inline alternative (one final fresh-context
  review; no per-task seats).
- Distribution: Claude official marketplace + author marketplace + **~15 other harnesses**
  (Codex official plugin store, Cursor, Gemini CLI, Kimi, OpenCode, pi, Qwen, Devin, Grok,
  Copilot CLI, Hermes, Muse, Antigravity…). **No per-skill disable documented** (plugin-level
  enable/disable only; UNVERIFIED whether skillOverrides reaches plugin skills).

## 3. GSD → GSD Core / Open GSD (github.com/open-gsd/gsd-core)

- Original gsd-build/get-shit-done **archived 2026-06-26**; community continuation
  `open-gsd/gsd-core` ("Git. Ship. Done."), npm `@opengsd/gsd-core`, latest **1.14.0**
  (changelog newest dated entry 1.13.0 – 2026-09-06; ~weekly-to-fortnightly cadence).
- Distribution: npm installer (transforms Claude-Code-native frontmatter per runtime) +
  native Claude plugin (`claude plugin install gsd-core`, `/gsd-core:*` namespaced, additive).
  Runtimes include Claude Code, Codex, Cursor, Windsurf, Cline, ZCode, pi, Kilo…
- Model: milestone phase loop (Discuss→Plan→Execute→Verify→Ship), `.planning/` persistent
  state, 60+ `/gsd-*` commands, ~30 fixed agent roles (researchers ≤4 parallel, sequential
  synthesizers, planners, checkers ≤3 iterations, parallel wave executors, sequential
  verifiers, auditors), fresh ~200k contexts per agent.
- **Hook-enforced guards** (Claude install): SessionStart update/state hooks; PreToolUse
  prompt/read/workflow/worktree/agent-isolation/secret guards; PostToolUse context-monitor,
  read-injection-scanner, phase-boundary; Stop/PreCompact/SubagentStop/FileChanged. This is
  mechanism-grade workflow enforcement — the strongest enforcement posture among surveyed
  systems (contrast: İAA prose-only, Superpowers bootstrap-only).
- No explicit "only workflow" claim found (UNVERIFIED); `/gsd-quick`, `/gsd-fast` are
  documented lightweight escapes.

## 4. OpenAI Codex CLI (developers.openai.com/codex → learn.chatgpt.com/docs)

- Current stable **0.155.1** (rust-v0.155.1, 2026-09-18); installed here 0.154.0-era.
- **Skills:** USER dir is **`~/.agents/skills`** (official; early-2025 docs said
  `~/.codex/skills` — migrated; `~/.codex/skills` here holds Codex-managed system skills).
  Repo skills at `.agents/skills`. SKILL.md frontmatter `name`+`description` required;
  `agents/openai.yaml` with `policy.allow_implicit_invocation` (default true — **official
  per-skill implicit-invocation disable exists**). Listing budget ~2% context or 8,000 chars.
  Invocation `$skill-name` or implicit. Per-skill disable via `[[skills.config]]` in
  config.toml. Symlinked skill dirs followed.
- **AGENTS.md:** global `~/.codex/AGENTS.md`; project chain root→cwd concatenated, 32 KiB
  default cap; subagent AGENTS.md inheritance **UNVERIFIED officially** (only sandbox and
  approval-mode inheritance documented).
- **Native multi-agent:** `[agents]` config (enabled, max_concurrent_threads_per_session,
  default model/effort, interrupt_message, custom roles via `agents.<name>.*` → TOML files
  in `~/.codex/agents/`). V1 tools officially documented; **MultiAgentV2 surface
  (spawn_agent/followup_task/interrupt_agent, fork_turns) documented only via repo issues —
  UNVERIFIED officially** (but locally verified live by ADR-0000's audit). No documented
  depth limit; leaked Sep-2026 prompt suggests child-spawns-child (UNVERIFIED).
- **Plugins: official universal plugin system now exists** (ChatGPT+Codex shared directory;
  `/plugins`; bundles skills/MCP/hooks; submission/review flow; enterprise GitHub
  marketplace sync; assets at github.com/openai/plugins).

## 5. ZCode (zcode.z.ai/docs)

- Current **3.14.3 (2026-09-22, Electron desktop)**; installed here 3.7.7 (notably old).
- **Skills:** user `~/.zcode/skills/<name>/SKILL.md`, workspace `.zcode/skills/`; name+
  description required; **description hard limit 1024 chars (exceeding drops the skill)**;
  per-turn injection = description excerpt **up to 250 chars** (shared budget may degrade to
  names-only) — İAA's 247–249-char description is sized exactly to this. Import supports
  **Symlink mode** (official) or Copy; `$skill-name` invocation; Settings→Skills→Refresh.
- **AGENTS.md:** `~/.zcode/AGENTS.md` global rules (FAQ table); main-agent merge precedence
  UNVERIFIED. Subagents: since **v3.7.1** user+workspace AGENTS.md injected by default
  (opt-out `injectAgentsMd: false`); built-in Explore never injects — both facts match
  İAA's adapter text exactly.
- **Subagents:** built-in general-purpose + Explore (undeletable); custom beta via
  `~/.zcode/agents/*.md`; **nesting explicitly forbidden** ("a subagent cannot spawn
  sub-agents") — platform guarantee, as İAA documents. v3.14.0 added script-orchestrated
  "dynamic workflows".
- **Plugins: official store now exists** — Public (ZCode-curated, GitHub-served) +
  Personal marketplaces; manifest `.zcode-plugin/plugin.json` **or `.claude-plugin/plugin.json`
  (Claude-Code-compatible)**; components commands/skills/hooks/mcpServers/agents; the
  "Claude Code marketplace" is preloaded as a personal marketplace source. **Skills
  distribute via plugins only** (no standalone skill marketplace).

## 6. Implications for İAA (inputs to F/I docs, not decisions)

1. İAA's three integrations match each runtime's *current* documented mechanism (Codex
   `~/.agents/skills`, ZCode symlink import + AGENTS.md, Claude skills symlink + CLAUDE.md) —
   no integration is riding deprecated paths.
2. All three ecosystems now have plugin/marketplace mechanisms that could carry İAA; ZCode
   even accepts Claude plugin manifests, and Claude supports skills-dir plugins — a shared
   packaging core is feasible (details: docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md).
3. Official precedence doctrine confirms İAA's boundary is behavioral, not mechanistic;
   mechanism-grade options exist on all sides (hooks in Claude/GSD style,
   `allow_implicit_invocation: false` in Codex, description budgets in ZCode).
4. Upstream drift since install: Superpowers 6.4.1 (new skill; SDD contract stable),
   Codex 0.155.1 (plugins now official), ZCode 3.14.3 (subagent AGENTS.md injection since
   3.7.1 — already accounted for; dynamic workflows new). None invalidates the frozen
   baseline; all belong in the comparison phase.
