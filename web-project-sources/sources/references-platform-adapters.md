# Platform adapters

Read only the section for the active product. Prefer built-ins before creating persistent custom agents.

## OpenAI Codex / Codex CLI

- Prefer `explorer` for read-heavy codebase questions, `worker` for bounded implementation, and `default` for general isolated work. Use an installed custom reviewer only when independent review materially helps.
- Prefer an explicit fresh-context spawn (`fork_turns: "none"`) and provide a targeted brief with the minimum sufficient information. If parent history is genuinely needed, inherit only the smallest useful recent-turn suffix with a positive `fork_turns` value; use `fork_turns: "all"` only when the child needs the full parent-thread history. Any inherited history weakens context isolation, increases context and token cost, and can blur the delegated task boundary.
- Assign explicit file ownership to workers and state that other agents may be editing elsewhere in the same workspace.
- Keep children directly under the primary agent unless the user explicitly authorizes a bounded nested structure. Do not rely on a version-specific depth setting as the only guard.
- Use the runtime's agent listing, steering, interruption, and waiting controls to prevent duplicate or abandoned work. The primary agent runs final tests and integration.

## Claude Code

- Prefer built-in `Explore` for read-only discovery, `Plan` for plan-mode research, and `general-purpose` for a bounded task that may edit or run commands.
- Before the first `Agent` call, confirm the orchestration mode (SKILL.md, "Orchestration modes"): İAA mode never invokes `superpowers:subagent-driven-development`, and redirects to it do not apply whether they arrive as skill text (`executing-plans`, `writing-plans`) or as a `REQUIRED SUB-SKILL` directive embedded in the plan being executed. Only an explicit user request naming native SDD switches modes; in that mode this policy does not apply at all.
- `Explore` and `Plan` do not load the CLAUDE.md hierarchy or preloaded skills. Restate every task-specific constraint, applicable project retrieval rule, ownership boundary, and the no-nested-agent rule in their assignment.
- Other non-fork agents receive the applicable CLAUDE.md hierarchy but still need a targeted task brief. Prefer fresh context; use a conversation fork only when the complete parent history is truly required.
- The installed global adapter caps spawn depth at one. If the user explicitly requests a bounded nested design, raise `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` deliberately for that session and restore the default afterward.
- Do not add a permanent custom agent unless a recurring specialization needs distinct tools, permissions, model behavior, or a durable role prompt.

## ZCode / Z.AI coding environment

- Prefer built-in `Explore` for read-only search, architecture discovery, and evidence gathering. Use `general-purpose` for a clearly owned task that needs broader tools or writes.
- Built-in `Explore` does not inject global or workspace AGENTS.md. Restate relevant repository rules, orientation findings, ownership, deliverable, and validation in the prompt.
- General-purpose and enabled user agents normally inject AGENTS.md, but a targeted assignment is still required. A custom tool allowlist can remove skill or MCP access; do not assume those tools exist.
- ZCode subagents cannot spawn subagents. Keep orchestration in the primary Agent.
- User custom subagents are beta and user-scoped. Do not create one for this general methodology; create one only for a stable recurring specialization that the built-ins cannot cover.

