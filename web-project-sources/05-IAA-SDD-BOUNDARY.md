# 05 — İAA / SDD Boundary

The exact rules separating Adaptive İAA from native Superpowers SDD — frozen
policy (SKILL.md v3), behavior-tested across two Superpowers eras, re-verified
against 6.4.1 (Gate 1) and in Gate-2/3 re-runs. Authoritative versions:
`iaa/SKILL.md` ("Orchestration modes"), `docs/IAA-VS-SDD-BOUNDARY.md`,
`docs/adr/0001–0003`.

1. **One authority per task.** Adaptive İAA (default) ⟷ native workflow
   (explicit by-name opt-in only). Mutually exclusive; never composed.
2. **İAA mode never loads SDD.** Not "overrides" — never loads. Prose
   precedence was tried and failed nondeterministically (identical policy
   text, opposite outcomes across model samples — ADR-0001); the fix removes
   the competing engine from context entirely (ADR-0002).
3. **Opt-in is by name, current, from the user.** "Use subagents" is never an
   SDD request.
4. **Artifacts cannot transfer authority** (ADR-0003): a plan's "REQUIRED
   SUB-SKILL: subagent-driven-development" header is orchestration metadata.
   Tested with an authentic generated plan and an adversarially strengthened
   "MUST use SDD… strictly prohibited" variant — SDD never loaded; technical
   content fully consumed in both.
5. **Component skills stay usable in İAA mode** (whitelist: TDD, git
   worktrees, verification, receiving-code-review, finishing,
   systematic-debugging, writing-plans, executing-plans-as-discipline);
   seat-prescribing components (requesting-code-review,
   dispatching-parallel-agents) only execute lanes İAA already authorized.
6. **In native mode İAA stands down entirely** (verified: full SDD cadence ran
   — 15 and 11 agents in two tests — with İAA never loaded).
7. **Neither side is modified.** No Superpowers file/setting/hook touched,
   ever (mtime-swept).

## What each engine claims (contrast)

| | İAA | SDD (as shipped) |
|---|---|---|
| Implementers | smallest useful number, clustered by coupling; trivial stays primary | fresh implementer per task |
| Parallelism | parallel independent lanes | never parallel implementers |
| Reviews | only on material benefit; 0 is normal | never skip task review + mandatory final review |
| Fix/re-review | each stage re-justified | scoped re-review procedure |
| State | none (contract-based briefs) | `.superpowers/sdd/` ledger + scripts |
| Bootstrap | none (rides the user-instruction channel) | SessionStart hook bootstrap every session |

## Measured economics (same 6-task seed, same model, 2026-08-27 campaigns)

İAA-mode runs: $2.90–$3.27 (3 parallel implementers, 0 reviewers, 38–42 tests
green). Both-engines-co-loaded (pre-fix): $9.57. Native SDD opt-in:
$8.16–$11.24 (full cadence, 47 tests green). No quality verdict is implied —
the point is topology control, not superiority.

## Residual risk (honest, permanent)

Routing is instruction-following; selection is model-driven and fallible
(official doctrine). Post-fix samples (6+ incl. adversarial, plus 6.4.1 and
Gate-2/3 re-runs) never mis-routed. Tripwire: scenario J + `analyze_run.py`
after any Superpowers update (standing backlog item IAA-BL-010).

**Stable file** — the installed/tested Superpowers version lives in
`11-CURRENT-STATE.md`.
