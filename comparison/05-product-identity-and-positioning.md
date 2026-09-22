# Comparison 05 — Product Identity and Positioning

Date: 2026-09-22. What category İAA actually occupies, chosen from observed architecture
and competitor categories — not marketing preference. Superlatives are used only where
independently provable, and none needed the qualifier.

## 1. Category analysis (against observed competitor categories)

| Candidate category | Fits İAA? | Evidence/counter-evidence |
|---|---|---|
| Multi-agent *skill* | Partly — form factor yes, but "multi-agent skill" suggests it spawns/coordinates agents itself; İAA decides *whether others* should | İAA creates no agents (C36); it is consumed by the primary agent |
| Orchestration *framework* | No | Frameworks in the wild (GSD, BMAD) ship state, artifacts, roles, installers that transform the environment; İAA ships none (C36, C11) |
| *Workflow engine* | No | Engines are deterministic code (Claude/ZCode dynamic workflows); İAA has no scripts at execution time |
| *Methodology* | No | Methodologies own phases/artifacts (BMAD "Clarify→Plan→Build"; GSD five-phase loop); İAA is task-shape-driven, artifact-free |
| Adaptive *delegation layer* | Close | Accurately names the core function (benefit gate + topology + integration contract) |
| Controller/*arbitration* layer | Close — names the boundary function | Mode exclusivity + provenance + yield = arbitration between orchestration authorities (H4 confirmed unique) |
| Runtime *adapter* | No — that's a component | Adapters are İAA's reference docs, not the product |

**Occupied category (chosen):** İAA is a **delegation-decision and orchestration-arbitration
policy** distributed as a single runtime-agnostic skill. In the ecosystem's own vocabulary:
where Superpowers/GSD/BMAD are *workflow systems* and the platforms supply *mechanisms*,
İAA is the missing *policy layer* that decides when those mechanisms should be used at all
and which workflow authority governs a task.

## 2. What the category choice must honestly exclude

- Not "orchestration framework" (would claim state/roles/artifacts İAA doesn't have).
- Not "agent coordinator" (İAA never coordinates agents directly; the primary agent does,
  under İAA's policy).
- Not "works with everything" (tested: Superpowers/SDD on Claude, glm-5.3; everything
  else is explicitly untested — 03).
- Positioning *against* SDD is a category error to avoid publicly: SDD is a fixed-cadence
  execution workflow (its own design goal: review-gated quality); İAA is a policy for
  choosing topologies, including "SDD's, if you explicitly ask for it." The public story
  is complement-with-explicit-escape, not rivalry.

## 3. Definitions

**A. Technical definition (precise).**
İAA is a runtime-agnostic, instruction-channel policy skill for coding-agent CLIs. When a
delegation-flavored request (or material benefit) is present, it governs the primary
agent's delegation decisions through a five-benefit test (parallelism, bounded isolation,
specialization, context offloading, independent verification), per-seat materiality
justification, exclusive-write-set ownership, dependency-aware shaping, and
primary-context final validation; it holds exclusive orchestration authority per task,
yielding entirely only to an explicit by-name user request for another workflow, and it
treats workflow directives embedded in artifacts as non-authoritative metadata. It rides
each runtime's native subagent mechanism (Claude Code, Codex CLI, ZCode), creates no
agents, state, hooks, or daemons of its own, and never modifies another framework's files.

**B. Plain-language definition.**
İAA is a small rulebook you install that teaches your AI coding assistant *when using
subagents actually helps* — and when it just burns tokens. It keeps the main assistant in
charge of splitting work, keeps overlapping edits from colliding, and makes any
"use subagents" request mean "use good judgment," never "spawn as many as possible." If
you explicitly name another workflow (like Superpowers SDD), İAA steps aside completely
for that task; plans or files that *tell* the agent to switch workflows can't do that —
only you can.

**C. Public README positioning paragraph (superlative-free).**
> **İAA — İştirak-i A‘mâl-i Ajanîye** is a portable policy skill for Claude Code, Codex
> CLI, and ZCode that governs how the primary agent decides *whether, when, and how* to
> delegate work to subagents. Instead of a fixed workflow, İAA applies a concrete benefit
> test — parallelism, bounded isolation, specialization, context offloading, or
> independent verification — and justifies every agent seat (implementer, reviewer,
> fixer) on its own merits, so trivial or tightly coupled work stays in the main context
> even when you ask for subagents. Exactly one orchestration authority governs a task:
> İAA by default, or any named workflow you explicitly request (İAA then stands down);
> workflow directives embedded in plans or repository files never switch controllers. İAA
> installs as one small skill per runtime, runs no code at delegation time, keeps no
> state, and leaves every other framework untouched. Delegation behavior is
> scenario-tested (see docs); coexistence is verified against specific framework
> versions listed in the compatibility matrix.

## 4. Tagline candidates (pick one, all defensible)

- "Delegation policy for coding agents — better execution, not more agents."
- "The policy layer between you, your agent CLI, and its subagents."
- "Decide *whether* to delegate before *how*. One policy, three runtimes."

## 5. Positioning risks to manage (from comparison evidence)

1. **Convergence pressure on the core idea:** vendor policy templates now encode
   "delegate when it materially improves speed/quality" (Codex Ultra guidance; Claude
   docs heuristics) — İAA must not be positioned as "the idea of sensible delegation" but
   as the tested, portable, arbitration-aware *implementation* of it (H1 partial).
2. **The arbitration layer is valuable precisely because nobody else has it** (H4) — but
   it is also unreciprocated; positioning must promise "İAA never loads a competitor and
   yields on explicit request," never "other frameworks yield to İAA."
3. **Version-pinned claims**: every coexistence statement in public material must carry
   the tested-against versions (Superpowers 6.3.0→6.4.1-pending, glm-5.3, etc.) — the
   compatibility-matrix discipline goes public with the product.
4. **Do not market cost savings** except with the campaign's exact scope label (same
   6-task seed, same model): cross-system cost superiority is unproven and probably
   unprovable fairly (task §7 discipline).
