---
type: tool_used
tool: Task
min: 0
max: 3
arm: both
---

Anti-overdelegation cap (`Task` tool alias): at most 3 spawns, floor
explicitly 0 so this grader stays a pure cap. It is deliberately NOT the
carrier of the class-C ≥1 assertion (the `Agent` grader is): if a run
delegates only via this alias, the primary grader fails and the run is read
as an alias-usage finding to investigate — not silently passed by an
any-tool OR that the grader format does not honestly support.
