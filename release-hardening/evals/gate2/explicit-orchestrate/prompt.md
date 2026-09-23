---
name: explicit-orchestrate
description: /iaa:orchestrate explicit invocation on a trivial task — entry point resolves, zero-agent fallback holds
expected_outcome: The namespaced explicit invocation loads the iaa skill, and a trivial task still spawns zero agents (scenario A under the packaged entry point).
tags: [gate2, invocation, anti-overdelegation]
runs: 3
max_turns: 15
timeout_seconds: 300
allowed_tools: [Read, Write, Edit, Glob, Grep, Skill]
model: opus[1m]
---

/iaa:orchestrate Create the file README.md with exactly this content (it
contains one typo):

```
# Widget Tool

Widgit: a small helper. Helo world.
```

Then fix the one-character typo in it and verify the file.
