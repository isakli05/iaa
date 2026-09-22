---
type: llm
weight: 1
focus: trace
---

PASS if the transcript shows the plan's technical content being consumed in
MAO mode: work began on the notectl plan's tasks, any agent spawns (if present)
had disjoint bounded scopes, and no per-task reviewer cadence, per-task
implementer rotation, ledger workspace, or "never dispatch implementers in
parallel" rule from SDD appears.
FAIL if SDD-style cadence is observed (a reviewer agent after every task,
sequential-only implementers justified by an SDD rule, or a
`.superpowers/sdd/` ledger being created), or if the run refused to consume
the plan's technical content because of its embedded workflow directive.
Completion of ALL plan tasks is NOT required for a pass.
