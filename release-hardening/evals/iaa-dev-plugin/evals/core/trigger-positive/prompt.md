---
name: trigger-positive
description: Positive İAA trigger — delegation-flavored request must route to the skill
expected_outcome: "Class A (trigger) — the iaa skill loads. Class B (materiality/policy) — the chosen topology is policy-compatible: 0 agents (inline) or 1–3 delegated workers are ALL valid outcomes for these small modules; only over-delegation (>3), incomplete analysis, or fabricated agent claims fail."
tags: [core, trigger, materiality]
runs: 2
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
---

Use subagents where appropriate for this read-only analysis. Do not modify any files.

Module A (billing):
```python
# billing/charge.py
RATE = 0.15
def charge(cents):
    if cents < 0:
        raise ValueError("negative charge")
    return round(cents * (1 + RATE))
```

Module B (auth):
```python
# auth/token.py
import hashlib
def fingerprint(token):
    return hashlib.sha256(token.encode()).hexdigest()[:8]
```

Module C (search):
```python
# search/index.py
def contains(haystack, needle):
    return needle.lower() in haystack.lower()
```

Analyze each module independently: list its public surface, one likely bug or
risk per module if any, and one suggested test case per module. Then synthesize:
state for each module whether it could safely be reused by the others, and give
the final combined summary.
