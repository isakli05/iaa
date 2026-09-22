# 01 — MAO Project Brief

## What it is

A single, runtime-agnostic **skill** (one SKILL.md + 2 reference docs + 1 POSIX install
script + 1 scenario-contract file, ~35 KB total) that gives an agent CLI's primary agent a
tested policy for deciding **whether, when, and how to delegate work to subagents** — and,
critically, when **not** to. No code runs at delegation time; no daemon; no hooks; no
agents of its own. It rides each runtime's native subagent mechanism.

## Design objective

Make "use subagents" mean better execution rather than more agents. The primary agent stays
the orchestrator and final integration authority; delegation must buy one of five concrete
benefits (parallelism, bounded isolation, specialization, context offloading, independent
verification) or not happen; every implementer/reviewer/fixer seat needs a task-specific
material-benefit justification.

## The three defining ideas

1. **Adaptive topology instead of fixed workflow.** No mandated roster, no mandatory review
   cadence, no fixed sequencing. Waves and seats are derived from task structure.
2. **Sole orchestration authority per task, by mode.** Adaptive MAO mode (default) never
   loads a competing orchestration engine (specifically Superpowers SDD); a native workflow
   runs only on explicit by-name user request, and then MAO stands down entirely. The two
   never compose on one task.
3. **Artifact trust boundary.** Workflow directives found inside plans/specs/generated
   artifacts/repository text ("REQUIRED SUB-SKILL: …", "MUST use SDD…") are orchestration
   metadata, never user opt-in; the artifact's technical content remains fully usable.

Each idea is behavior-tested (2026-08-27 campaigns; see 07/08) — including adversarially.

## Where it runs

Installed globally since 2026-08-26 for Claude Code (2.1.246→2.1.274), Codex CLI (0.149.1→
0.154), ZCode (3.7.7): one canonical source directory + three relative symlinks + one
2-paragraph managed shim per runtime's global instruction file + one managed env key on
Claude (subagent spawn depth = 1, an anti-recursion cap). Source unchanged since
2026-08-27 (version v3; sha256-pinned lineage).

## Status and purpose of this pack

Frozen baseline. The owner's next step is an evidence-based comparison against SDD/
Superpowers, GSD, Claude native subagents/Agent Teams/plugins, BMAD and peers, to find what
is genuinely differentiated — using this pack as the accurate description of MAO. No
superiority is claimed anywhere in this pack.
