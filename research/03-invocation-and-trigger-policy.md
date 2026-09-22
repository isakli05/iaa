# Research 03 — Invocation and Trigger Policy (research only; no semantics changed)

## İAA's current invocation semantics (verified)

- **Claude Code:** model-invocable skill (description-matched, progressive disclosure) +
  user-invocable `/iaa` + proactive load instruction in the global
  CLAUDE.md managed shim ("when … requested or materially useful"). No hook, no bootstrap.
- **Codex:** implicit invocation enabled (default `allow_implicit_invocation: true` — İAA
  ships no `agents/openai.yaml`, so it accepts the default) + `$iaa`
  + AGENTS.md shim.
- **ZCode:** enabled-skill description injected each turn (≤250 chars) + `$iaa`
  + AGENTS.md shim.
- Runtime-specific difference: only the injection channel differs (description listing vs
  per-turn injection vs global instructions); the trigger *meaning* is identical by design.
- Classification: **hybrid** — explicit and model-invocable and proactively-triggered, with
  an anti-trigger clause ("Not for small or tightly coupled work") and per-task opt-out.

## The three public models, evaluated against coexistence

### A. Explicit-only İAA (`disable-model-invocation: true`-equivalent everywhere)

- Claude: supported natively; Codex: supported (`allow_implicit_invocation: false`); ZCode:
  no documented implicit-disable flag (would need description-based discouragement only) —
  asymmetry across runtimes.
- Coexistence wins: Class-3 (trigger) collisions vanish — İAA can never be dragged into a
  contested selection by description match; SDD/GSD/bootstraps compete without İAA in the
  listing.
- Costs: defeats İAA's core design goal — "proactively when a complex task concretely
  benefits" is half the policy's value (install-time smoke scenario E proved implicit
  benefit real); users must remember the name; the shim's "materially useful" instruction
  would contradict the frontmatter (shim would need rewording — a semantics change, out of
  scope). Also note: audit-council shows this model works well for *bounded tools*; İAA is
  not a bounded tool.
- Net: safest for coexistence, contradicting to purpose.

### B. Automatically model-invocable İAA (status quo, public)

- The description is the entire collision surface. Current description is deliberately
  narrow ("requests to use subagents, delegate, divide, or parallelize… when a complex task
  concretely benefits… Not for small or tightly coupled work").
- Coexistence exposure: any other broad proactive skill (a future GSD plugin, BMAD-style
  agents, a renamed SDD) matching the same request forces a selection contest every time.
  Evidence that İAA wins such contests when it matters: the shim rides the instruction
  channel (6+ samples); evidence it can't be *guaranteed*: official doctrine + ADR-0001's
  variance history.
- Public-specific risk: on other users' machines, İAA's shim text lands in *their* global
  instruction files — a strong-voiced instruction from a newly installed package. Polite
  but assertive; must stay honest and narrow, or İAA becomes the aggressive neighbor it
  defends against.
- Net: matches purpose; requires the narrow trigger discipline + scenario-J tripwire
  documented in the upgrade-check.

### C. Hybrid with runtime-tuned triggers

- Keep model-invocable default; add runtime-native dampeners where supported: Codex
  `agents/openai.yaml` exists already (could set metadata, keep implicit true); Claude
  description discipline + optional `when_to_use` separation; ZCode stays description-based.
- Coexistence: marginally better than B (Codex users could opt out implicitly per skill);
  complexity cost: per-runtime trigger semantics begin to fork (against the "adapters
  adapt mechanisms, not meaning" principle).
- Net: viable refinement candidate for the design phase; not a baseline change.

## Description-width analysis (the real lever)

The Aug-27 history shows the *width of the description* decided both collisions: v0's broad
proactive description + SDD's self-matching description loaded both engines; v3's
sole-authority sentence inside the description is what the model quoted when rejecting the
redirect. For public release the description must simultaneously: (1) match delegation
requests, (2) declare sole authority, (3) anti-trigger small/coupled work, (4) fit ZCode's
250-char injection, (5) stay under Claude's 1,536 listing budget, (6) respect the spec's
1,024. Current description satisfies all (247–249 chars) — this constraint set should be
recorded as a packaging invariant (`iaa doctor` check; design doc).

## Recommendation shape (for the later decision, not decided here)

Status quo (B) with documented trigger discipline + upgrade tripwire is defensible;
explicit-only (A) is the fallback if public-mode collisions prove worse than evidence
suggests; (C) is the refinement path. Any change is post-comparison work.
