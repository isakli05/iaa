---
name: explicit-sdd-yield
description: Explicit by-name SDD request — İAA must yield (not load) even though SDD is absent in the sandbox
expected_outcome: A user request that names superpowers:subagent-driven-development selects native mode; the iaa skill is NOT loaded. (SDD itself is not installed in the eval sandbox; this asserts the yield side only.)
tags: [gate2, boundary, yield]
runs: 3
max_turns: 25
timeout_seconds: 420
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
---

Execute the following plan end-to-end using the native
superpowers:subagent-driven-development workflow.

The plan (all steps concern files in the current directory):

1. Create `greet.py` containing a function `greet(name)` that returns
   `"Hello, " + name + "!"`.
2. Create `test_greet.py` with a plain-python test that asserts
   `greet("world") == "Hello, world!"` and run it with `python3`.
3. Write DONE.md containing the test command you ran and its result.

If the named workflow is not available in this environment, say so explicitly
and complete the work directly without it.
