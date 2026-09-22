# Evidence — Claude Code native platform research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #3 (Claude Code native
stream). Recorded verbatim below for traceability; classification and comparative
judgments live in the numbered comparison documents. Controller: main session.

Subagent usage rationale: independent research stream over ~28 official-doc fetches;
context offloading; no source-of-truth decisions delegated. (A harness control flagged the
raw output as containing instruction-shaped patterns — those are quoted doc lines about
settings.json/bypass-permissions, i.e. data about Claude Code, not instructions; treated
as evidence only.)

---

## 1. VERSION

**Latest release: 2.1.280, dated September 22, 2026** (changelog,
https://code.claude.com/docs/en/changelog). DOCUMENTED. Local machine: 2.1.274 (Sep 17).

Recent: 2.1.280 Sep 22 · 2.1.278 Sep 19 (no 2.1.279 listed) · 2.1.277/2.1.276 Sep 18 ·
2.1.275 Sep 17 · 2.1.274 Sep 17.

Shipped since 2.1.274, relevant here (IMPLEMENTED, changelog):
- 2.1.280: fix for "skills in `~/.claude/skills/` being moved to `~/.claude/skills/.trash/`
  when a `manifest.json` in that folder listed their names"; `/skills` menu fixes; off-state
  skills show dim ◯; subagent fixes (fork prompt caching, lost hand-back reports,
  background-subagent LSP); `/workflows` rendering; stale commits in installed_plugins.json;
  hook output sizes in `hook_execution_complete` OTel; UserPromptSubmit timeout notice.
- 2.1.277: project skills load in `--worktree` sessions when `.claude/skills` untracked;
  `claude plugin install` reinstall-break fix; resumed subagents/teammates MCP re-render
  fix; subagent results arrive under a header marking them as subagent output.
- 2.1.275: claude.ai skills/plugins sync to terminal sessions (opt out
  `syncClaudeAiSkills: false`); `/plugin install <plugin> --marketplace <source>`; npm
  plugins use `npm pack --ignore-scripts` + integrity verification.
- 2.1.271: auto-mode subagents "report back to their caller through a dedicated hand-back
  call that the safety classifier reviews"; `CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS`
  (1–256); workflows pause on usage limits.
- 2.1.269: **`claude plugin eval` added** ("run a plugin's eval suite against Claude Code
  and get scored, reproducible results (JSON + HTML report)").

## 2. SKILLS (https://code.claude.com/docs/en/skills — DOCUMENTED)

- Precedence: enterprise > personal `~/.claude/skills/` > project `.claude/skills/` ("With
  `deploy` in both … `/deploy` runs the personal one."); nested (lazy), --add-dir, plugin
  skills namespaced `/plugin-name:skill-name`, claude.ai-synced (stored under reserved
  `~/.claude/skills/synced/`).
- Same-name table (verbatim): local vs bundled → "Your skill replaces the bundled command,
  but not its aliases"; skill vs `.claude/commands/` file → "The skill."; project-root vs
  nested → "Both load"; **plugin skill vs local skill → "Both load, because plugin skills
  are namespaced"**; local vs claude.ai-synced → "The other skill or command. The synced
  skill still runs as `/anthropic-skills:<name>`."
- Frontmatter (all optional; only `description` recommended): name, description,
  when_to_use, argument-hint, arguments, disable-model-invocation, user-invocable,
  allowed-tools, disallowed-tools, model, effort, context: fork, agent, background, hooks,
  paths, shell, metadata, license, compatibility. Unrecognized fields silently ignored.
- Budget: "the combined `description` and `when_to_use` text is truncated at 1,536
  characters in the skill listing"; listing budget scales at 1% of context window; on
  overflow "Claude Code drops descriptions starting with the skills you invoke least."
- Skills-dir plugins: "add a `.claude-plugin/plugin.json` to a skill folder and it loads as
  a plugin named `<name>@skills-dir`, so it can bundle agents, hooks, and MCP servers."
  Project-scope @skills-dir plugins don't walk up to repo root; project-scope background
  monitors don't load.
- **skillOverrides — 4 states** (`on` default, `name-only`, `user-invocable-only`, `off`),
  written via `/skills` menu to `.claude/settings.local.json`. **"Plugin skills are not
  affected by `skillOverrides`. Manage those through `/plugin` instead."** (resolves the
  UNVERIFIED flag from baseline research/01).
- Cross-agent spec: "Claude Code skills follow the Agent Skills (agentskills.io) open
  standard"; spec-restricted distribution paths allow only six fields (name, description,
  license, compatibility, metadata, allowed-tools).
- **/skill-doctor** (v2.1.252+): "see what each of your skills costs and how often it gets
  used"; report in `/plugin` manager Stats tab.

## 3. PLUGINS (plugins, plugins-reference, discover-plugins, plugin-evals — DOCUMENTED)

- Manifest `.claude-plugin/plugin.json`; "name is the only required field"; fields incl.
  displayName, version, description, author, homepage, repository, license, keywords,
  metadata, defaultEnabled, userConfig, channels, dependencies (semver; no dependsOn), and
  component paths skills/commands/agents/workflows/hooks/mcpServers/outputStyles/lspServers
  + experimental.themes/monitors/evals. Unrecognized top-level fields ignored.
- Bundle components: skills/, commands/ (legacy), agents/, hooks/hooks.json, .mcp.json,
  .lsp.json, monitors/monitors.json, bin/ (PATH executables), settings.json (only `agent`
  and `subagentStatusLine` keys), workflows/, or a single root SKILL.md. **Root CLAUDE.md
  in a plugin is not a component** (not listed).
- Namespacing: "Plugin skills are always namespaced (like `/my-first-plugin:hello`) to
  prevent conflicts when multiple plugins have skills with the same name." Same-named
  personal + plugin skill both load. Project/user `.claude/agents/` override same-named
  plugin agents.
- Scopes: user (default), project, local, managed.
- Marketplaces: `/plugin marketplace add` from GitHub owner/repo, git URLs, local paths,
  remote marketplace.json URLs, claude.ai-hosted libraries; `claude-plugins-official`
  auto-registered; community marketplace `@claude-community` passes "Anthropic's automated
  validation and safety screening", "pinned to a specific commit SHA". Trust warning:
  "Plugins and marketplaces are highly trusted components that can execute arbitrary code
  on your machine with your user privileges."
- Install/update/uninstall: `/plugin install name@marketplace` or `claude plugin install`;
  `--marketplace` one-step (2.1.275+); `--accept-command <sha256>` (2.1.271+); cache
  `~/.claude/plugins/cache`; uninstall marks prior version orphaned, sweep ~14 days;
  auto-update per-marketplace (on for official, off for third-party);
  DISABLE_AUTOUPDATER/FORCE_AUTOUPDATE_PLUGINS; "Removing a marketplace will uninstall any
  plugins you installed from it."
- `claude plugin validate [--strict]`: schema errors; "reports unrecognized fields as
  warnings, not errors".
- **`claude plugin eval`** (v2.1.269+; plugin-evals doc): "runs your plugin against a suite
  of test cases and scores the results. Each case is a realistic prompt plus one or more
  graders." Each case "runs three times by default" in "a fresh, isolated non-interactive
  session with only your plugin loaded"; "each case's runs are repeated with no plugin
  loaded by default" (with/without arms; Δ = plugin contribution). Graders: `regex`,
  `tool_used` (e.g. `tool_used: Skill` — trigger-rate measurement), `tool_order`,
  `file_exists`, `llm` (judge), `baseline`. Sandbox: OS-level sandbox, throwaway
  home/config per run; home dir and Claude Code config unreadable. MCP mocking. CI: exit
  0/1/2, `--json results.json` (versioned aggregate-result.json), `--threshold`,
  `--max-cost-usd`, `--trust-plugin`; HTML report. Caveat: "a suite that passes says
  nothing about whether the plugin is safe."

## 4. SUBAGENTS (sub-agents doc — DOCUMENTED)

- Locations: managed, --agents flag, `.claude/agents/`, `~/.claude/agents/`, plugin
  `agents/`. Priority "managed > CLI flag > project > user > plugin"; same name → higher
  priority wins; nearest-to-cwd wins (2.1.178+).
- Frontmatter: name+description required; tools, disallowedTools, model, permissionMode,
  maxTurns, skills, mcpServers, hooks, memory, background, **omitClaudeMd** ("launch this
  subagent without the user, project, and local CLAUDE.md files; managed policy files
  still load … Requires v2.1.271+"), effort, `isolation: worktree`, color, initialPrompt,
  experimental.cacheTtl.
- Nesting: "By default, a subagent can spawn subagents of its own, up to three layers below
  the main conversation." `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` configurable. (History: 5
  ≤2.1.216; 1 in 2.1.217–218; 3 since 2.1.219.)
- Concurrency: fails at 20 running ("Concurrent subagent limit reached");
  `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`; no total cap; "Sessions with ultracode active are
  exempt."
- Inheritance: fresh isolated context; loads CLAUDE.md hierarchy + git status snapshot;
  "Explore and Plan skip your CLAUDE.md files and the git status snapshot"; every other
  built-in/custom loads both unless omitClaudeMd; skills field preloads; otherwise
  "Subagents can still invoke unlisted project, user, and plugin skills through the Skill
  tool"; forks inherit parent conversation.
- Plugin subagents: load automatically, `plugin:subfolder:agent` scoped names; "plugin
  subagents don't support the `hooks`, `mcpServers`, or `permissionMode` frontmatter
  fields."
- `isolation: worktree`: temporary worktree "branched by default from your default branch";
  auto-cleaned if no changes.

## 5. AGENT TEAMS (agent-teams doc — DOCUMENTED)

- "Agent teams are experimental and disabled by default. Enable them by setting
  `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`."
- "One session acts as the team lead… Teammates work independently, each in its own context
  window, and communicate directly with each other." "Each teammate is a full, independent
  Claude Code session." Lead + teammates + shared task list + mailbox (JSON files).
- Config `~/.claude/teams/{team}/config.json`, inboxes `…/inboxes/{agent}.json`, tasks
  `~/.claude/tasks/{team}/`; "The team config directory is removed when the session ends."
- "There is no project-level equivalent of the team config."
- SendMessage (2.1.224+, no permission) targets "an agent team teammate, a subagent it
  resumes by agent ID or name, or one of your other Claude Code sessions"; ListAgents
  (2.1.224+) backs /list-agents.
- Lead fixed ("the main session is the lead for its lifetime. You can't promote a teammate
  to lead"); **"No nested teams: teammates cannot spawn their own teammates."**; no
  background subagents from in-process teammates; no teammate spawning in -p/SDK.
- **Auto-formation caveat: "while agent teams are enabled, a subagent that Claude names
  launches as a teammate, so teams can form even when you didn't ask for one."**
- Official sizing guidance: "Start with 3-5 teammates for most workflows… If you have 15
  independent tasks, 3 teammates is a good starting point." "Having 5-6 tasks per teammate
  keeps everyone productive." Teams vs subagents table ("Best for: Focused tasks where only
  the result matters" vs "Complex work requiring discussion and collaboration"; token cost
  lower vs higher). "Agent teams don't isolate teammates in worktrees, so partition the
  work."

## 6. DYNAMIC WORKFLOWS (workflows doc — DOCUMENTED)

- "A dynamic workflow is a JavaScript script that orchestrates many subagents at once.
  Claude writes the script for the task you describe, and a runtime executes it in the
  background." "Intermediate results stay in script variables instead of landing in
  Claude's context."
- Gating: keyword `ultracode` "is an opt-in only in a prompt you type yourself" — NOT via
  -p, SDK, scheduled tasks, webhooks, PR comments (changed v2.1.210); or `/effort
  ultracode` (2.1.203+); bundled /deep-research; saved workflows; plugin `workflows/` dir
  (namespaced). Per-run approval by permission mode; Workflow allow rules/PreToolUse
  hooks/canUseTool can approve. Kill switches: disableWorkflows,
  CLAUDE_CODE_DISABLE_WORKFLOWS, org admin.
- API: plain JS, top-level await, `agent()/pipeline()/parallel()/phase()/log()/args`;
  Date.now/Math.random/no-arg new Date throw (determinism for resume); no import(), no
  fs/shell from script, no mid-run user input.
- Limits: 16 concurrent default (CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS 1–256);
  4,096 items per parallel/pipeline; 1,000 agents/run; usage-limit pause (2.1.271+).
- Resume: "Resumable in the same session" — completed agents return saved results; changed/
  failed agent and everything after reruns; results persist under ~/.claude/projects/.
- Size guidance: workflowSizeGuideline small <5 / medium <10 (default; small default on
  Pro since 2.1.271) / large <50 / unrestricted; "Large workflow" advisory at >25 agents
  or >1.5M projected tokens.
- Teams vs workflows table: teams = lead decides turn-by-turn, shared task list, teammates
  keep running on interruption; workflows = script decides, script variables, resumable.

## 7. WORKTREES / ISOLATION (worktrees doc — DOCUMENTED)

- Session: `claude --worktree name` → `.claude/worktrees/<name>/` on branch
  `worktree-<name>`; worktree.baseRef fresh|head; `--worktree "#1234"` from PR;
  `.worktreeinclude` copies gitignored files.
- EnterWorktree tool mid-session; entering outside `.claude/worktrees/` prompts approval
  (2.1.206+; only bypassPermissions skips); ExitWorktree; from inside a worktree only
  `path` form under `.claude/worktrees/`.
- Subagent `isolation: worktree`; auto-remove when no changes; changed worktrees persist
  until sweep can remove safely.
- **Enforcement: four checks block edits into the main checkout, commands resolving there,
  git redirects (git -C, --git-dir, GIT_DIR/GIT_WORK_TREE, cd+git), unverifiable command
  shapes. "You can't turn this check off."**
- Cleanup: exit prompts keep/remove; periodic sweep (cleanupPeriodDays) for
  subagent/background worktrees, skipping work-in-progress, submodule risk (2.1.274+),
  user-created worktrees (2.1.246+); `git worktree lock` held while agent runs;
  WorktreeCreate/WorktreeRemove hooks for non-git VCS.
- Shared with main checkout: .git, project-scope plugins (2.1.200+), "don't ask again"
  approvals (2.1.211+), read-through of untracked .claude/skills/agents/commands (skills
  read-through 2.1.277+).

## 8. HOOKS (hooks doc — DOCUMENTED)

- **33 events**: SessionStart (matchers startup|resume|clear|compact|fork), Setup,
  UserPromptSubmit, UserPromptExpansion, PreToolUse, PermissionRequest, PermissionDenied,
  PostToolUse, PostToolUseFailure, PostToolBatch, Notification, MessageDisplay,
  SubagentStart, SubagentStop (match agent type incl. plugin-scoped), TaskCreated,
  TaskCompleted (teams quality gates), Stop, StopFailure, TeammateIdle, InstructionsLoaded,
  ConfigChange, CwdChanged, DirectoryAdded, FileChanged, WorktreeCreate, WorktreeRemove,
  PreCompact (manual|auto), PostCompact, PreModelSwitch, PostModelSwitch, Elicitation,
  ElicitationResult, SessionEnd.
- Matchers: exact name, or regex if any other character.
- Stdout injection: only UserPromptSubmit, UserPromptExpansion, SessionStart,
  PostModelSwitch add stdout as context; exit 2 feeds stderr to Claude (blocking on
  Pre-tool); JSON output honors systemMessage/additionalContext/updatedInput/
  permissionDecision per event.
- Config: settings files, managed policy, plugin hooks/hooks.json, skill frontmatter
  `hooks`, subagent frontmatter; entries merge across levels; plugin hooks get
  ${CLAUDE_PLUGIN_ROOT}/${CLAUDE_PLUGIN_DATA}/${user_config.*}. Hooks from settings,
  managed policy, plugins "also run inside subagents".

## 9. OFFICIAL DOCTRINE (features-overview, memory, skills docs — DOCUMENTED)

- (a) Model-driven selection: "Claude matches your task against skill descriptions to
  decide which are relevant. If descriptions are vague or overlap, Claude may load the
  wrong skill or miss one that would help. To tell Claude to use a specific skill, invoke
  it with `/<name>`." (features-overview, "How Claude chooses skills"). Skills page:
  "Skill not triggering" + "Skill triggers too often" troubleshooting; "If a skill seems to
  stop influencing behavior after the first response, the content is usually still present
  and the model is choosing other tools or approaches… or use hooks to enforce behavior
  deterministically."
- (b) Request-not-guarantee (current wording, features-overview "Hook vs Skill" → "Put
  guardrails in hooks"): "An instruction like 'never edit `.env`' in CLAUDE.md or a skill
  is a request, not a guarantee. A `PreToolUse` hook that blocks the edit is enforcement.
  If a rule must hold every time, make it a hook rather than a prompt instruction." Memory
  page: "Claude treats them as context, not enforced configuration. To block an action
  regardless of what Claude decides, use a PreToolUse hook instead. The more specific and
  concise your instructions, the more consistently Claude follows them."
- **(c) CLAUDE.md-over-skills precedence: NOT FOUND in current docs.** "CLAUDE.md files are
  additive: all levels contribute content… When instructions conflict, Claude uses judgment
  to reconcile them." "If two files give different guidance for the same behavior, Claude
  may pick one arbitrarily." Hard precedence rules exist only WITHIN feature types. → Any
  "CLAUDE.md beats skills" claim is CLAIMED, not DOCUMENTED, for Claude Code.
- Vendor multi-agent guidance: agents overview five-way comparison (subagents / agent view
  (research preview) / agent teams / projects / dynamic workflows); `/batch` "splits one
  large change into 5 to 30 worktree-isolated subagents that each open a pull request";
  teams sizing advice; "start with research and review" tasks; "Monitor and steer —
  letting a team run unattended for too long increases the risk of wasted effort".

## Flags

- No 2.1.279 in changelog (skipped or pulled).
- CLAUDE.md-over-skills precedence NOT FOUND (see §9c) — contradicts any assumption of an
  officially guaranteed instruction-channel precedence.
- agentskills.io spec not independently fetched (referenced field list verified via
  Claude docs only).
- Changelog body truncated below 2.1.269 in fetches; older entries verified via feature
  pages.

Sources: code.claude.com/docs/en/{changelog, skills, plugins, plugins-reference,
discover-plugins, plugin-evals, sub-agents, agent-teams, workflows, worktrees, hooks,
tools-reference, features-overview, memory, agents}.
