# Comparison 02 — Policy-level vs Runtime-enforced Orchestration

Date: 2026-09-22. İAA's central design trade-off, analyzed against what current systems
actually enforce, by mechanism, per assertion. No recommendation that "stronger is better"
is assumed; the analysis buys-and-costs both directions.

## 1. The enforcement spectrum, populated by current systems

| Grade | Mechanism | Who uses it today (evidence) |
|---|---|---|
| 0 — prose policy | instruction text only | **İAA** (SKILL.md + shim + brief clauses); BMAD (in-skill guardrails only; no hooks — stream-bmad §5); Codex Responses-API dev-message templates ("Do not spawn subagents unless…") |
| 1 — context injection pressure | SessionStart/bootstrap injection | Superpowers (`using-superpowers` full-text injection on startup\|clear\|compact, sync — stream-superpowers §4); GSD opt-in session-state injection (STATE.md head, `hooks.community: true`) |
| 2 — listing/trigger controls | description budgets, implicit-invocation flags, skillOverrides, disable | platforms themselves: Codex `allow_implicit_invocation: false` + `[[skills.config]] enabled=false`; Claude `disable-model-invocation`, `skillOverrides` (4 states; **not** plugin skills); ZCode per-skill disable (no implicit-disable flag); audit-council locally uses `disable-model-invocation: true` |
| 3 — selective hard guards | PreToolUse block/exit-2 on specific hazards | **GSD 1.14.0**: agent-isolation guard (hard-blocks `gsd-executor` dispatch without worktree isolation — GSD projects only), worktree-path guard (blocks out-of-worktree writes in GSD worktrees), secret-read guard (blocks `.env`/`.secrets` reads unconditionally), workflow guard's single hard block (`git add -f` on agent branches); crash policy explicit per hook (ALLOW/DENY) |
| 4 — platform invariants | harness-enforced, cannot be turned off | Claude worktree checks ("You can't turn this check off"); Claude `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` (İAA's managed cap = 1); ZCode "a subagent cannot spawn subagents of its own"; concurrent caps (20 subagents / 16 workflow agents); Claude plugin-eval OS sandbox |
| 5 — deterministic engines | the orchestration IS code | Claude dynamic workflows (script decides; deterministic resume); ZCode 3.14 dynamic workflows (TypeScript compiled to workflow graph, purity compile-enforced, journal replay); Codex Responses-API hosted multi-agent |

## 2. What İAA actually asserts, and each assertion's real enforcement grade

| İAA assertion | Grade today | Could be raised by | Cost of raising |
|---|---|---|---|
| Mode routing: "İAA never loads SDD in its own mode" | 0 (prose; description + shim + adapter check). Empirically strong: 6+ samples incl. adversarial; transcripts quote the shim sentence. Doctrinally **not guaranteed** (Claude docs: conflicts resolve by model judgment; "a request, not a guarantee") | grade 2: `disable-model-invocation` on *foreign* skills is impossible (not İAA's to set; Claude `skillOverrides` explicitly excludes plugin skills — official); grade 3: a PreToolUse guard on `Skill` tool blocking `superpowers:subagent-driven-development` unless a session flag is set | destroys İAA's non-invasiveness principle (C11/P7: never configure another framework); brittle vs plugin updates; per-runtime code |
| No nesting (root-to-child only) | 4 on Claude (managed env cap), 4 on ZCode (platform-impossible), **0 on Codex** (policy-only; `agents.max_depth` issue-documented as ignored by V2 + open enforcement bugs #46704/#32027 — stream-codex §4) | Codex: none available today (no hook surface for spawn control documented) | n/a — the gap is upstream |
| Artifact boundary (directives are metadata) | 0 (prose; adversarially tested once, plan channel) | grade 3 analog: GSD-style read-injection scanner (advisory/blocking) — different semantics (İAA must *consume* the artifact while ignoring its directives; a scanner can't make that distinction mechanically) | would change semantics; per-runtime code; false positives on legitimate plan text |
| Write ownership (exclusive write sets) | 0 + brief discipline (PROVEN zero overlaps empirically) | grade 3/5: GSD's wave file-overlap partitioner + scope validation; worktree isolation per write lane (platform grade 4 exists: `isolation: worktree`) | İAA's mixed-execution pattern (H3) would need per-lane worktrees — heavier, and shared-contract settlement gets harder, not easier |
| No modification of other frameworks | **enforced by construction** (installer only writes marker-owned artifacts; mtime-swept PROVEN) | already maximal for İAA's threat model | — |
| Benefit gate / seat materiality / integration ownership | 0 (pure judgment policy — the product itself) | cannot be mechanized without becoming a workflow engine (grade 5), which is a different product | category change; not a "raise" |

**Key structural finding:** orchestration *authority* (which policy governs a task) is not
a platform-enforceable unit today. Platforms enforce tool calls, files, and spawn
topology; no hook event says "which controller owns this task." GSD — the strongest
enforcement culture surveyed — does **not** enforce its own workflow authority by hooks
either: its guards allow foreign dispatches silently (`EXECUTOR_SUBAGENT_TYPES` is the
one-element set `{gsd-executor}`; workflow guard advisory + default-off). In other words,
**every system in this comparison, including the hook-heaviest, polices invariants, not
authority.** Authority is contested only at the model's selection step — exactly where İAA
chose to fight (selection-time routing), and where no competitor reciprocates.

## 3. What prose buys İAA (evidenced)

1. **Portability:** identical policy runs on Claude/Codex/ZCode today (C40 PROVEN). Hooks
   exist on Claude (33 events) and ZCode plugins (7 events incl. SessionStart) but are
   per-runtime code with per-runtime semantics; Codex hook surface for plugins is
   documented only as "lifecycle hooks" without a comparable guard API. A guarded İAA is
   three codebases.
2. **Zero trust surface:** no code executes at delegation time. Platform doctrine:
   plugins are "highly trusted components that can execute arbitrary code"; even
   `claude plugin eval` "says nothing about whether the plugin is safe." A prose skill is
   auditable by reading it — İAA's entire attack surface is its installer (POSIX sh,
   marker-delimited, fake-home-validated).
3. **Composability with mechanisms:** policy rides any spawn mechanism (it used Codex V2,
   Claude subagents, ZCode subagents unchanged through 6 releases / 2 minors / 6 minors of
   platform drift respectively — integrations re-verified against docs 2026-09-22, with
   the E-2 fork_turns exception).
4. **Model-judgment as a feature:** the benefit gate *is* judgment; hard-coding it would
   fix topology at design time and re-create the fixed-cadence problem İAA exists to avoid
   (SDD's "never parallel implementers" is what deterministic process rules look like).
5. **Cheap variance observability:** failures are visible routing events (ADR-0002), not
   silent hook bypasses — and regression-testable by one scenario (J) + analyzer.

## 4. What prose costs İAA (evidenced)

1. **Sample variance is real and demonstrated** — ADR-0001: identical policy text, opposite
   outcomes across samples under co-loading. The fix (selection-time exclusion) reduced,
   not eliminated, reliance on instruction-following: the routing sentence itself is still
   prose. Residual risk is documented, visible, regression-testable — but nonzero.
2. **No doctrinal guarantee** — current Claude docs explicitly do NOT promise instruction
   precedence over skills (stream-claude §9c); İAA's routing rests on (a) empirical
   strength, (b) Superpowers' own bootstrap concession (verbatim intact at 6.4.1), and (c)
   description-level routing. Any of the three can drift silently.
3. **No observability surface** — no ledger/trace; post-hoc "what did İAA decide and why"
   requires transcript analysis (analyze_run.py). Superpowers ships
   diagnosing-superpowers (path:line-cited session forensics) and GSD ships /gsd-forensics
   + /gsd-stats; İAA's diagnostic story is a proposal (iaa doctor) + a scenario contract.
4. **No state continuity** — SDD's ledger exists because "controllers that lost their
   place have re-dispatched entire completed task sequences — the single most expensive
   failure observed" (SDD's own words); GSD state "survives context resets". İAA has no
   answer for the compaction-respawn failure class beyond the primary-agent contract.
5. **Upgrade fragility** — one-directional knowledge (İAA knows Superpowers; not vice
   versa); upstream changes re-open the contest until scenario J re-runs (upgrade-check is
   due: local 6.3.0 vs 6.4.1). Adapter text has already drifted twice (E-2 fork_turns;
   executing-plans redirect removed upstream in 6.4.1).

## 5. What enforcement buys others (and what it costs them) — the two-way street

**GSD (grades 1+3):** deterministic invariants (secrets never read; executors never
commit to the primary checkout; wave scope validated). Costs visible in their own
engineering: explicit per-hook crash policies (ALLOW/DENY), fail-open vs fail-closed
tuning across four releases (1.10→1.14: "fail closed when a worktree guard cannot verify
safety", "no longer fails open under CI/process load", "Blocking guards no longer silently
disable themselves when the host stalls"), a 23-file managed-hook registry with staleness
checks, node ≥24 requirement, and guard activation gated on `.planning/config.json`
presence (i.e., **enforcement scoped to GSD projects — GSD itself chose not to police
foreign sessions**). Lesson: even maximalist enforcement gets scoped down to where it's
unambiguous.
**Superpowers (grade 1):** injection buys attention, not compliance — its own text
concedes user instructions outrank skills, and its bootstrap runs *in every session
including İAA-governed ones* without seizing control (this comparison session is a live
example). Cost: context spend per session; no enforcement of its "mandatory workflows."
**Native engines (grades 4–5):** determinism (workflow resume, worktree invariants) at the
price of becoming an explicit opt-in artifact — the platform's own doctrine pushes
deterministic behavior into hooks/workflows and leaves prose for judgment. ZCode/Claude
dynamic workflows are İAA's topology decisions compiled into scripts — a different point
on the same axis, chosen explicitly by the user per task.

## 6. Conclusion (analysis, not verdict)

İAA's prose-only stance is not an oversight — it is the only grade at which *authority*
(the thing İAA is about) can be expressed portably today, because platforms do not offer
an authority API. Every mechanism upgrade available to İAA either (a) polices a different
thing (files, secrets, worktrees — already platform invariants or GSD's beat), (b) breaks
non-invasiveness (guarding foreign skills), or (c) turns İAA into a workflow engine
(different product). The genuine, cheap enforcement wins available are grade-2 *self*
controls (trigger discipline — already practiced via description engineering) and
grade-1/3 *reporting* (a SessionStart context-append or SubagentStop observer that logs,
never blocks — the iaa-doctor direction), which raise observability, not authority. The
one hard gap with no prose answer is Codex nesting (grade 0, upstream-broken max_depth) —
worth an experiment (07-E9), not a redesign.

Where İAA is genuinely behind on this axis is not enforcement but **instrumentation**:
ledger/forensics (SDD, GSD) and behavioral evals (Superpowers Quorum; Claude plugin eval
exists as of 2.1.269 with `tool_used: Skill` graders and with/without plugin arms — a
near-perfect harness for İAA's scenario J). Those are additive and do not violate the
non-invasive principle — see 06-gap-analysis and 07-experiment-plan.
