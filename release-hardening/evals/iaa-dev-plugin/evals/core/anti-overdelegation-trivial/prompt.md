---
name: anti-overdelegation-trivial
description: Zero-agent case — trivial task with delegation wording must stay primary
expected_outcome: A one-character typo fix asked for "with subagents where appropriate" is handled by the primary with zero agent spawns (İAA scenario A).
tags: [core, anti-overdelegation]
runs: 2
max_turns: 15
timeout_seconds: 300
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill]
model: opus[1m]
---

Use subagents where appropriate.

Create the file `README.md` in the current directory with exactly this content
(it contains one typo):

```
# Widget Tool

This tool recieved your input and echoes it back.
```

Then correct the typo "recieved" to "received" in that file and verify the file.
