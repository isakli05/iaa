---
type: tool_used
tool: Skill
input_match: '"skill"\s*:\s*"(?:[\w-]+:)?iaa"'
arm: with-only
---

Class-A trigger indicator for this case: passes when the iaa skill was
invoked at least once, including its namespaced forms. It is an indicator,
not the scored question of this class (class C asserts delegation
materialized, not skill loading) — kept with `arm: with-only` so a two-arm
run reports it unscored.
