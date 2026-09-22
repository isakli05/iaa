# Evidence — OpenAI Codex platform research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #4 (Codex stream). Recorded
for traceability; classification and comparative judgments live in the numbered
comparison documents. Controller: main session.

Subagent usage rationale: independent research stream over ~57 primary-source fetches
(openai/codex GitHub releases + API, npm registry, learn.chatgpt.com docs,
developers.openai.com API guides); context offloading; no source-of-truth decisions
delegated.

---

Docs now at learn.chatgpt.com (developers.openai.com/codex/* 308-redirects; append .md
for raw markdown).

## 1. VERSION

- Latest stable **0.155.1** (rust-v0.155.1, published 2026-09-18T20:03:04Z, GitHub
  latest; npm latest 0.155.1). Alpha: 0.157.0-alpha.9 (Sep 21–22); 0.156 stalled at
  alpha.17. Changelog: 0.155.1 Sep 18; 0.155.0 Sep 17; 0.154.0 Sep 09. Local 0.154.0 =
  two stable releases behind. IMPLEMENTED.

## 2. SKILLS (DOCUMENTED)

- Dirs: repo chain `.agents/skills` cwd→root; **user `$HOME/.agents/skills`**; admin
  `/etc/codex/skills`; SYSTEM bundled. Collisions not merged — "both can appear in skill
  selectors".
- SKILL.md: name + description required.
- **agents/openai.yaml**: ChatGPT UI metadata, invocation policy, MCP dependencies.
  **`allow_implicit_invocation` default true**; false = "Codex won't implicitly invoke the
  skill based on user prompt; explicit `$skill` invocation still works."
- Per-skill disable: `[[skills.config]]` in ~/.codex/config.toml (path + enabled=false),
  restart required.
- Listing budget: "at most 2% of the model's context window, or 8,000 characters when
  unknown"; overflow → shorten descriptions first, then omit with warning; only initial
  list; `skills.max_context_tokens` capped at 10000.
- Invocation: `/skills` or `$` in CLI/IDE; `@` in ChatGPT. **"Codex supports symlinked
  skill folders and follows the symlink target."**
- `features.skill_mcp_dependency_install` (stable, default on).

## 3. PLUGINS (DOCUMENTED + IMPLEMENTED)

- "ChatGPT and Codex share one universal plugin directory" / "same public plugin
  catalog". CLI 0.146.0 added Agent Plugins manifests + workspace publishing + other
  marketplaces; 0.147.0 search across catalogs.
- `/plugins` browser (grouped by marketplace; install/uninstall; Space toggles; new
  session advised after install; uninstall removes bundle from that environment).
- Manifest: root **plugin.json** ($schema, name, version, description; example maps
  skills/ and apps); "A minimal portable Agent Plugins package contains a root manifest
  and at least one skill"; `$plugin-creator` generates ".codex-plugin/plugin.json
  compatibility manifest". openai/plugins repo: every example carries
  .codex-plugin/plugin.json + optional skills/, .app.json, .mcp.json, agents/,
  commands/, hooks.json, assets/.
- Components: "skills, an MCP server, or both" + "lifecycle hooks for the Codex runtime"
  (commands/agents in repo layout, not in build-plugins doc).
- Submission portal (platform.openai.com): automated scanning for policy/security, human
  review (identity, policies, "run the submitted test cases"), domain verification,
  correct tool annotations, **"Five positive test cases and three negative test cases"**;
  publish timing developer-chosen; post-publication re-fetch + re-review on listing
  edits.
- Enterprise: Admin > Plugins > Import marketplace; repo root `.agents/plugins/
  marketplace.json` (**Claude formats .claude-plugin/marketplace.json / plugin.json also
  accepted**); daily auto-sync + manual; first import ≤1h; repo-level policy values
  ignored (workspace admins set Available/Installed per role).
- Config: marketplaces.<name>.{source_type,source,ref,sparse_paths};
  plugins.<plugin>.enabled (plugin-name@marketplace-name); mcp_servers per-server
  enable/tool gating; features.remote_plugin stable default on; admin pins via
  requirements.toml.
- Update (0.154.0): "Existing sessions pick up newly installed plugin tools and refresh
  skills and hooks after external plugin upgrades or rollbacks."

## 4. NATIVE MULTI-AGENT

Officially documented (CLI docs + config reference — DOCUMENTED):
- [agents]: enabled (default true); max_concurrent_threads_per_session (max_threads =
  legacy alias); default_subagent_model; default_subagent_reasoning_effort;
  interrupt_message (default true); custom roles agents.<name>.description +
  .config_file.
- `features.multi_agent` "Enable multi-agent collaboration tools (`spawn_agent`,
  `send_input`, `resume_agent`, `wait_agent`, and `close_agent`)" — stable, default on.
  (NOTE: differs from the locally audited 0.149.1 surface spawn_agent/send_message/
  followup_task/wait_agent/interrupt_agent/list_agents.)
- Built-in roles: default ("general-purpose fallback"), worker ("execution-focused"),
  explorer ("read-heavy exploration"). reviewer = custom-agent example only.
- Custom agents: TOML under ~/.codex/agents/ (personal) or .codex/agents/ (project);
  name+description+developer_instructions required; optional model,
  model_reasoning_effort, sandbox_mode, mcp_servers, skills.config; "your custom agent
  takes precedence" on collision.
- Steering: /agent to switch threads; ask to steer/stop/close; "Codex reapplies the
  parent turn's live runtime overrides when it spawns a child"; "Subagents inherit your
  current sandbox policy".

ISSUE-ONLY (not in CLI docs):
- "MultiAgentV2" named in ~90 open issues (usage hints limit #47309; stale canonical task
  names #45210; "silently bypasses agents.max_threads" #33447; #31864, #28058 143
  reactions). Changelog 0.155.0 PR #43540 "Preserve the multi-agent version when forking
  at a turn cutoff" = closest official acknowledgment of versioned multi-agent.
- fork_turns CLI values: only "none"/"all" issue-observed; **no "suffix" value found
  anywhere**; "partial fork" referenced (#32031); omitted = full history default (which
  in some versions rejected agent_type/model overrides — #20077/#32031/#40016; fixed by
  PR #43631 per #43888).
- Depth: CLI docs silent; agents.max_depth undocumented in docs; "Ignored by V2"
  (#35463); open enforcement bugs: #46704 "max_depth not enforced for nested spawn_agent
  (0.155.1)" (2026-09-19), #32027 "max_depth = 1 permits child-to-grandchild spawning in
  0.144.1"; runaway #38989 (74 subagents, depth 3, ~5.39B tokens).

Responses API Multi-agent (hosted, beta — DOCUMENTED):
developers.openai.com/api/docs/guides/responses-multi-agent: six actions (spawn_agent,
send_message, followup_task, wait_agent, interrupt_agent, list_agents); **"Child agents
can also spawn their own sub-agents"**; **"no fixed limit on the total number of
subagents or tree depth"**; max_concurrent_subagents default 3; beta opt-in
responses_multi_agent=v1 with GPT-5.6 models; fork_turns ("all" in examples). Agents API
variant: max_concurrent_subagents default 6.

## 5. AGENTS.MD (DOCUMENTED)

- Global: ~/.codex (CODEX_HOME overridable); AGENTS.override.md first, else AGENTS.md;
  "only the first non-empty file at this level".
- Project chain: root→cwd per directory (AGENTS.override.md → AGENTS.md → fallback
  names), "at most one file per directory", concatenated root-down, "Files closer to
  your current directory override earlier guidance"; built once per run/TUI session.
- Cap: "32 KiB by default" (project_doc_max_bytes); stops adding at limit.
- Subagent inheritance: **officially undocumented**; ISSUE-ONLY (#26806 subagents
  "inherit personal custom instructions / global AGENTS.md guidance by default", open
  since 2026-06-06; #45790 subagents reading AGENTS.md at startup).

## 6. OFFICIAL ORCHESTRATION GUIDANCE (DOCUMENTED)

- Subagents doc: "As a starting point, use parallel agents for read-heavy tasks such as
  exploration, tests, triage, and summarization." "Be more careful with parallel
  write-heavy workflows, because agents editing code at once can create conflicts."
  Cost warning (×2): subagent workflows "consume more tokens than comparable
  single-agent runs." Triggering: at most intelligence levels you must ask explicitly;
  **"With Ultra, ChatGPT can proactively delegate work when parallel agents would
  materially improve speed or quality."**
- Responses-API guide example dev-messages: "Do not spawn subagents unless the user
  explicitly asks for subagents, delegation, or parallel agent work." / "Proactive
  Multi-agent delegation is active. Use subagents when parallel work would materially
  improve speed or quality." Use multi-agent for independent bounded workstreams; single
  agent for dependent chains/small tasks/shared mutable state; "adding subagents can
  increase token usage." Injected root prompt: "You can spawn sub-agents to handle
  subtasks, and those sub-agents can spawn their own sub-agents"; all agents "equally
  intelligent and capable… same set of tools."
- Agents-API guide: "Use subagents for independent tasks… Keep short tasks and dependent
  steps in the main agent." "Agents that edit the same files must coordinate their
  changes." Example: one subagent for customer-visible changes, another for migration
  guides/examples.
- Blog "Run long horizon tasks with Codex" (2026-02-23): "The most important technique
  was durable project memory" (spec/plan/runbook/status files), small milestones,
  continuous verification, git worktrees to isolate runs; ~13M tokens / ~25h observed.

## Flags

fork_turns "suffix" nonexistent (docs/issues/SDK); MultiAgentV2 + max_depth + CLI
followup/interrupt/list tools = ISSUE-ONLY; subagent AGENTS.md inheritance ISSUE-ONLY;
plugin on-disk path undocumented; monetization page unverified; "v2-only project
configuration" community claim = CLAIMED.
