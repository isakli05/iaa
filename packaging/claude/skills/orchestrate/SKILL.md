---
name: orchestrate
description: "Explicit İAA orchestration entry point. Runs the current task under the iaa delegation policy."
disable-model-invocation: true
---

# /iaa:orchestrate

Explicit İAA orchestration entry point.

Load and follow the `iaa` skill bundled in this plugin and apply it as the sole
orchestration authority for the current task. That skill defines all behavior,
including when to yield to an explicitly user-named workflow.
