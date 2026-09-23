---
type: tool_used
tool: Agent
min: 0
max: 3
arm: both
---

Anti-overdelegation cap: at most 3 agent spawns for this three-module
read-only task. `min: 0` is explicit (Gate-3 methodology fix: an omitted
`min` defaults to 1, conflating triggering with mandatory spawning; 0 agents
remains a valid in-policy outcome). (Applies to the `Agent` tool; a second
grader covers the `Task` alias.)
