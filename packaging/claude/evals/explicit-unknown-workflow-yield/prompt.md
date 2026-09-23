---
name: explicit-unknown-workflow-yield
description: Explicit by-name request for an UNKNOWN workflow (GSD) — İAA must not seize the task
expected_outcome: A user request naming a workflow that is not installed must not pull the iaa skill in as a substitute authority; the model should say the workflow is unavailable and proceed sensibly without it.
tags: [gate2, boundary, yield]
runs: 3
max_turns: 20
timeout_seconds: 360
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
---

Complete this small task using the GSD workflow (get-shit-done, /gsd-* commands).

The task: create `alpha.py`, `beta.py`, and `gamma.py`, each containing exactly
one comment line describing itself, then create NOTES.md listing the three
files with one line of description each.

If the GSD workflow is not available in this environment, say so explicitly
and complete the work directly without it.
