# Audit 04 — Coexisting Orchestrators on This Machine (2026-09-22)

Local census only (no modifications). Distribution-model research for the wider world is in
`research/01-current-distribution-landscape.md`. "Can compete with MAO" = can issue an
incompatible execution policy for the same task.

## Census

| System | Path / install scope | Identity & namespace | Invocation | Auto-invocation | Controls subagent execution? | Mutates global instructions/hooks/settings? | Can compete with MAO? |
|---|---|---|---|---|---|---|---|
| **Superpowers 6.3.0** (Claude Code plugin, official marketplace, commit 44c9b2d6) | `~/.claude/plugins/cache/claude-plugins-official/superpowers/6.3.0` (user scope, enabled in settings.json) | plugin skills namespaced `superpowers:*` (13 skills + writing-skills) | model-invocable skills + explicit | **YES — SessionStart hook** (`hooks/hooks.json`, matcher `startup\|clear\|compact`) injects full `using-superpowers` bootstrap every session ("invoke relevant skills before ANY response") | YES — SDD prescribes implementer/reviewer/fixer seats, sequencing, no-parallel rule (568-line SKILL); `dispatching-parallel-agents` prescribes parallel seats | Hook is plugin-scoped (no user settings mutated); but its injected bootstrap is context-level global pressure | **YES — primary competitor** (demonstrated: campaigns 1/1b) |
| **Superpowers 6.2.0 inside ZCode** | `~/.zcode/cli/plugins/cache/claude-plugins-official/superpowers/6.2.0` | same, cached by ZCode's Codex-derived engine | via ZCode skill mechanism (stale AGENTS.md symlink → /tmp, broken) | unknown (ZCode-side) | same skill semantics, one version older | plugin-cache-scoped | potentially, on ZCode — UNVERIFIED live |
| **MAO** (subject) | canonical `~/.local/share/ai-agent-orchestration/…` + 3 symlinks + 3 shims | `multi-agent-orchestration` (un-namespaced, user scope) | model-invocable + `/multi-agent-orchestration` | proactive trigger via shim (policy text, no hook) | YES — that is its purpose | writes managed shim blocks + one managed env key (marker-delimited, reversible) | — |
| **Codex native MultiAgentV2** | `~/.codex/config.toml [agents]` enabled, `max_concurrent_threads_per_session=4`, `max_depth=1` (V1 fallback, ignored by V2); `~/.codex/agents/reviewer.toml` (independent reviewer role, no-spawn) | runtime-native tools (spawn_agent et al.) | model-invoked tools | no (tools, not instructions) | YES (it IS the execution mechanism) | config only, pre-existing, not MAO's | NO — mechanism, not a policy authority; MAO rides on it |
| **Claude Code native subagents** | built-in Explore/Plan/general-purpose; no `~/.claude/agents` customs | runtime-native | model-invoked | no | YES (mechanism) | no | NO — mechanism |
| **Claude Code background sessions / teams infra** | `~/.claude/daemon/` (supervisor roster, empty workers), no `~/.claude/teams` | runtime-native (SendMessage/ListAgents surface) | explicit | no | partially (cross-session workers) | no | NOT CONFIGURED today; latent — unknown policy if later used |
| **Claude Code Workflow tool** | built-in (opt-in "ultracode"-style orchestration) | runtime-native | explicit user opt-in only | no | YES (deterministic multi-agent scripts) | no | NO by design (opt-in); would collide if invoked inside MAO mode — untested |
| **graphify** | `~/.claude/skills/graphify` + copies/links in Codex & ZCode + user-maintained CLAUDE.md policy sections | `graphify` | `/graphify` + model-invocable | broad proactive description (codebase questions) | NO (retrieval layer, no agent seats) | user-maintained instruction sections (not managed-marker) | NO — trigger overlap only (orientation), no authority claim |
| **audit-council** | `~/.claude/skills/audit-council` (+v2.0.0/v1.0.3 rollback copies), dev repo `~/audit-council-dev` (git), runtime `~/.local/share/audit-council` | `audit-council` | **user-invoked only** (`disable-model-invocation: true`) | NO (explicitly disabled) | YES within its own bounded audit runs (its own PM/topology) | no global mutation | NO — opt-in bounded system; good citizen example |
| **LLM Council Orchestrator (LCO)** | `~/projects/llm_council_orchestrator` (+14 worktrees) — project, not installed globally | project codebase | explicit | no | it is *executed under* MAO (production topology doc) | no | NO — consumer of MAO, not a competing authority |
| **Hermes Agent** | `~/.hermes/` (systemd, own runtime) | separate product | explicit | no | own runtime's mechanism | its own config only | NO — separate runtime, no MAO integration found |
| **GSD / BMAD** | — | — | — | — | — | — | NOT INSTALLED (name+content search clean) |

## Key local facts for the collision analysis

1. The **only installed competing orchestration authority is Superpowers SDD** — and the
   entire demonstrated collision history (campaigns 1–3) is about exactly this pair.
2. Superpowers' SessionStart hook is **synchronous and unconditional** on startup/clear/compact;
   MAO has no hook and no bootstrap — asymmetry that shaped the structural fix (MAO routes at
   the user-instruction layer, which Superpowers' own bootstrap defers to).
3. `dispatching-parallel-agents` (Superpowers) and MAO share a trigger surface ("2+
   independent tasks" vs "delegate/parallelize") — a real description-level trigger overlap,
   currently governed by MAO's whitelist rule (seat-prescribing components only execute
   pre-authorized lanes).
4. ZCode carries a **stale Superpowers 6.2.0** cache with a broken internal symlink — version
   skew across runtimes for the same plugin family.
5. Codex's reviewer.toml is an MAO-compatible independent-reviewer role (explicit no-spawn,
   read-only) — pre-existing, referenced by MAO's adapter as an optional review mechanism.
6. audit-council demonstrates the local precedent for `disable-model-invocation: true` as the
   strongest no-trigger-collision mechanism.
