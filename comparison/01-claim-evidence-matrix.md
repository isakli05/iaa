# Comparison 01 — Claim-Evidence Matrix

Date: 2026-09-22. Every MAO differentiator claim is tested as a falsifiable hypothesis
against **current** primary-source evidence for Superpowers 6.4.1, GSD Core 1.14.0, Claude
Code 2.1.280-docs, Codex 0.155.1-docs, ZCode 3.14.3-docs, and BMAD 6.12.0 (evidence:
`comparison/evidence/stream-*.md`; versions locked in `00-…version-lock.md`).

Classification scale: **CONFIRMED DIFFERENTIATOR / PARTIAL DIFFERENTIATOR / SHARED
CAPABILITY / OUTDATED DIFFERENTIATOR / NOT SUPPORTED / UNKNOWN.** Every classification
cites evidence. Category differences are stated before feature comparison (no false
equivalence): SDD = fixed-cadence execution workflow; GSD = full project methodology with
mechanism-grade guards; Claude/Codex/ZCode native = execution mechanisms + vendor guidance
(not policies); BMAD = product-development methodology with named personas; MAO =
delegation-decision policy layer.

---

## H1 — "MAO uniquely decides whether delegation is worthwhile before deciding how to delegate"

**MAO evidence:** SKILL.md benefit test (5 benefits vs coordination cost; C17/C18 PROVEN —
trivial tasks stay primary even when subagents were requested; campaign evidence).
Feature = the gate; fewer agents/cost/context pressure are consequences (see §F-vs-C below).

| System | Does it gate *whether* before *how*? | Evidence |
|---|---|---|
| Superpowers 6.4.1 | Partial, at mode level only: writing-plans handoff now offers "Subagent-driven vs Native with cost guidance" and the **user** chooses; executing-plans is a real inline alternative. Inside SDD there is no gate — selection *is* the decision; every task gets an implementer (batch exception for same-shape micro-edits). | stream-superpowers §3, §5, §6 [IMPLEMENTED] |
| GSD 1.14.0 | Coarse-grained: `--skip-research` "when the domain is already familiar"; 1.14.0 "Executor dispatches are no longer refused when a phase correctly degrades to sequential execution"; `/gsd-quick` escape lane. Phase-level process adaptation, not a per-delegation benefit test. | stream-gsd §2 [DOCUMENTED + RELEASE-NOTED] |
| Claude native | No policy. Vendor guidance approximates benefit heuristics ("A side task floods your conversation with output you won't reference again → Route it through a subagent"; teams "token cost higher"; workflow size guidance) — advisory tables, not a gate. | stream-claude §9 [DOCUMENTED] |
| Codex | **Policy templates shipped by the vendor**: subagents doc — "use parallel agents for read-heavy tasks… Be more careful with parallel write-heavy workflows… consume more tokens"; with Ultra, "ChatGPT can proactively delegate work when parallel agents would **materially improve speed or quality**"; Responses-API example dev-messages: "Do not spawn subagents unless the user explicitly asks…" / "Use subagents when parallel work would materially improve speed or quality." | stream-codex §6 [DOCUMENTED] |
| ZCode | No policy documented (per-turn description injection; subagents mechanism; dynamic workflows). | stream-zcode §6 |
| BMAD 6.12 | Component-level: bmad-build "Route to smallest safe path"; v6.12 "sizes ceremony to the change"; party-mode `auto` "spawns independent agents only when independence changes the answer." Benefit-shaped adaptivity inside specific components, not a general delegation gate. | stream-bmad §2, §3 [DOCUMENTED] |

