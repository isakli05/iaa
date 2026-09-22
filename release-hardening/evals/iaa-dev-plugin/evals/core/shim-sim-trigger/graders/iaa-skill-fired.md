---
type: tool_used
tool: Skill
input_match: '"skill"\s*:\s*"(?:[\w-]+:)?iaa"'
---

Plugin-fired indicator (excluded from the score in a two-arm run): passes when
the iaa skill was invoked at least once, including its
namespaced `iaa-dev:iaa` form.
