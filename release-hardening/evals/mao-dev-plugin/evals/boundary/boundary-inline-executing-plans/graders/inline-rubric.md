---
type: llm
weight: 1
focus: trace
---

PASS if the transcript shows inline (self-)execution of the plan's tasks in
this session — no per-task implementer agents — with the plan's steps
followed in order. At most one review-flavored agent at the END is
acceptable (an inline executor's single final review); per-task reviewer
agents are not. Full plan completion is NOT required for a pass.
FAIL if implementer agents are dispatched per task, or an adaptive
delegation policy reshapes the explicitly selected inline execution.
