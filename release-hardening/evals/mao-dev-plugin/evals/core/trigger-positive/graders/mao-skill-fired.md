---
type: tool_used
tool: Skill
input_match: '"skill"\s*:\s*"(?:[\w-]+:)?multi-agent-orchestration"'
---

Plugin-fired indicator (excluded from the score in a two-arm run): passes when
the multi-agent-orchestration skill was invoked at least once, including its
namespaced `mao-dev:multi-agent-orchestration` form.
