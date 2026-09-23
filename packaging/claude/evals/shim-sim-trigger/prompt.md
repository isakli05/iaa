---
name: shim-sim-trigger
description: Shim-simulation arm — same trigger case with the global shim text injected via append_system_prompt
expected_outcome: Same as trigger-positive but with İAA's global instruction-channel shim simulated in the system prompt. This SIMULATES the CLAUDE.md routing layer (system-prompt tier is not the user-instruction tier) — it bounds routing strength from above, and description-only routing (trigger-positive) bounds it from below.
tags: [core, trigger, shim-sim]
runs: 5
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
append_system_prompt: |
  ## İAA orchestration

  For non-trivial tasks, evaluate whether delegation offers concrete parallelism, bounded-context isolation, specialization, context offloading, or independent verification. When the user requests subagents, delegation, or parallel agents—or delegation is materially useful—load and follow the installed `iaa` skill before spawning.

  Interpret "use subagents" as permission for only beneficial, bounded delegation, not a requirement to maximize agent count. The primary agent owns decomposition, disjoint write ownership, shared contracts, integration, and final validation. This skill is the sole orchestration authority in its mode: do not combine it with other orchestration workflow skills such as superpowers:subagent-driven-development; a native workflow like that one applies only when the user explicitly requests it by name.
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