**Verdict: PARTIAL DIFFERENTIATOR.** The *idea* of gating delegation on material benefit
is no longer rare: OpenAI ships it as a policy template ("materially improve speed or
quality") at the Ultra tier and in API guidance; BMAD and GSD implement benefit-shaped
adaptivity in components; Superpowers 6.4.1 moved the whether-delegate choice to the user
with cost guidance. Still differentiated: (a) MAO's benefit gate is the *core* of one
coherent policy rather than a guidance table, tier feature, or component; (b) the
five-benefit taxonomy + anti-overdelegation default ("0 agents is a normal outcome",
trivial stays primary even on explicit delegation-flavored requests) exists nowhere else
as policy; (c) MAO holds **behavioral evidence** that the gate works (campaigns: Task-1
class never delegated, 0-reviewer outcomes, install-time smoke A tightening) — no compared
system publishes behavioral evidence of an anti-overdelegation gate (Superpowers' Quorum
lab tests *skill compliance*, not delegation restraint; no public behavioral evidence
exists for Codex guidance templates).

## H2 — "MAO justifies each agent seat independently"

**MAO evidence:** SKILL.md:21 — every implementer/reviewer/re-reviewer/fixer seat requires
task-specific material-benefit justification; authorizing one stage never preauthorizes the
next; Minor/optional findings stay primary; 0 reviewers normal. C22/C25 PROVEN.

| System | Per-seat justification? | Evidence |
|---|---|---|
| SDD 6.4.1 | No — seats are structural ("Never skip the task review"; fresh implementer per task). Round-5 circuit breaker moves adjudication to the controller — a cap, not a materiality rule. | stream-superpowers §3 [IMPLEMENTED] |
| executing-plans 6.4.1 | One justified seat: the final fresh-context review is "the one fresh context the whole run buys. Do not skip it" — a single-seat rationale, not a per-seat rule. | stream-superpowers §6 |
| GSD 1.14.0 | No — fixed roles per phase with numeric caps (researchers ×4, plan-checker ≤3 iterations, dom-verifier 1/wave). Caps are counts, not benefit tests. `/gsd-ship` "runs no review automatically" (review opt-in) — a de-cadence stance, but verification is a mandatory loop step judged by the human. | stream-gsd §4, §6 [DOCUMENTED] |
| Claude native | No policy; teams sizing advice is capacity heuristics ("3-5 teammates", "5-6 tasks per teammate"). | stream-claude §5, §9 |
| Codex | Guidance covers spawn decisions generally ("independent tasks… keep short tasks and dependent steps in the main agent"), not per-seat review/fixer justification. | stream-codex §6 |
| BMAD 6.12 | Closest analog: review triage "logs a verdict per finding" (v6.12); repair loop halts at 5 iterations (non-convergence); review can "patch… send back… void… or defer". Per-*finding* verdicts, not per-*seat* justification; reviewer subagents are a mandatory build stage. | stream-bmad §2, §3, §5 |

**Verdict: CONFIRMED DIFFERENTIATOR** (as policy + evidence). The specific norm — each
seat (including reviewers and fixers) must earn its place per task, stages never
preauthorize successors, and "0 reviewers" is a sanctioned outcome — has no equivalent in
any compared system. Nearest neighbors (BMAD per-finding triage; GSD opt-in code review;
SDD round-5 adjudication) operate at different granularity and do not authorize *zero*
seats. Caveat: MAO's own evidence records legitimate reviewer-count variance (0 vs 2) —
the rule is a judgment policy, not a determinizer, by design.

## H3 — "MAO supports mixed primary + delegated execution without requiring a complete workflow transition"

**MAO evidence:** C23 PROVEN — primary keeps coupled/shared-contract work while workers
take independent lanes, in the same task, without switching modes (contrast: switching to
SDD = complete workflow transition).

| System | Mixed primary+worker execution? | Evidence |
|---|---|---|
| SDD | No — two pure modes: all-delegated (controller never implements: "Never fix findings yourself in the controller session") or all-inline (executing-plans). | stream-superpowers §3, §6 |
| GSD | Not as primary-implements: executors are always agents; "Sequential phase execution stays on the orchestrator's checkout" changes isolation, not who implements. | stream-gsd §2, §5 |
| Claude native | Trivially possible (no policy constrains it) — but with **no ownership protocol** beyond advice ("avoid same-file edits", "teams don't isolate teammates in worktrees, so partition the work"). | stream-claude §5, §9 |
| Codex | Verified in MAO's own native audit (root worked concurrently with children; ADR-0000). Again mechanism, not protocol. | ADR-0000 [PROVEN, local] |
| BMAD | **Yes, structurally**: bmad-build's primary implements; independent reviewer subagents verify (three lenses). Mixed execution is BMAD's standard shape — but reviewers are a mandatory stage, not materiality-gated seats. | stream-bmad §2, §3 |

**Verdict: SHARED CAPABILITY at the level of "mixed execution is possible" (native
trivial; BMAD standard), PARTIAL DIFFERENTIATOR at the level of *defined safe pattern*:
MAO couples mixed execution to an explicit write-ownership protocol (exclusive write sets,
primary-owned shared contracts — C26 PROVEN with zero concurrent same-file writers across
all runs).** Note the ownership mechanism comparison: GSD enforces scope mechanically
(wave file-overlap partitioner; "validate a wave branch's committed diff stays in its
declared scope", 1.11/1.13) — mechanistically *stronger* than MAO's brief-based prose,
though scoped to GSD-managed repos only.

## H4 — "MAO treats explicit orchestration ownership and artifact trust boundaries as first-class concepts"

**MAO evidence:** two-mode mutual exclusion selected at skill-load time (C2/C3 PROVEN);
sole-authority declaration in description + shim; provenance rule (C9 PROVEN for plan
artifacts incl. adversarial wording; DOCUMENTED for other channels).

| System | Orchestration-ownership concept | Artifact/workflow-directive trust boundary |
|---|---|---|
| Superpowers 6.4.1 | None (no awareness of MAO or other controllers; no per-skill disable). | Opposite direction: writing-plans *embeds* "REQUIRED SUB-SKILL" directives in every plan (verbatim unchanged in 6.4.1) — it is the artifact-injection source MAO defends against. | 
| GSD 1.14.0 | None toward foreign frameworks (shadow warnings only for GSD-own multi-scope installs; no Superpowers/other-plugin awareness found). | Partial, mechanistic, general-purpose: read-injection-scanner (PostToolUse Read/WebFetch/WebSearch) "Scans for prompt injection patterns (role override, instruction bypass, system tag injection)"; "Advisory by default; blocks only HIGH severity"; prompt-guard advisory-only. Not workflow-directive-specific; not about controller switching. | stream-gsd §7, §9 |
| Claude native | None — same-named plugin+local skills "Both load"; conflicts resolve by model judgment. | None documented for artifact-borne directives. | stream-claude §2, §9 |
| Codex | None. | None documented. | stream-codex |
| ZCode | None documented. | None documented. | stream-zcode |
| BMAD 6.12 | None (no mention of other frameworks found). | None (its own managed AGENTS.md block is additive, not a boundary concept). | stream-bmad §7 |

**Verdict: CONFIRMED DIFFERENTIATOR (both sub-concepts).** No compared system has an
ownership/exclusivity concept for orchestration authority, and none treats
workflow-directive-bearing artifacts as an untrusted channel for controller switching.
Nearest analog (GSD's injection scanner) addresses prompt injection generally, as an
advisory scanner, for different purposes. Honest bounds: MAO's boundary is prose-enforced
(doctrinally "a request, not a guarantee"), behaviorally proven only for plan artifacts,
mainly against one directive source (Superpowers), on one model family.

## H5 — "MAO is methodology-agnostic"

**MAO evidence:** core policy is task-shape-based (no phases/artifacts mandated); adapter
docs are mechanism-mappings only.

Tests against MAO itself (the hypothesis cuts inward, too):

1. The **delegation core** (benefit test, shaping, dispatch contract, integration) is
   methodology-free — nothing in it names a development methodology. TRUE by text.
2. The **boundary layer is Superpowers-shaped**: SKILL.md names `superpowers:
   subagent-driven-development` explicitly and whitelists 8 Superpowers component skills
   by name; the shim's routing sentence names SDD; the upgrade-check procedure is
   Superpowers-specific; ALL behavioral evidence is MAO-vs-SDD. The generic wording ("any
   other skill that prescribes its own agent roster, review cadence, or sequencing")
   generalizes the rule, but its concrete content is single-competitor.
3. Under a foreign methodology (GSD-managed repo, BMAD project), MAO's behavior is
   DOCUMENTED-only generic wording; GSD/BMAD coexistence untested (03-…coexistence.md).
4. Evidence bound: all campaigns on glm-5.3 (single model family; KNOWN-LIMITATIONS #7).

**Verdict: PARTIAL DIFFERENTIATOR / partially NOT SUPPORTED.** Agnostic in the delegation
core; demonstrably coupled to Superpowers in the boundary layer (an explicit, tested,
load-bearing coupling — the pack itself calls the shim sentence "load-bearing"). For
public positioning, "methodology-agnostic" is supportable only with the qualifier
"behaviorally tested against Superpowers/SDD only."

## H6 — "MAO is lightweight because it is pure policy rather than a framework"

Benefit and cost tested separately (feature vs consequence discipline):

**Characteristics (facts):** one SKILL.md + 2 references + 1 POSIX installer + 1 scenario
contract (~35 KB); no daemon, no hooks, no scripts at execution time, no persistent state
(one 15-byte marker); one canonical source, three symlinks, byte-identical consumption
(C40 PROVEN); reversible marker-delimited install/uninstall (fake-home lifecycle
validated); does not modify any foreign file (C11 PROVEN, mtime-swept).
**Comparative footprint:** GSD = 35 agents + 60+ commands + `.planning/` state + 12-entry
hook manifest (23 JS + 5 shell hook files shipped into `~/.claude/hooks/`) + npm runtime
CLI + capabilities system, and **requires node ≥24**; BMAD = installer + `_bmad/` +
`_bmad-output/` + 47-platform matrix + **uv hard requirement**; Superpowers = plugin +
SessionStart hook + 15 skills (moderate; no persistent project state besides
`.superpowers/sdd/` workspaces).

**Benefits that follow (consequences, claimed with evidence):** portability across 3
runtimes with zero transformation (PROVEN); near-zero attack surface (no code execution at
delegation time — contrast platform trust warnings: "Plugins… can execute arbitrary code");
instant uninstall; inspectability (whole policy is readable prose).
**Costs that follow (equally real):** enforcement is instruction-following (ADR-0001
proved sample-variance under co-loading; official doctrine: "a request, not a guarantee");
no observability surface (no ledger — cannot post-hoc answer "what did MAO decide" without
transcript analysis; Superpowers ships diagnosing-superpowers for this, GSD /gsd-forensics,
MAO nothing); no cross-session resume (SDD ledger exists because "controllers that lost
their place have re-dispatched entire completed task sequences — the single most expensive
failure observed" — a failure class MAO does not address); upgrade fragility (one-way
knowledge of Superpowers; adapter text already drifted — E-2).

**Verdict: CONFIRMED as characterization (unique footprint class in the compared set),
PARTIAL DIFFERENTIATOR as advantage** — the lightness is real and evidenced, but it is a
trade, not a uniform win; see 02-policy-vs-enforcement.md.

## H7 — "Runtime portability: one behavioral core across runtimes" (added — implied by brief §2)

Multi-runtime presence is now **SHARED CAPABILITY**: Superpowers lists 16 harnesses; GSD
17 install targets; BMAD ~47 platforms. MAO covers 3. MAO's distinct nuance: the
*identical artifact* serves all three (relative symlinks, no per-runtime transformation —
PROVEN by hashes), where GSD/BMAD transform at install time ("workflows and agents written
in Claude Code's native format and transformed during deployment") and Superpowers ships
per-harness packaging scripts. But ZCode also natively accepts `.claude-plugin` manifests
and Claude-marketplace entries, and Codex's enterprise marketplace accepts Claude formats —
the ecosystems themselves are converging on cross-compat, eroding the uniqueness of MAO's
hand-rolled version of it.

## H8 — "Anti-overdelegation is MAO's headline objective" (added)

**CONFIRMED DIFFERENTIATOR as objective + as published evidence.** No compared system
takes "make 'use subagents' mean better execution rather than more agents" as its purpose;
vendor docs *warn* about cost (Codex: subagent workflows "consume more tokens than
comparable single-agent runs"; Claude teams: token cost "Higher") without gating. MAO's
$2.90–3.27 (MAO mode) vs $9.57 (co-loaded) vs $8.16–11.24 (native SDD) measurements on a
fixed seed/model remain the only published comparative cost data in this comparison set —
valid **only** within that harness/model/seed (no cross-system cost claims are made; no
equivalent public data exists for GSD/BMAD/native).

## H9 — "Adaptive topology derived from task structure" (added — brief dimension 8)

**PARTIAL DIFFERENTIATOR.** Dependency-derived execution topology is now common and in
GSD's case mechanized (dependency-DAG + file-overlap wave partitioner; undeclared-coupling
flags; scope validation) — mechanistically stronger than MAO's prose "dependency-aware
waves." ZCode 3.14/Claude native dynamic workflows make topology an explicit script
artifact. What remains MAO-specific: topology adaptation *down to zero agents* within a
mode, per-seat materiality (H2), and clustering by coupling (sequential vs parallel chosen
per work-shape, C19/C20 PROVEN). SDD's batch exception (6.3.0+) and BMAD's party-`auto`
are narrow analogs.

## H10 — "Single-agent fallback inside a delegation-flavored request" (added)

**CONFIRMED DIFFERENTIATOR (with a Superpowers caveat).** MAO answers "use subagents where
appropriate" with "no agents" when work is trivial/coupled — PROVEN (test C all-primary
run; model quoted the anti-trigger clause). No competitor has an in-mode fallback to zero:
SDD cannot run with 0 agents; executing-plans is a separate user-chosen mode, not a
fallback; GSD's pipeline always engages (degrade-to-sequential still uses GSD agents);
native has no policy to fall back from. Caveat: on the *trigger* level, Claude Code's
model-discretion means any skill can simply not fire — but that is absence of policy, not
a sanctioned no-delegation default.

---

## Features vs consequences (discipline register, per task §7)

| Feature/characteristic | Distinguish from | Status |
|---|---|---|
| Adaptive topology selection (H1/H9/H10) | fewer agents / lower cost / less context pressure | consequences; cost advantage evidenced ONLY within MAO's own seed/model campaign |
| Per-seat materiality justification (H2) | fewer reviewers / lower cost | consequences |
| Mode exclusivity + provenance rule (H4) | "beats SDD in routing" | consequence; the feature is the ownership model itself |
| Pure-Markdown policy (H6) | portability, inspectability, small footprint (benefits); weak enforcement, model-dependence, no observability (costs) | implementation characteristic with two-sided consequences |
| Runtime-agnostic single source (H7) | "works everywhere" | consequence partially eroded: only 3 runtimes actually tested; cross-compat now ecosystem-native |
| Shim on the instruction channel | routing reliability | consequence bounded: empirically strong (6+ samples), doctrinally NOT guaranteed (current Claude docs: conflicts resolve by model judgment — stream-claude §9c) |

## Contradictions flagged

1. Baseline research/01 carried "user instructions take precedence over skills" as an
   official-doctrine anchor; current Claude docs contain **no such guarantee** (only
   Superpowers' own bootstrap concedes it). MAO's C8 remains PROVEN empirically + by
   competitor concession, but its doctrinal footing is weaker than the baseline implied.
   (Recorded in 00 §5 N-2 context; no baseline erratum — the baseline cited Superpowers'
   concession, which is verbatim-verified.)
2. ADR-0000's fork_turns "(none/all/suffix)" vs raw diagnostics (none/all only) — Erratum
   E-2 (00 §5).
3. BMAD v6.5.0 "42 platforms" vs 47 yaml entries today — immaterial to MAO; noted in
   stream file only.

## Subagent usage record (task §0 requirement)

Six read-only Explore research subagents (one per ecosystem: Superpowers, GSD, Claude
Code, Codex, ZCode, BMAD), launched in parallel by the main session, evidence-gathering
only; none made comparative judgments, modified files, invoked MAO/any framework, or
spawned further orchestration. Reports preserved verbatim in
`comparison/evidence/stream-*.md` with per-fact source URLs and evidence types; the main
session (this controller) performed all classification above after re-reading the reports.
Local verifications (hashes, installed versions, hook config, SDD 6.3.0 file quotes,
fork_turns diagnostics) were done directly by the main session.
