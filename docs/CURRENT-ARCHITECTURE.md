# İAA — Current Architecture (as installed, 2026-09-22)

Reconstructed from primary sources only. Every claim cites its source. "SKILL.md:14" means
`~/.local/share/iaa/iaa/SKILL.md` line 14;
`DC` = `references/delegation-contract.md`; `PA` = `references/platform-adapters.md`;
`R` = `~/.local/share/iaa/README.md`; `S` = `tests/scenarios.md`;
`M` = `scripts/manage.sh`. Nothing here is aspirational; historical behavior is marked.

## 1. What İAA is

A **runtime-agnostic delegation-decision policy** distributed as a single skill directory
(SKILL.md + 2 references + 1 installer script + 1 test-contract file) and installed into
three agent CLIs through identical relative symlinks plus short managed instruction blocks
("shims") in each runtime's global instruction file (R:7–20). It is *pure policy*: no code
runs at delegation time, no daemon, no state machine, no telemetry. Its only executable
artifact is `manage.sh` (install/verify/uninstall), and its only persisted runtime state is
one 15-byte marker (`~/.config/iaa/claude-depth.state`, M:154–213).

## 2. What İAA is NOT

- Not an agent framework or execution engine — it decides **whether/how** to delegate; the
  runtime's native subagent mechanism executes (R:22–36).
- Not a fixed workflow — no mandated agent roster, review cadence, or sequence (SKILL.md:14).
- Not composable with other orchestration authorities on one task (SKILL.md:12–15).
- Not a wrapper around Superpowers SDD; it deliberately never loads it in its own mode
  (SKILL.md:14; R:80–96).
