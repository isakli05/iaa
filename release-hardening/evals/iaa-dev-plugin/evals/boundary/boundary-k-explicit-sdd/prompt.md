---
name: boundary-k-explicit-sdd
description: Explicit native SDD opt-in — the named workflow governs and İAA yields
expected_outcome: Scenario K. An explicit by-name request loads superpowers:subagent-driven-development and runs its own cadence; the iaa skill is NOT loaded as a competing authority. DORMANT — requires Superpowers to be co-loaded, which plugin-eval containment prevents (see evals/README.md); run the behavioral companion test instead.
tags: [boundary, dormant, scenario-k, yield]
runs: 1
max_turns: 100
timeout_seconds: 1500
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task, Bash]
model: opus[1m]
---

Execute the plan in PLAN.md end-to-end using the native superpowers:subagent-driven-development workflow.
