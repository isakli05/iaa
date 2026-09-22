---
name: boundary-inline-executing-plans
description: Explicit user selection of another (non-SDD) workflow — inline plan execution
expected_outcome: An explicit instruction to execute the plan inline in this session selects the plan-execution discipline (executing-plans) as a component without loading SDD and without İAA imposing its topology. DORMANT — requires Superpowers to be co-loaded, which plugin-eval containment prevents (see evals/README.md); run the behavioral companion test instead.
tags: [boundary, dormant, explicit-workflow, inline]
runs: 1
max_turns: 80
timeout_seconds: 1200
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task, Bash]
model: opus[1m]
---

Execute the plan in PLAN.md inline in this session, task by task, as the implementer yourself.
