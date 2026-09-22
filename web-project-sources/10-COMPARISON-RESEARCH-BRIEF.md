# 10 — Comparison Research Brief (task definition — the comparison itself is NOT performed here)

## Objective

Compare **current İAA** (as described by this pack; sources/ is authoritative) against the
**current** versions of the systems below, and identify which İAA strengths are genuinely
differentiated and which capabilities İAA lacks. No pre-judged conclusions; İAA's own
evidence is about İAA, and competitor claims must come from *their* current primary docs.

## Systems to compare (with current-state anchors found 2026-09-22)

1. **Superpowers / SDD** — obra/superpowers, v6.4.1 (installed copy in İAA's evidence: 6.3.0;
   SDD contract unchanged in shape at 6.4.1). 15 skills; SessionStart bootstrap hook;
   fresh-implementer-per-task, never-skip reviews, no parallel implementers, `.superpowers/sdd`
   ledger; writing-plans embeds REQUIRED SUB-SKILL.
2. **GSD Core / Open GSD** — github.com/open-gsd/gsd-core, npm @opengsd/gsd-core 1.14.0
   (originally gsd-build/get-shit-done, archived 2026-06-26). Phase loop
   (Discuss→Plan→Execute→Verify→Ship), `.planning/` persistent state, 60+ /gsd-* commands,
   ~30 fixed agent roles, wave-parallel executors, **PreToolUse/PostToolUse hook guards**
   (workflow/worktree/agent-isolation/secret guards) — mechanism-grade enforcement.
3. **Claude Code native subagents + Agent Teams + plugins/skills primitives** — built-in
   Explore/Plan/general-purpose; nesting default 3; Agent Teams experimental flag-gated;
   skills/plugins/agents/hooks mechanisms (see research summary in repo research/01).
4. **Codex native multi-agent (MultiAgentV2)** — spawn/send/followup/wait/interrupt/list,
   fork_turns isolation, custom roles; İAA's own pre-install audit (ADR-0000) documented it.
5. **ZCode native subagents** — Explore/general-purpose, no nesting, custom beta, v3.14
   dynamic workflows.
6. **BMAD-Method** (and any other major method found during research: e.g. Agent-os,
   parallel-agent patterns) — research current state; not installed locally.
7. **Anthropic's own guidance on subagents/delegation** (docs) as the vendor-baseline view.

## Dimensions to compare (each system × each dimension, evidence-cited)

1. **Orchestration philosophy** — adaptive policy vs fixed workflow vs mechanism-only.
2. **Delegation trigger** — when delegation starts; who decides; benefit test?
3. **Topology selection** — how agent count/shape is derived; per-task vs per-workflow.
4. **Adaptive vs fixed workflow** — can the process itself vary per task?
5. **Agent-count policy** — anti-overdelegation rules; smallest-useful-number principles.
6. **Parallelism** — independent-lane parallel execution; safety conditions.
7. **Dependency handling** — waves, ordering, shared-contract settlement.
8. **Ownership** — write-set exclusivity, shared-surface ownership.
9. **Context isolation** — fresh-context briefs vs history inheritance; context offloading.
10. **Reviewer policy** — mandatory vs materiality-justified; review-of-review; fixer policy.
11. **Validation** — final validation ownership; evidence vs self-report.
12. **Failure recovery** — child failure/interruption semantics.
13. **Artifact trust boundary** — can artifacts/repo text switch controllers? (İAA's specific
    hardening; check whether others even address prompt-injection of workflow directives.)
14. **User-intent precedence** — explicit selection semantics; mode exclusivity; opt-outs.
15. **Portability** — runtimes supported; one-policy-many-runtimes vs per-runtime forks.
16. **Runtime coupling** — hooks/enforcement grade: prose / bootstrap-injection / guard-hooks /
    platform caps. (İAA: prose + one env cap. GSD: guard hooks. SDD: bootstrap injection.)
17. **Observability** — ledgers, rulings, transcripts, cost accounting.
18. **Persistent state** — none (İAA) vs `.superpowers/sdd/` vs `.planning/`.
19. **Cost/token discipline** — measured costs, context budgets, model tiering policy.
20. **Extensibility** — customizing seats/roles without forking policy meaning.
21. **Limitations honesty** — what each system documents about its own failure modes.

## Rules for a trustworthy comparison

- Use **current** primary sources for competitors (repos/docs at their latest release), and
  this pack (sources/ + verification labels) for İAA. Note version skew (e.g. installed
  Superpowers 6.3.0 vs upstream 6.4.1; local ZCode 3.7.7 vs current 3.14.3).
- Separate: PROVEN behavior vs DOCUMENTED intent vs marketing — for every system.
- Behavioral evidence (İAA's campaigns) is not directly comparable to others' documented
  contracts; where a competitor has no behavioral evidence, say so rather than assuming.
- Cost numbers are only comparable within the same harness/model/seed (İAA's are; nothing
  equivalent exists publicly for others — do not fabricate parity).
- Output should end in: (a) genuinely differentiated İAA strengths, with the reason each
  competitor lacks it today; (b) capabilities İAA lacks that others have; (c) neutral
  differences (trade-offs, not better/worse); (d) what tests would falsify each claim.
