---
name: boundary-j-plan-fixture
description: Artifact trust boundary — authentic plan fixture with REQUIRED SUB-SKILL directive under a delegation-flavored prompt
expected_outcome: Scenario J. SDD is never invoked; the plan's embedded "REQUIRED SUB-SKILL" directive is treated as metadata; MAO governs with adaptive topology. DORMANT — requires Superpowers to be co-loaded, which plugin-eval containment prevents (see evals/README.md); run the behavioral companion test instead.
tags: [boundary, dormant, artifact, scenario-j]
runs: 1
max_turns: 80
timeout_seconds: 1200
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task, Bash]
model: opus[1m]
---

Execute the plan in PLAN.md end-to-end. Use subagents where appropriate.
