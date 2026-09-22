# Evidence — ZCode platform research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #5 (ZCode stream). Recorded
for traceability; classification and comparative judgments live in the numbered comparison
documents. Controller: main session.

Subagent usage rationale: independent research stream over ~48 primary-source fetches
(zcode.z.ai docs/changelog, zai-org/zcode OSS repo, zai-org/zcode-plugins); context
offloading; no source-of-truth decisions delegated.

---

## 0. Accessibility

Reached: zcode.z.ai (homepage EN/CN, /en/changelog, /cn/changelog, /en/docs and
/en/docs/{skill,plugin,subagents,agents,commands,qa,install,automations});
github.com/zai-org/zcode (Apache-2.0, 6.2k stars; file contents read directly);
github.com/zai-org/zcode-plugins incl. raw docs/PLUGIN_DEVELOPMENT.md.
NOT reached / absent: /docs/en (404 — EN docs at /en/docs); docs.z.ai is the Z.AI API
platform (no ZCode); GitHub Releases for zai-org/zcode empty (no tags at all); grep.app
rate-limited (429).

## 1. VERSION

**Latest stable 3.14.3, Sep 22, 2026 — CONFIRMED** (changelog heading "3.14.3 — Sep 22,
2026"; install page "Latest"; download URLs .../releases/3.14.3/...). OSS repo root
package.json at 3.14.0 (public repo lags shipped app). DOCUMENTED + IMPLEMENTED.

Full public changelog (ends "You've reached the end of the release history."):

| Version | Date | Notable |
|---|---|---|
| 3.14.3 | Sep 22, 2026 | workflow concurrency adjustable without stopping task; faster script submission |
| 3.14.1 | Sep 22, 2026 | bug fixes |
| 3.14.0 | Sep 19, 2026 | **dynamic workflows** ("single script to orchestrate multiple sub-agents"); /workflow command; Office/Coding modes |
| 3.12.3 | Sep 17, 2026 | per-workspace plugins; plugin update reminders; fix "sub-agents appearing in task list after resuming" |
| 3.11.2 | Sep 4, 2026 | PDF/media preview, per-workspace plugins, plugin update notifications |
| 3.10.2 | Aug 31, 2026 | skills shortcut in input menu; one-click install of plugins referenced in prompt templates; "Fixed issues where some plugin skills were not recognized" |
| 3.10.1 | Aug 28, 2026 | mirrors 3.10.2 |

Flags: no 3.13.x, 3.14.2, 3.11.0–3.11.1, 3.12.0–3.12.2 entries (skipped/unknown); 3.7.x–
3.9.x release notes not published anywhere official (only v3.7.1 AGENTS.md-injection datum;
third-party "v3.8.1" reference — CLAIMED).

## 2. SKILLS (DOCUMENTED)

- User dir `~/.zcode/skills/<name>/SKILL.md`; workspace `<ws>/.zcode/skills/<name>/`.
- Frontmatter: "must include `name` and `description`; a skill missing either is ignored".
- **Description hard limit 1024 chars — exceeding DROPS the skill** (diagnostic
  "description exceeds 1024 chars"); body over 100KB truncated when loaded.
- **Per-turn injection: metadata of every enabled skill (name + description excerpt up to
  250 chars)**; shared fixed metadata budget; on overflow "degrades to names only".
  Disabled skills "neither injected nor invocable".
- Import: Settings → Skills → Import scans Claude Code, Codex CLI, OpenClaw, Augment,
  Windsurf. **Symlink mode**: "create a link to the external skill directory. ZCode follows
  later changes in the source". Copy mode: independent copy.
- Invocation: `$skill-name` (renders as tag); skills in `/` panel Skills group; `@` picker
  can reference skills and agents. New/edited skills need Settings → Skills → Refresh.
- Distribution: no standalone skill marketplace — package as plugin, flat
  `skills/<name>/SKILL.md` ("nested/grouping directories aren't picked up").
- IMPLEMENTED (repo skillsService.ts via wiki): user roots are `~/.zcode/skills` **and**
  `~/.agents/skills`; workspace roots discovered walking cwd→git-worktree-root collecting
  `.zcode/skills` and `.agents/skills`; "`.agents/skills` serves as a compatibility
  fallback" used "only when an identically-named skill does not already exist under the
  corresponding `.zcode/skills` root".

## 3. PLUGINS (DOCUMENTED)

- **Manifest priority: `.zcode-plugin/plugin.json` (recommended) → `.claude-plugin/
  plugin.json` (Claude Code compatible).** Minimal manifest needs only `name` matching
  `^[a-z0-9][a-z0-9._-]{0,127}$`. Fields: version (default 0.0.0), description, author,
  homepage/repository, license, keywords, **commands/skills/hooks/mcpServers/agents**,
  dependencies (`name@market`), userConfig. Recognized-but-not-executed keys: channels,
  lspServers, outputStyles, settings (diagnostic emitted).
- `.codex-plugin/plugin.json` third path: NOT in official docs/tutorial; asserted only by
  AI-generated repo wiki (citing a file that doesn't contain it) + third parties →
  **CLAIMED / partially verified**.
- Layout: commands/*.md ($ARGUMENTS, $1/$2), skills/<name>/SKILL.md, agents/*.md,
  hooks/hooks.json, .mcp.json. Hook events (7): SessionStart, UserPromptSubmit,
  PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure, Stop. "Plugin hooks only
  join new sessions after the plugin is enabled". MCP namespaced
  `plugin:<plugin>:<server>`; template vars ${CLAUDE_PLUGIN_ROOT} ("${ZCODE_PLUGIN_ROOT}
  also works"), ${CLAUDE_PLUGIN_DATA}, ${CLAUDE_PROJECT_DIR}.
- Marketplaces: Public (ZCode-curated, categories Developer Tools/Productivity/Utilities/
  Guides/Templates; "served from GitHub"); IMPLEMENTED: official id
  `zcode-plugins-official`, source `https://cdn-zcode.z.ai/zcode/official-plugin/
  marketplace.json` merged with local seed; zai-org/zcode-plugins feeds it. Personal:
  GitHub repo, git URL, local path. **"ZCode preloads the Claude Code marketplace here"**
  (DOCUMENTED, doc-level only). marketplace.json: name, plugins (required), pluginRoot,
  allowCrossMarketplaceDependenciesOn; source forms directory|github|git|file|url|npm;
  manifest and entry "must have the same name and version".
- Install per-workspace (3.11.2/3.12.3); update compares marketplace entry version vs
  plugin.json (bump marketplace.json or no update offered); disable reversible;
  uninstalling built-ins writes suppression marker; local plugins need Sync Plugin to
  reach remote workspaces. Publishing: local marketplace.json → test → push plugins/ +
  marketplace.json to GitHub. Built-ins: document-skills, skill-creator on by default;
  android-emulator, ios-simulator, restore-legacy-sessions off. Security: "enabling a
  plugin grants code-execution trust".

## 4. SUBAGENTS (DOCUMENTED)

- Built-ins: `general-purpose` ("default built-in subagent for broad tasks", all tools) +
  `Explore` ("read-only file-search and codebase-research specialist"; "does not create,
  modify, move, or delete files"). **"Built-in roles cannot be deleted or disabled."**
- Custom subagents: **"Beta — User-level custom subagents are rolling out. The capability
  and its scope may still change."** Stored `~/.zcode/agents/<name>.md`; global/user-level
  only (no workspace-level creation yet). Frontmatter camelCase: name, description,
  model, thoughtLevel, color, tools/disallowedTools, maxTurns, injectAgentsMd, mcpServers.
  Edits require new session. Breaking config rename `mode`→`subagent` (not auto-migrated).
- **Nesting rule, exact line: "a subagent cannot spawn subagents of its own."**
- AGENTS.md injection: "Since v3.7.1, subagents inject the user-level ~/.zcode/AGENTS.md
  and workspace AGENTS.md by default"; opt-out `injectAgentsMd: false`; "The built-in
  Explore does not inject them." Main session merge: user global then workspace.
- Tool allowlists: omitted/`*` inherits everything incl. MCP; custom list "is exhaustive —
  nothing outside it is available"; MCP by full name mcp__<server>__<tool> (wildcards
  silently ignored); subagents only see MCP servers connected at session start;
  backgrounded Explore restricted to read-only tools.

## 5. DYNAMIC WORKFLOWS (3.14.x) — IMPLEMENTED

- 3.14.0 release notes: "Added dynamic workflows that use a single script to orchestrate
  multiple sub-agents collaborating on complex tasks"; entry via plus menu or `/workflow`.
  3.14.3: concurrency limit adjustable mid-run.
- Official source (apps/zcode-cli/packages/dynamic-workflow/README.md): **model-authored
  TypeScript script compiled to a workflow graph** — "the TypeScript facade the main agent
  writes scripts against, and the compiler that recovers rigor from those scripts
  (typecheck, schema synthesis, dependency inference, site identity)". Scripts run as
  "an async function body" ("top-level await and a final return <artifact> are legal;
  import is not"); purity compile-enforced ("process, fetch, require fail typechecking").
  Facade centers on ask/actor/world-read/join sites; ask<T> generates JSON Schema for
  model-legible repair. Runtime: "sandbox harness (child process + vm cell + NDJSON host
  bridge)"; production driver uses "actor sessions, SQLite journal, tool wiring";
  AskScheduler with "ordinals, journal replay + hold rule, repair/nudge, usage
  accounting"; causality/phase/handoff graph analyses → Mermaid; UI timeline/graph;
  persisted templates + run history (useSavedWorkflowStore).
- Gating: none documented (no beta flag/tier/opt-in in changelog, docs, repo README);
  NOTICE.md lists "subagents, workflows and background tasks" as risk category; workflow
  drafts pass through normal permission flow (workflow-draft-path.ts in permission
  service).
- "Automations" (/en/docs/automations) is a different feature: scheduled/idle
  natural-language tasks, "No script format/API exists".

## 6. TRIGGER SEMANTICS

- Skills selected implicitly per turn from injected metadata (name + ≤250-char excerpt);
  bodies load only when invoked; explicit via $skill-name or / panel. Auto-trigger
  failure causes (doc order): (1) degraded metadata (budget overflow → names only),
  (2) vague description, (3) subagent tools allowlist excluding the skill tool,
  (4) parent plugin disabled.
- **No global "disable auto-trigger" flag documented**; only per-skill disable or parent
  plugin disable.
- Commands vs skills guidance: "Use a command when you only need to save a simple prompt.
  If the workflow needs scripts, templates, or example files, consider using Skill
  instead."
- No explicit cross-resource precedence table (skills/plugins/AGENTS.md). Operationally:
  plugin skills disappear with plugin disabled; .agents/skills fallback (see §2);
  AGENTS.md appended user-global-then-workspace to main agent and (since 3.7.1) injected
  into subagents unless injectAgentsMd: false; **CLAUDE.md NOT read at runtime**
  ("only used during onboarding as a one-time migration source").

## 7. RUNTIME COMPATIBILITY

- Claude: `.claude-plugin/plugin.json` accepted (second priority); layout mirrors Claude
  Code's; ${CLAUDE_PLUGIN_ROOT} supported; "ZCode preloads the Claude Code marketplace";
  skills/commands import scans Claude Code; claude-native session import IMPLEMENTED
  (packages/services/src/session/claude-native/); third-party corroboration of
  .claude-plugin support (CLAIMED).
- Codex: skills/commands import scanning documented; .codex-plugin manifest CLAIMED;
  NOTICE.md acknowledges "官方 Coding Plan 模型网关转发" for "两个官方 Anthropic 兼容模型端点"
  (Anthropic-compatible gateway) — DOCUMENTED in official NOTICE.md.
- **Codex-derived internals NOT acknowledged**: THIRD-PARTY-NOTICES.md +
  copied-components.json list shadcn/ui, Vercel ai elements, Fig autocomplete, Material
  Icon Theme, vercel-labs agent-browser skills, VS Code IPC (packages/rpc, "Upstream-
  derived IPC, serialization, buffer, lifecycle and event portions only"), Superpowers
  skill descriptions ("The former bundled plugin implementation has been removed; only its
  retained license remains"), vercel-labs React Best Practices. **No openai/codex and no
  anthropics/claude-code code-copying declared.** ("Codex fork" characterization
  unsupported by official sources.)
- CLI: repo builds zcode CLI/TUI/Web; installer "installs it to ~/.zcode/runtime by
  default, and creates the zcode command in ~/.local/bin"; standalone CLI default --prompt
  without --mode uses yolo permissions (NOTICE.md — cost/side-effect risk category).

## Flags

1. 3.13.x etc. absent from changelogs; 3.7–3.9 notes unpublished.
2. .codex-plugin support CLAIMED (wiki citation incorrect; third-party only).
3. "Claude Code marketplace preloaded" — doc-level, not located in source.
4. CDN-vs-GitHub serving relationship implied, not spelled out.
