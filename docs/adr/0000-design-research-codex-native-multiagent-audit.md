# ADR-0000 — Design research: Codex native multi-agent audit

Date: 2026-08-26 (~02:00–04:00 Istanbul). Status: historical record (condensed).
Raw evidence: `~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md` (local).

## Context

Before installing any orchestration policy, the native multi-agent surface of Codex CLI
0.149.1 (rust-v0.149.1, tag ff29a44) was audited live: MultiAgentV2 tools (spawn_agent,
send_message, followup_task, wait_agent, interrupt_agent, list_agents), fork_turns isolation
semantics (none/all/suffix), agent roles (default/reviewer via agent_type), and concurrency
behavior (verified overlapping child intervals, root work concurrent with children).

## Decision

İAA's platform adapters were written from these verified primitives (explorer/worker/default
preferences, fresh-context-first fork policy, direct-children-only nesting, runtime steering)
rather than from documented assumptions. Claude Code and ZCode adapters were written against
their documented built-ins (Explore/Plan/general-purpose; ZCode's no-nesting platform rule).

## Consequences

- Adapter advice is grounded in observed runtime behavior for Codex; Claude/ZCode adapter
  claims are documentation-based and were behaviorally exercised only on Claude (campaigns).
- The audit also established the "policy rides the mechanism" split that İAA still uses:
  İAA never re-implements spawning; it decides when/what to spawn.
