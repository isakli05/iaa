# 05 — MAO / SDD Boundary

The exact current rules (SKILL.md v3), all behavior-tested 2026-08-27:

1. **One authority per task.** Adaptive MAO (default) ⟷ native workflow (explicit by-name
   opt-in only). Mutually exclusive; never composed.
2. **MAO mode never loads SDD.** Not "overrides" — never loads. (Prose precedence was tried
   and *failed nondeterministically*: identical policy text, opposite outcomes across model
   samples, including a ledger preauthorizing "Task reviewers ×5" with the explicitly
   forbidden rationale. Fix = remove the competing engine from context entirely.)
3. **Opt-in is by name, current, from the user.** "Use subagents" is never an SDD request.
4. **Artifacts cannot transfer authority.** A plan's "REQUIRED SUB-SKILL:
   subagent-driven-development" header (which Superpowers' writing-plans embeds in every
   generated plan) is orchestration metadata. Tested with an authentic generated plan and
   an adversarially strengthened "MUST use SDD… strictly prohibited" variant — SDD never
   loaded; technical plan content fully consumed in both.
5. **Component skills stay usable in MAO mode** (whitelist: TDD, git-worktrees,
   verification, receiving-code-review, finishing, systematic-debugging, writing-plans,
   executing-plans-as-discipline). Seat-prescribing components (requesting-code-review,
   dispatching-parallel-agents) only execute lanes MAO already authorized.
6. **In native mode MAO stands down entirely** (verified: full SDD cadence ran — 15 and 11
   agents in two tests — with MAO never loaded).
7. **Neither side modified.** No Superpowers file/setting/hook touched, ever (mtime-swept).

## What each engine claims (contrast table)

| | MAO | SDD 6.3.0 (as installed) |
|---|---|---|
| Implementers | smallest useful number, clustered by coupling; trivial stays primary | fresh implementer per task |
| Parallelism | parallel independent lanes | "never dispatch multiple implementation subagents in parallel" |
| Reviews | only on material benefit; 0 is normal | "never skip the task review" + mandatory final whole-branch review |
| Fix/re-review | each stage re-justified | scoped re-review procedure |
| State | none (contract-based briefs) | `.superpowers/sdd/` ledger + scripts |
| Bootstrap | none (rides user-instruction channel) | SessionStart hook injects skill-first bootstrap every session |

## Measured economics (same 6-task seed, same model)

MAO-mode runs: $2.90–$3.27, 3 parallel implementers, 0 reviewers, 38–42 tests green.
Both-engines-co-loaded (pre-fix): $9.57, 9 agents, sequential, 6 review dispatches.
Native SDD opt-in: $8.16–$11.24, 11–15 agents, full cadence, 47 tests green.
(No quality verdict is implied — different valid choices; the point is topology control.)

## Residual risk (honest)

Routing is instruction-following; Claude Code docs say selection is model-driven and
fallible and prose is "a request, not a guarantee." Post-fix samples (6+, incl. adversarial)
never mis-routed; scenario J + a transcript analyzer exist as the regression tripwire after
any Superpowers upgrade.
