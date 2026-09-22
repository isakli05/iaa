---
type: tool_used
tool: Skill
input_match: '"skill"\s*:\s*"(?:[\w-]+:)?multi-agent-orchestration"'
min: 0
max: 0
arm: both
---

The multi-agent-orchestration skill must NOT be invoked for this ordinary,
small, single-file task with no delegation wording. (`arm: both` so it is
scored in the baseline arm too — the skill firing there would be a
routing false positive.)
