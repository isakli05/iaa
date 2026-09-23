---
name: forced-benefit-delegation
description: Forced-benefit delegation — benefit pre-established by fixture; at least one delegated worker is the policy-compatible outcome
expected_outcome: "Class C (forced-benefit) — with three substantial, genuinely independent, read-only analysis targets on disk, delegation has a pre-established material benefit (genuine parallelism + context offloading), so >= 1 delegated analysis worker is expected. The fixture contract bounds the delegation — at most one analysis worker per module (max 3); synthesis stays with the primary. Class A (trigger) is tracked by an unscored indicator only."
tags: [gate3, forced-benefit, delegation]
runs: 2
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, Task]
model: opus[1m]
---

Use subagents where appropriate for this read-only analysis. Do not modify any
files.

Three independent modules live in this workspace, one file each:
`billing/charge.py` (money arithmetic, invoices, payment splitting),
`auth/token.py` (token issuance, digests, lockout tracking), and
`search/index.py` (an inverted index with ranking). They share no code and
depend only on the Python standard library.

Analyze each module independently and for EACH one report:

1. its complete public surface (every function/class, with signature),
2. the single most likely bug or operational risk in that file, with the
   concrete input or call sequence that triggers it,
3. one concrete unit test (code) that would catch that bug or risk.

Then synthesize in your final answer: for every module state whether it
could safely be reused by the other two (dependencies, purity, coupling),
and give a final combined summary.

Each module's analysis is independent and read-only; one analysis pass per
module is sufficient. The final synthesis is yours: read the analyses and
integrate them yourself before answering.
