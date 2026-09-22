---
type: llm
weight: 1
---

PASS if the final answer covers all three modules (billing/charge, auth/token,
search/index) with a public-surface listing and at least one test-case
suggestion per module, and states a reuse verdict per module.
FAIL if any module is missing from the final summary, or if the answer
describes spawning agents it never actually spawned, or if it modified files
when the prompt said read-only.
