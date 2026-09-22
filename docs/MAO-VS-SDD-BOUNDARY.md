# MAO vs SDD Boundary (current, tested)

The exact rules that separate Adaptive MAO from native Superpowers SDD, frozen as of
2026-08-27 (SKILL.md v3). This is the boundary the evidence campaigns built; it is behavior-
tested, not aspirational. Companion: `docs/adr/0001–0003`, `docs/BEHAVIORAL-CONTRACT.md`.

## The two engines (what each claims)

| Dimension | MAO (adaptive) | superpowers:subagent-driven-development 6.3.0 |
|---|---|---|
| Selection | any delegation-flavored request, incl. "use subagents where appropriate" | only explicit by-name user request ("use native superpowers:subagent-driven-development") |
| Implementers | smallest useful number; clustering by coupling/shape; trivial stays primary | fresh implementer subagent per task |
| Parallelism | parallel independent lanes encouraged (disjoint ownership) | "Never dispatch multiple implementation subagents in parallel" |
| Reviews | reviewer only on task-specific material benefit (risk classes); 0 reviewers is normal for small work | "Never skip the task review" per task + mandatory final whole-branch review |
| Fix/re-review | each stage independently re-justified; optional/Minor stays primary/deferred | scoped re-review procedure after fixes |
| Nesting | root-to-child only; explicit authorization + bounded benefit otherwise | no-spawn implementer contract |
| Ledger/workspace | delegation contract (briefs/handoffs); no mandated workspace | `.superpowers/sdd/` ledger, task-brief/review-package scripts |
| Integration | primary always owns integration + final validation | controller owns briefs/review gates; per-task commits |

## The boundary rules (in force)

1. **One authority per task.** Modes are mutually exclusive (SKILL.md "Orchestration modes").
2. **MAO mode never loads SDD.** Not "overrides" — *never loads*. Selection-level exclusion,
   because proven prose precedence fails nondeterministically (ADR-0001).
3. **Opt-in is by name, current, and from the user.** "Use subagents" is never an SDD request.
4. **Artifacts cannot transfer authority** (ADR-0003): embedded "REQUIRED SUB-SKILL"/"MUST
   use SDD" directives in plans/specs/repo text are metadata; technical content still applies.
5. **Component skills stay usable** (whitelist: TDD, worktrees, verification, receiving/
   finishing, systematic-debugging, writing-plans, executing-plans-discipline); seat-
   prescribing components (requesting-code-review, dispatching-parallel-agents) only execute
   lanes MAO already authorized.
6. **In native mode, MAO stands down entirely** — no second authority on top of SDD.
7. **Neither side is modified.** No plugin file, setting, or hook of Superpowers is touched;
   MAO routes through its own surfaces only.

## Evidence status

- MAO mode keeps SDD out: 5 clean samples + 1 adversarial (archfix A1/A2/C; boundary B/D) —
  models verbatim rejected the `executing-plans`→SDD redirect citing the shim sentence.
- Native opt-in works: 2 samples (archfix B: 15 agents; boundary C: 11 agents), MAO absent.
- Historical leakage under co-loading (review cadence, sequential implementers, ~2.5× cost):
  campaigns 1/1b — the reason rules 2 and 4 exist.
- Upgrade tripwire: scenario J after any Superpowers update; re-check
  `executing-plans`/`writing-plans` for new SDD redirects (CANONICAL-README "Superpowers
  upgrade check").

## One asymmetry to keep in mind

Superpowers installs a synchronous SessionStart hook that injects its bootstrap into every
session; MAO installs no hook and relies on the user-instruction channel (CLAUDE.md/AGENTS.md),
which Superpowers' own bootstrap defers to. Claude Code's official doctrine is that prose is
"a request, not a guarantee" — enforcement-grade mechanisms are hooks/namespacing/suppression
flags (research/01 §6). The boundary is therefore behavioral-instruction-following with
strong evidence, not a harness guarantee; this is the documented residual risk (ADR-0002
"Remaining Limitations", docs/KNOWN-LIMITATIONS.md).
