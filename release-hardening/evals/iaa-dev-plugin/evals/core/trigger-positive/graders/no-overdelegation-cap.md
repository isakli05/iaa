---
type: tool_used
tool: Agent
min: 0
max: 3
arm: both
---

Anti-overdelegation cap: at most 3 agent spawns for this three-module
read-only task. `min: 0` is explicit and load-bearing: zero agents is a
valid in-policy outcome for this class (zero-agent fallback — inline
execution of small modules is permitted, not mandated away). Omitting `min`
would default it to 1 and silently conflate "İAA triggered" with "İAA must
spawn an agent" (Gate-3 methodology fix; see
gate-3/03-trigger-eval-methodology.md). (Applies to the `Agent` tool; a
second grader covers the `Task` alias.)