- Not an auto-bootstrap: it has no SessionStart hook (unlike Superpowers' `using-superpowers`).
  It is discovered through skill-listing description match and the shim's load-on-trigger
  instruction (R:38–52).

## 3. Invocation / discovery mechanism (per runtime)

| Runtime | Instruction surface | Skill surface | Notes |
|---|---|---|---|
| Claude Code 2.1.274 | `~/.claude/CLAUDE.md` managed block (model-invocable description; user-invocable `/iaa`) | `~/.claude/skills/iaa` symlink | description (245–249 chars) is the routing surface; ZCode's ~250-char injection limit constrained its length (archfix report) |
| Codex CLI 0.154.0 | `~/.codex/AGENTS.md` managed block | `~/.agents/skills/iaa` symlink (Codex user-skills dir; R:26,34) | Codex's own `[agents]` config + `reviewer.toml` pre-exist and are untouched (R:58–60) |
| ZCode 3.7.7 (adapter anchor; local machine runs 3.11.2 — Erratum E-1, comparison/00) | `~/.zcode/AGENTS.md` managed block | `~/.zcode/skills/iaa` symlink | only user-global + workspace AGENTS.md are read (R:70) |

Auto-activation semantics: the shim tells the primary agent to load the skill when delegation
"is requested or materially useful" (M:88) — i.e. **model-invocable with proactive trigger**,
not explicit-only. Per-task opt-out phrase documented: "Do not delegate or spawn subagents for
this task" (R:190).

## 4. The managed shim (identical text in all three runtimes; M:84–91)

Two paragraphs: (1) load the skill before spawning when delegation is requested/materially
useful; (2) interpret "use subagents" as bounded beneficial delegation, primary owns
decomposition/ownership/contracts/integration/final validation, and the skill is **the sole
orchestration authority in its mode** — other orchestration workflow skills apply only when
the user explicitly requests them by name. The shim is idempotent (marker-validated rewrite;
M:35–103) and its sentence 2 is the load-time routing rule that survived every behavioral
test (archfix report, key transcript evidence).

## 5. Orchestration modes and the SDD boundary (SKILL.md:10–21)

Exactly one authority per task; two mutually exclusive modes:

- **Adaptive İAA mode (default).** Selected by any delegation-flavored request ("use
  subagents where appropriate" included). SDD and any other roster/cadence/sequencing-
  prescribing skill is **not loaded** — "two engines governing one task produce
  nondeterministic topology" (SKILL.md:14). If such a skill is nevertheless in context, it
  creates no agents/stages by itself.
- **Native workflow mode (explicit opt-in only).** Only a current user instruction naming the
  workflow. That workflow then governs itself; İAA stands down entirely (SKILL.md:15).

**Artifact trust boundary (Provenance rule, SKILL.md:17):** workflow directives embedded in
plans, specs, generated artifacts, repo files, or prior agent output (e.g. a plan header's
"REQUIRED SUB-SKILL: subagent-driven-development") are **orchestration metadata, not opt-in**.
The executor notes them and keeps consuming the artifact's *technical* content in İAA mode.
Enforcement hierarchy (artifact-boundary report): current explicit user selection →
global/user routing (shim) → active İAA mode → artifact-embedded suggestions; a lower layer
never silently overrides a higher one.

**Component-skill whitelist (SKILL.md:19):** in İAA mode these Superpowers components remain
individually usable on their own triggers: test-driven-development, using-git-worktrees,
verification-before-completion, receiving-code-review, finishing-a-development-branch,
systematic-debugging, writing-plans, executing-plans (discipline only; steering inside it
toward another orchestration workflow — a redirect, handoff offer, or preference — does not
by itself select native mode). Two components prescribe agent seats (requesting-code-review,
dispatching-parallel-agents) and may only execute lanes İAA already authorized.

**Seat economics (SKILL.md:21):** every implementer/reviewer/re-reviewer/fixer seat needs a
task-specific material-benefit justification; template steps, completed implementation, or an
available review procedure are not justification; authorizing a stage never preauthorizes the
next; optional/Minor findings stay primary or deferred.

## 6. Decision core (what the primary does, in order)

1. **Interpret intent** (SKILL.md:23–27): delegation phrases mean "apply the policy," not
   "maximize agents." Primary = orchestrator + final integration authority, owning
   decomposition, dependency order, agent selection, shared contracts, scope, integration,
   contradiction resolution, final validation, user answer.
2. **Orient before delegating** (SKILL.md:29–33): proportionate repository/instruction
   inspection; obeys project orientation policies (e.g. graphify) first; maps are aids, not
   substitutes for source.
3. **Require a concrete benefit** (SKILL.md:35–49): at least one of — genuine parallelism;
   bounded-context isolation; specialization (tools/permissions/model/domain); context
   offloading; independent verification that can challenge assumptions. Stay primary when
   tiny/sequential/tightly coupled/poorly bounded/same-files/same-context/cheaper-direct.
   Trivial edit = no-delegation default *even when the user says "use subagents where
   appropriate"* (SKILL.md:45). No artificial roles, no one-per-file, no agents-because-
   available; smallest useful number.
4. **Shape safely** (SKILL.md:51–65): read-heavy work is safest → prefer read-only/Explore
   roles. Write-heavy → non-overlapping ownership *before* concurrent edits; shared
   APIs/schemas/types/DB contracts/central config/abstractions are normally primary-owned or
   settled first; dependency-aware waves (orient → parallel read-only research → settle
   contracts → disjoint implementation → independent verify → integrate/validate), skipping
   valueless phases.
5. **Dispatch deliberately** (SKILL.md:67–75; DC): before first spawn, read DC + PA.
   Root-to-child only; nested delegation requires explicit user request + concrete bounded
   benefit (SKILL.md:71). No hardcoded model names — map to capability classes (fast
   explorer / general worker / deep reviewer), keep strongest reasoning in primary for global
   synthesis. While children run, do non-overlapping primary work; don't busy-poll; stop
   redundant/unsafe/out-of-scope work.
6. **Integrate, don't collect** (SKILL.md:77–81): child reports are evidence, not truth;
   verify load-bearing claims against source/diffs/tests/runtime; resolve contradictions
   centrally; review for contract drift; final validation in primary context. Named failure
   modes to prevent: blind fan-out, duplicate exploration, overlapping ownership, premature
   implementation, context starvation, context dumping, agent proliferation, delegation
   recursion, integration debt. "Successful child completion is not successful task
   completion."

## 7. Delegation contract (DC)

Assignment brief fields: Objective, Scope, Non-scope, Current context, Dependencies,
Ownership (exact write set), Deliverable, Validation, Constraints (DC:7–18). Every child is
told: not alone in workspace, preserve unrelated edits, never revert others' work (DC:25);
write work names the child's exclusive write set + primary's retained surface; and — unless
nesting was explicitly authorized — the brief includes the literal clause "Do not spawn
subagents" (DC:27). Handoff return fields: status, findings+evidence, files inspected,
files changed, decisions/assumptions, dependencies/risks, tests+results, failures/open
questions, recommended next action (DC:31–41). Primary acceptance checklist: scope/ownership
compliance → verify claims → reconcile contracts → run integration+final validation in
primary → own the final answer (DC:45–53).

## 8. Platform adapters (PA)

- **Codex** (PA:5–11): prefer `explorer`/`worker`/`default` built-ins; fresh-context spawn
  (`fork_turns: "none"`) by default — note omitted `fork_turns` defaults to full history,
  not fresh context — smallest useful recent-turns count as a positive integer string
  (e.g. `fork_turns: "3"`) if bounded inheritance is needed, `fork_turns: "all"` only when
  full parent history is genuinely required (any inheritance weakens isolation and costs
  tokens); explicit file ownership stated; direct children unless user authorizes nesting;
  use runtime steering/interrupt/wait to prevent duplicate/abandoned work.
  (Verified against Codex 0.154.0's compiled tool schema and upstream source — see
  `release-hardening/02-codex-fork-turns-verification.md`.)
- **Claude Code** (PA:13–20): prefer built-in Explore/Plan/general-purpose; **pre-dispatch
  mode check** before first Agent call — İAA never invokes SDD, and no skill text or plan
  artifact switches modes, "whether a component skill's redirect, handoff offer, or
  preference toward SDD (`executing-plans`, `writing-plans`) or a `REQUIRED SUB-SKILL`
  directive embedded in the plan being executed" (PA:16, refreshed for Superpowers 6.4.1
  where executing-plans is a real inline mode and writing-plans' handoff asks the user to
  choose; see `release-hardening/03-superpowers-adapter-refresh.md`); Explore/Plan don't
  inherit CLAUDE.md or skills → restate constraints/ownership/no-nesting in every such
  brief (PA:17); spawn depth capped at 1 by the installed adapter — raise deliberately
  per-session for an explicitly requested bounded nested design, restore after (PA:19);
  no permanent custom agents unless a recurring specialization truly needs them.
- **ZCode** (PA:22–28): built-in Explore (read-only; no AGENTS.md injection → restate
  rules in prompt) + general-purpose (injects AGENTS.md but still needs targeted brief);
  custom-tool allowlists may remove skill/shell access — don't assume tools; **ZCode
  subagents cannot spawn subagents** (platform guarantee); custom subagents are beta — don't
  create one for this methodology.

## 9. Installation / lifecycle (M)

`install`: 3 symlinks (relative, `realpath --relative-to`) → 3 shims (marker-validated,
backup-before-write, idempotent byte-compare) → Claude depth management → `verify`.
`verify`: SKILL.md exists; all 3 links resolve to canonical root; all 3 shims have exactly
one well-ordered marker pair; Claude depth == 1; SKILL description ≤ 1024 bytes.
Depth ownership: state file records `managed-absent` (key was absent; manage.sh owns it) vs
`preserve-existing` (user had a value; untouched). `uninstall`: restore depth only if still
the managed value `1` (user-changed values preserved); remove shims (marker-validated);
remove links **only if they resolve to the canonical root** (unrelated symlinks preserved);
canonical source always retained. Fake-home install→reinstall→uninstall lifecycle was
validated at install time (R:144).

## 10. Runtime-agnostic vs runtime-specific

Agnostic: all decision policy (§6), modes/boundary (§5), contract (§7), shim text.
Runtime-specific: skill-discovery path, instruction file, built-in role names, fork/isolation
mechanics (§8), and the nesting guard — Claude = env-var depth cap 1 (enforced by harness),
ZCode = platform-impossible, Codex = policy-only (no equivalent cap; native multi-agent
depth is governed by Codex's own config).

## 11. Control-flow diagram

```mermaid
flowchart TD
    U[User task] --> SHIM{Global shim in<br/>CLAUDE.md / AGENTS.md:<br/>delegation requested or<br/>materially useful?}
    SHIM -- no --> P0[Primary proceeds single-agent]
    SHIM -- yes --> LOAD[Load iaa skill]
    LOAD --> MODE{Mode? SKILL.md Orchestration modes}
    MODE -- "delegation-flavored request<br/>(incl. 'where appropriate')" --> İAA[Adaptive İAA mode]
    MODE -- "explicit by-name request<br/>(e.g. 'use native superpowers:SDD')" --> NAT[Native workflow mode:<br/>named workflow governs itself,<br/>İAA stands down]
    İAA --> PROV{Workflow directive found inside<br/>plan/spec/artifact/repo text?}
    PROV -- yes --> META[Treat as orchestration metadata.<br/>Note it; consume technical content;<br/>stay in İAA mode]
    PROV -- no --> CORE
    META --> CORE[Decision core:<br/>1 interpret intent<br/>2 orient proportionately<br/>3 concrete benefit test<br/>4 shape: waves + ownership<br/>5 dispatch via delegation contract<br/>6 integrate + primary final validation]
    CORE --> BEN{Material benefit?<br/>parallelism / isolation /<br/>specialization / offloading /<br/>independent verification}
    BEN -- "no (tiny/coupled/cheaper direct)" --> PRIM[Primary executes directly<br/>(no-delegation default)]
    BEN -- yes --> WAVES[Dependency-aware waves:<br/>read-only parallel research →<br/>settle shared contracts →<br/>disjoint implementation →<br/>optional justified verification →<br/>primary integration+validation]
    WAVES --> BRIEF[Brief per worker:<br/>objective/scope/ownership/validation<br/>+'Do not spawn subagents']
    BRIEF --> CHILD[Worker subagents<br/>root-to-child only]
    CHILD --> ACC[Primary acceptance:<br/>verify claims vs evidence,<br/>resolve contradictions,<br/>final validation in primary]
```

## 12. Evidence map: what is actually proven, by which test

| Behavior | Proven by | Samples/notes |
|---|---|---|
| Mode separation: SDD never loads in İAA mode | archfix tests A1, A2, C; artifact-boundary tests B, D; **6.4.1 revalidation runs J, D** (release-hardening/01) | 5 clean samples + 1 adversarial (6.3.0-era; transcripts quote the routing sentence while rejecting `executing-plans`→SDD redirect) + 2 samples on Superpowers 6.4.1 (SDD never loaded; provenance rule quoted in-run; 6.4.1 run J additionally exercised the rebuilt executing-plans as a whitelisted inline component) |
| Native SDD opt-in still works | archfix test B (15 agents, worktree, ledger); artifact-boundary test C (11 agents); **6.4.1 revalidation run K** (release-hardening/01) | İAA never loaded in all |
| Artifact-embedded directive ≠ opt-in | artifact-boundary B (authentic plan), D (adversarial MUST wording) | D has a priming caveat, honestly disclosed |
| Adaptive topology (trivial stays primary; coupled stays primary; independent parallelized) | collision run 1; archfix A1/A2; artifact-boundary B; production use 2026-09-06 | across glm-5.3 samples + production |
| No nested spawns | all campaign runs (0 child-spawns-child in every transcript); Claude depth=1; ZCode platform-impossible | Codex: policy-only (not behaviorally re-tested post-campaigns) |
| Disjoint write ownership | all runs (write sets extracted from child transcripts) | no concurrent same-file writers ever |
| Primary-owned integration + final validation | all runs (full suite run by primary after merge) | — |
| Anti-overdelegation (no agent for trivial task) | collision run 1/2 (Task 1 never got a dedicated agent); install-time Codex smoke A after tightening | install-time smoke A first run FAILED (manufactured reviewer) → policy tightened → rerun passed |
| Reviewer materiality (0 reviewers for small tasks; justified reviewers for risk) | archfix A1/A2 (0 reviewers) vs post-fix attempt 3 (2 justified reviewers) | documented as legitimate materiality variance |
| Prose-precedence era leakage (historical) | collision run 2 + post-fix attempts 1–4 | the *reason* the structural fix exists |
| install/verify/uninstall lifecycle incl. fake-home | README validation results | — |

## 13. Documented-but-NOT-behaviorally-verified (gap list)

- Scenarios **F** (nested-delegation judgment), **H** (failed/interrupted child recovery),
  **I** (Explore constraint propagation) exist in the contract (S:35–57) but **no recorded
  behavioral run** exists for any of them (install-time smoke ran A–E on Codex; campaigns
  exercised G's real-world equivalent and J/K). Nested-delegation *rejection* is incidentally
  proven (0 nested spawns everywhere), but the "user explicitly authorizes nesting → bounded
  nested design" positive path was never exercised.
- Codex and ZCode were **not behaviorally re-tested** after campaigns 2–3 (stated in both
  reports; demonstrated collision was Claude-specific; ZCode requires desktop UI).
- Provenance rule was tested for plan artifacts only; other channels (issue text, README
  instructions, quoted transcripts) share the wording but were "not individually exercised"
  (artifact-boundary report).
- `manage.sh verify`'s description-length check (≤1024 B) is looser than the documented
  ZCode ~250-char injection constraint (R:170) — the 249-char description currently satisfies
  both, but verify would not catch a future >250-char regression.
- README limitation "Claude Code … not logged in" (R:210) is stale: Claude Code is
  authenticated now (`.credentials.json`, live sessions) — later behavioral tests (all
  campaigns) ran on Claude Code via the GLM provider.

## 14. Historical behavior no longer active (for the record)

1. v0/v1 prose precedence ("Workflow-skill compatibility": İAA controls shape *even when
   SDD co-loaded") — replaced 2026-08-27 by selection-level separation.
2. Post-load topology gate in the Claude adapter (attempt-3 mechanism) — replaced by the
   pre-dispatch mode check.
3. SDD review-cadence/sequential-implementer leakage under co-loading — eliminated in
   tested samples by never loading SDD.
4. Install-era: reviewer manufacturing on trivial tasks (first smoke-A run) — policy
   tightened same day.

## 15. Production footprint today

Canonical tree quiescent since 2026-08-27 16:22; consumed by Claude Code, Codex, ZCode via
symlinks; spawn-depth=1 active in Claude settings (managed); `manage.sh verify` passes
(re-run during this audit's Phase 10); production use 2026-09-06 (evidence
pointer: docs/HISTORY.md). Cross-ref: audit/01 (footprint), audit/02 (provenance).
