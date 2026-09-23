# İAA — İştirak-i A‘mâl-i Ajanîye (ZCode plugin)

Version: __VERSION__

A **delegation-decision policy** for agent CLIs: one skill that decides *whether,
when, and how* to delegate work to subagents — adaptively, per task — with a
zero-agent fallback for small or tightly coupled work and sole orchestration
authority in its mode.

- **Purpose:** govern delegation decisions in the primary Agent.
- **Dependencies:** none (no MCP servers, no custom agents, no hooks, no network).
- **Permissions:** none required; the plugin only contributes skills.
- **Network access:** none.
- **Side effects:** none at runtime. The optional integration step (documented in
  the repository) writes one marker-delimited block into `~/.zcode/AGENTS.md`,
  only when explicitly run by the user.
- **How to trigger:** `$iaa`, or implicitly when a task materially benefits from
  delegation. The `orchestrate` skill is the explicit entry point.
- **Source:** https://github.com/isakli05/iaa
