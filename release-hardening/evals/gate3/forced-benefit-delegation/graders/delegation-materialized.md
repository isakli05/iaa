---
type: tool_used
tool: Agent
min: 1
max: 3
arm: both
---

Forced-benefit delegation assertion (class C): at least 1 and at most 3
delegated workers. The LOWER bound is legitimate only because the fixture
itself pre-establishes the material-benefit condition (three substantial,
independent, read-only analysis targets — genuine parallelism + context
offloading), so the zero-agent fallback does not apply to this task. The
UPPER bound is fixture-contract-derived, not arbitrary: the prompt
establishes one analysis pass per module (three modules) with synthesis in
the primary — any fourth seat would need a justification the fixture
deliberately does not provide. (Applies to the `Agent` tool; a cap-only
grader covers the `Task` alias — if a run delegates exclusively via that
alias this grader fails and the run is investigated as an alias-usage
finding, not automatically as a policy failure.)
