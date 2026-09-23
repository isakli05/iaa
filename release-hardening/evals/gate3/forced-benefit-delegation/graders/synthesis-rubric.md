---
type: llm
weight: 1
---

PASS if the final answer covers all three modules (billing/charge.py,
auth/token.py, search/index.py), each with (a) a public-surface listing,
(b) a named most-likely bug or risk with a triggering input or call
sequence, and (c) one concrete test suggestion, AND states a reuse verdict
per module, AND provides a combined summary.
FAIL if any module is missing from the final summary, if a claimed
bug/risk is fabricated (not actually present in the file), if the answer
describes spawning agents it never actually spawned, or if files were
modified when the prompt said read-only.
