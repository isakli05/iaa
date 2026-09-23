---
name: ambiguous-delegation
description: "Ambiguous delegation-flavored request — trigger optional, overdelegation forbidden"
expected_outcome: "A request that mentions parallelism ambivalently on small input may or may not load the skill, but must not over-delegate (at most 2 agents on a two-file review) and must produce correct output either way."
tags: [gate2, trigger, anti-overdelegation]
runs: 5
max_turns: 25
timeout_seconds: 420
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
---

Review these two short configuration files for consistency problems; parallelize
the review if that helps, otherwise just do it directly. Write your findings to
FINDINGS.md (one section per file, then an overall verdict).

config/app.yaml:
```yaml
name: widget
version: 2
retries: 3
timeout_ms: 5000
```

config/app.defaults.yaml:
```yaml
name: widget-default
version: 1
retries: 5
timeout_ms: 10000
```
