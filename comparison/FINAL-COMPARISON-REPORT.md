# FINAL COMPARISON REPORT — MAO vs Current Orchestration Systems

Stage-2 independent competitive and architectural analysis of MAO (Multi-Agent
Orchestration), following the completed forensic baseline audit. Date: 2026-09-22.
Controller: main session; six read-only research subagents (evidence only, recorded in
`evidence/stream-*.md`); versions locked in `00-baseline-errata-and-version-lock.md`
(Superpowers 6.4.1 · GSD Core 1.14.0 · Claude Code 2.1.280 · Codex 0.155.1 · ZCode 3.14.3
· BMAD 6.12.0 · MAO v3 frozen, hash `fee98091…`). Canonical MAO untouched (verified);
this phase added research documents only.

---

## 1. Executive conclusion

The frozen MAO v3 policy survived a full current-state comparison **without a single
counter-finding against its core semantics**: every load-bearing claim re-verified, and
the one competitor it was built against (SDD) is behaviorally unchanged where it matters.
MAO remains genuinely differentiated on four things — **per-seat materiality
justification, orchestration-authority arbitration (mode exclusivity + artifact trust
boundary), the anti-overdelegation objective with published behavioral evidence, and the
sanctioned fallback to zero agents** — while the abstract idea of benefit-gated
delegation has converged into vendor guidance (Codex Ultra template, Claude docs
heuristics) and is no longer distinctive by itself. Nothing found requires changing
MAO's policy. What public release requires is packaging, evidence automation, adapter
accuracy, and diagnostics — five blockers, zero redesigns. Two baseline errata were
recorded (local ZCode is 3.11.2 not 3.7.7; fork_turns "suffix" was never evidenced).

## 2. What MAO actually is

A runtime-agnostic **delegation-decision and orchestration-arbitration policy**,
distributed as one ~35 KB skill (no code at delegation time, no state, no hooks, no
agents of its own), riding the native subagent mechanisms of Claude Code, Codex CLI, and
ZCode through one byte-identical canonical source (C1, C36, C40 PROVEN). It is not a
framework, methodology, workflow engine, or mechanism — categories occupied respectively
by GSD/BMAD, SDD's cadence, the platforms' dynamic-workflow runtimes, and the platforms'
subagent systems. (Full identity analysis: 05.)

## 3. What MAO genuinely does differently today (each evidence-cited in 01)

1. **Per-seat materiality justification** (H2 CONFIRMED): every
   implementer/reviewer/re-viewer/fixer seat requires task-specific benefit; stages never
   preauthorize successors; 0 reviewers is a sanctioned outcome. No compared system has
   this at any granularity (nearest: BMAD per-finding triage, GSD opt-in code review,
   SDD round-5 adjudication — all different things).
2. **Orchestration-authority arbitration** (H4 CONFIRMED): two-mode mutual exclusion at
   selection time + sole-authority declaration + artifact provenance rule. No competitor
   has an ownership concept at all; nobody reciprocates (03 §4). The arbitration layer is
   unoccupied elsewhere.
3. **Artifact trust boundary** (H4 CONFIRMED): workflow directives embedded in
   plans/artifacts are metadata, adversarially tested (C9). Nobody else addresses this
   channel — Superpowers is its *source* (REQUIRED SUB-SKILL verbatim-unchanged in
   6.4.1); GSD's injection scanner is advisory and about something else.
4. **Anti-overdelegation as the objective, with evidence** (H8 CONFIRMED): "use
   subagents" → better execution, not more agents; measured campaigns ($2.90–3.27 vs
   $9.57 co-loaded, same seed/model — scope-labeled, no cross-system claims); trivial
   work stays primary even on explicit delegation requests (H10, test C PROVEN).
5. **Zero-transform multi-runtime distribution** (H7 PARTIAL): one artifact, three
   runtimes, no per-runtime transformation (GSD/BMAD transform at install time) — though
   only 3 runtimes vs 16–47, and ecosystems now natively cross-accept manifests.

## 4. What MAO no longer does differently (eroded since MAO v3 was frozen)

- **Benefit-gated delegation as an idea** (H1 PARTIAL): OpenAI ships the concept as
  policy template ("proactively delegate… when parallel agents would materially improve
  speed or quality" — Ultra tier; Responses-API dev-messages); Claude docs carry
  when-to-use heuristics; BMAD party-`auto` ("spawns independent agents only when
  independence changes the answer") and GSD's degrade-to-sequential are benefit-shaped
  adaptivity; Superpowers 6.4.1 moved the whether-to-delegate choice into a user-facing
  cost-guided mode menu. MAO's *implementation* (five-benefit taxonomy + tested
  anti-overdelegation + portability) remains uncommon; the concept does not.
- **Multi-runtime presence** (H7 SHARED): 16 (Superpowers) / 17 (GSD) / ~47 (BMAD)
  platforms vs MAO's 3.
- **Dependency-aware topology** (H9 PARTIAL): GSD mechanizes it (dependency-DAG +
  file-overlap waves + scope validation); native dynamic workflows make topology explicit
  code. MAO's prose waves are not behind as *concept*, but others now execute topology
  deterministically where MAO reasons about it.
- **Mixed primary+delegated execution** (H3 SHARED at capability level): native trivial;
  BMAD's standard shape is primary-implements + delegated review. MAO's ownership
  protocol around it is what stays distinctive (and GSD enforces scope more
  mechanically than MAO's briefs).

## 5. Capabilities competitors have that MAO lacks (details + directions: 06)

- **Behavioral eval infrastructure** — Superpowers Quorum lab (LLM actor+verifier, real
  CLI sessions); Claude `claude plugin eval` (trigger-rate graders, control arms, CI
  exit codes, sandbox); MAO has manual scenarios + a transcript analyzer. (→ ADOPT host
  harness.)
- **Session forensics/diagnostics** — diagnosing-superpowers (path:line-cited,
  read-only); GSD /gsd-health, /gsd-forensics, runtime-identity; MAO has verify()
  self-checks only. (→ ADOPT as `mao doctor`, proposal already scoped.)
- **Persistent state / resume** — SDD ledger (built explicitly against the
  compaction-respawn failure class); GSD `.planning/` surviving /clear with lockfile
  transactions; BMAD spec state machine. MAO has none (→ EXPERIMENT only; C3.)
- **Mechanism-grade invariants** — GSD's guards (secret reads, worktree containment,
  wave-scope validation); platform worktree enforcement ("can't turn this check off").
  MAO's equivalents are prose + empirics (→ keep; 02.)
- **Deterministic orchestration engines** — Claude/ZCode dynamic workflows, Codex hosted
  multi-agent (unbounded nesting, documented) (→ DO NOT ADOPT; different product class.)
- **Peer/mesh topologies** — Claude Agent Teams (teammates = full sessions,
  SendMessage/ListAgents) (→ DO NOT ADOPT; contradicts root-to-child by design.)
- **Distribution reach & installer machinery** — marketplaces everywhere; GSD's 17-target
  installer + capabilities system; BMAD's 47-platform matrix (→ ADOPT packaging form,
  not installer machinery.)

## 6. Capabilities MAO should deliberately NOT copy

Framework ledgers-as-process, fixed role rosters, phase methodologies, hook guards over
foreign tools, per-runtime code adapters, mandatory review cadences, reviewer/fixer
pipelines, mesh teams, engine-ization of topology. Each was tested against task-§11
questions (does MAO need it / does it solve a demonstrated MAO problem / can it be added
without changing purpose / would it make MAO a framework / cost / host-solves-better) —
full table in §17.

## 7. MAO vs Superpowers / SDD

Different categories: SDD = fixed-cadence, review-gated execution workflow inside a
15-skill discipline library with a session bootstrap; MAO = adaptive delegation policy.
SDD 6.4.1's contract is behaviorally unchanged where MAO's boundary engages (fresh
implementer + mandatory reviews + no-parallel + ledger + REQUIRED SUB-SKILL header — all
verbatim-verified). Upstream *moved toward* MAO's philosophy at the edges: executing-plans
became a real inline mode (its old SDD-redirect — which MAO's adapter text still
references — is gone; drift finding A5), the plan handoff now asks the *user* to choose
execution mode with cost guidance, and an opt-in nested-controller option shipped
(release-noted; MAO's own authorized-nesting path remains unexercised — B2). The
empirically measured economics ($2.90–3.27 MAO vs $8.16–11.24 native SDD, 38–47 tests
green both) document topology control, not quality superiority — no quality verdict is
claimed or implied. Coexistence remains the one *behaviorally proven* pair, with the
trigger class permanently open and the 6.4.1 upgrade-check now due (E1).

## 8. MAO vs GSD (GSD Core / Open GSD 1.14.0)

Different categories: GSD = full project methodology (five-phase loop, 35 agents,
`.planning/` state, 60+ commands, capabilities system, npm installer + Claude plugin,
17 runtimes) with the strongest enforcement culture surveyed (12-entry hook manifest;
hard guards for secrets/worktree/executor-isolation; explicit per-hook crash policies).
The baseline's biggest unknown — "GSD's PreToolUse guards may gate MAO's dispatches" — is
**resolved from source: they don't** (agent-isolation guard activates only for
`gsd-executor` in GSD-configured projects; foreign dispatches allowed silently; workflow
guard advisory + default-off). Real residual: GSD's npm-global *skills* put broad
descriptions into the same trigger listing as MAO (untested Class-3 contest), and MAO's
by-name yield for `/gsd-*` is untested generic wording (E5). GSD earns respect on
mechanized ownership (wave file-overlap partitioning, scope validation) — stronger than
MAO's prose within GSD repos, irrelevant outside them. No awareness of MAO/Superpowers
on either side.

## 9. MAO vs Claude Code native orchestration

The platform supplies mechanisms + guidance, not policy: subagents (depth default 3 —
MAO caps 1; concurrency 20; CLAUDE.md inheritance split that MAO's restate-constraints
rule already encodes), Agent Teams (still experimental/flag-gated; auto-formation caveat
makes it a real topology-changer if a user enables it — E10), dynamic workflows
(ultracode opt-in only, deterministic, resumable — a complementary engine, not a
competitor for authority), hooks (33 events; the doctrine "a request, not a guarantee →
a hook is enforcement" is now official and *supports* MAO's residual-risk framing),
plugin eval (2.1.269+ — the regression harness MAO should adopt), skillOverrides
(officially cannot mute plugin skills — removes an assumed mitigation). One doctrinal
hardening: current docs guarantee **no** CLAUDE.md-over-skills precedence ("Claude uses
judgment to reconcile") — MAO's routing rests on empirics + Superpowers' concession, not
vendor promise. MAO is orthogonal to all of this by design: policy over mechanism.

## 10. MAO vs Codex native orchestration

Mechanism + guidance: officially documented CLI multi-agent (`spawn_agent` et al. — note
surface drift vs the audited 0.149.1 tools), `[agents]` config, custom roles
(`~/.codex/agents/*.toml` — MAO's pre-existing reviewer.toml is an approved pattern),
skills at `~/.agents/skills` with `allow_implicit_invocation` and `[[skills.config]]`
knobs MAO currently doesn't ship (E-opt2), universal ChatGPT+Codex plugin directory
(submission requires 5+3 maintained test cases — an effort gate for MAO's Codex channel).
Two hard facts: hosted multi-agent officially allows **unbounded child-spawns-child
nesting** (MAO's Codex nesting guard is prose against a platform that documents no
limit — B1, the one flank that got *weaker* upstream), and the Ultra proactive-delegation
template puts a second delegation policy in MAO's instruction space (compatible values,
untested interaction — E11).

## 11. MAO vs ZCode native orchestration

Smallest delta: MAO's ZCode integration uses only documented public surfaces (skills
symlink + description ≤250 + AGENTS.md shim), all still documented at 3.14.3; local
machine runs 3.11.2 (Erratum E-1) with adapter text anchored to 3.7.7 — doc-verified but
not live-verified (E4). ZCode's platform nesting-impossibility remains MAO's strongest
platform backstop anywhere. New since baseline: dynamic workflows (3.14.0,
script-orchestrated, journal + sandbox — complementary, opt-in), plugin store with
`.claude-plugin` acceptance + preloaded Claude marketplace (packaging path, E12), and
confirmation that ZCode also reads `~/.agents/skills` as fallback (no conflict with
MAO's dual symlinks; doctor check noted).

## 12. MAO vs BMAD / other systems

BMAD 6.12 (v7 preview) = product-development methodology (5 named personas, PRD→
architecture→stories, readiness gates) installed across ~47 platforms, prompt-only
enforcement, no coexistence awareness. Genuine overlaps with MAO's *ideas* at component
level: "sizes ceremony to the change," "Route to smallest safe path," party-`auto`
materiality — adaptive-process notions inside a fixed methodology; and BMAD's standard
shape (primary implements, delegated independent review) is MAO-like mixed execution
under a mandatory review stage. Not installed locally; the O-class collision with MAO
(softer than SDD's: per-run vs per-task cadence) is predicted, untested, and matters
publicly because BMAD's install base is everywhere. Other systems screened (audit
frameworks, workflow tools) did not meet the relevance bar (task §2) and were excluded —
the comparison was not padded.

## 13. Controller-coexistence findings (full: 03)

No system reciprocates anyone's authority; GSD's guards deliberately allow foreign
dispatches; Superpowers' only coexistence property is its bootstrap's user-instruction
concession; platforms supply namespace mechanics, not policy (same-named skills both
load; skillOverrides excludes plugins; conflicts resolve by model judgment). The
universal collision channel is the trigger listing. Version skew is itself a coexistence
dimension (local Superpowers spans 6.2.0/6.3.0 vs 6.4.1 upstream; ZCode 3.7.7-anchored /
3.11.2 local / 3.14.3 current). This very analysis session ran as a live coexistence
instance (Superpowers bootstrap + MAO shim + native subagents; no controller seizure —
one sample, consistent with campaigns). Freshly de-risked: MAO+GSD mechanism layer
(guards allow). Still dark: GSD/BMAD trigger contests, Agent Teams auto-formation,
Codex Ultra template interaction, non-SDD yield paths.

## 14. Policy-vs-enforcement trade-off (full: 02)

Authority is not a platform-enforceable unit — platforms police tool calls, files,
topology; even GSD scopes its guards to invariants, not authority; every system contests
authority at the model's selection step, which is exactly where MAO chose to fight (and
where it holds unique tested evidence). Prose buys portability, zero trust surface,
mechanism-composability, judgment-as-feature; costs sample variance (proven real,
reduced not eliminated), no doctrinal guarantee, no observability, no compaction
continuity, upgrade fragility (two adapter drifts already: E-2, executing-plans). The
cheap real wins are grade-2 self-controls and read-only instrumentation; genuine
enforcement would require becoming GSD (rejected) or breaking non-invasiveness
(rejected). MAO's actual deficit on this axis is instrumentation, not enforcement.

## 15. Public-packaging implications (full: 04)

The tri-store architecture is *more* feasible than at baseline (native cross-manifest
acceptance: ZCode takes `.claude-plugin` + preloads the Claude marketplace; Codex
enterprise import takes Claude formats; Codex consumer portal exists with a 5+3-test
submission gate). The **shim survives plugin distribution as a necessity**: no plugin
system writes the user instruction channel, and the instruction channel is the
evidenced routing layer — "plugin distributes, script integrates" is confirmed, not
obsoleted, by current platforms. Plugin eval turns MAO's central regression scenarios
into automatable, CI-able artifacts. Namespacing changes invocation names (shim
references must be re-validated behaviorally); duplicate-install detection becomes
mandatory (doctor); version-sync discipline across stores is a real operating cost.

## 16. Public-release blockers (full: 06 §A)

A1 namespaced identity + duplicate detection · A2 version metadata + channel-sync
verification · A3 automated trigger/coexistence regression (adopt plugin eval; run the
**now-due** Superpowers 6.4.1 upgrade-check) · A4 version-pinned compatibility claims ·
A5 adapter-accuracy refresh (fork_turns E-2; executing-plans drift; Codex tool-surface
drift). **Zero blockers require semantic change; no core defect found demands redesign.**

## 17. KEEP / ADOPT / EXPERIMENT / DO NOT ADOPT

| Capability (source) | Class | Rationale (evidence) |
|---|---|---|
| Benefit gate, 5-taxonomy (MAO) | **KEEP** | H1 core; PROVEN |
| Per-seat materiality incl. 0-reviewer outcomes (MAO) | **KEEP** | H2 CONFIRMED unique |
| Mode exclusivity + by-name yield (MAO) | **KEEP** | H4; only authority model in field |
| Artifact provenance rule (MAO) | **KEEP** | H4; extend tests to non-plan channels (E3) |
| Mixed execution + ownership protocol (MAO) | **KEEP** | C23/C26 PROVEN |
| Primary-owned integration/final validation (MAO) | **KEEP** | C12–C14 PROVEN |
| No-state / no-hooks / non-invasive footprint (MAO) | **KEEP** | H6; differentiators flow from it |
| `claude plugin eval` regression (Claude) | **ADOPT** | host solves A3 better than anything MAO could build |
| Diagnostics surface / `mao doctor` (GSD health, Superpowers diagnosing) | **ADOPT** | read-only reporter; design already written |
| Plugin/marketplace packaging + namespacing (all stores) | **ADOPT** | solves A1; feasibility confirmed (04) |
| Version metadata + hash-sync (platforms) | **ADOPT** | A2 |
| Superpowers Quorum-style independent eval lab | **EXPERIMENT** | defer until plugin-eval proves insufficient (avoid duplicate infra) |
| Optional read-only event logging (observability) | **EXPERIMENT** | C2; must stay opt-in, non-invasive |
| Light delegation scratchpad for compaction continuity | **EXPERIMENT** | C3; NOT a ledger/framework |
| Native worktree isolation for parallel write lanes | **EXPERIMENT** | platform-grade mechanism; adapter-advice level only |
| Authorized nested delegation path | **EXPERIMENT** | validate existing rule (E6) before any wording strengthens it |
| GSD dependency/wave *machinery* | **DO NOT ADOPT** | engine-level; MAO's prose waves + judgment are the product; GSD's mechanization is scoped to GSD repos |
| GSD runtime adapter *generation* | **DO NOT ADOPT** | zero-transform distribution is a differentiator; MAO has nothing to transform |
| GSD profiles/surface management | **DO NOT ADOPT** | no surface to manage |
| Hook guards over foreign tools | **DO NOT ADOPT** | violates C11/P7; polices wrong thing (02) |
| Persistent execution ledgers (SDD/GSD-style) | **DO NOT ADOPT** | framework machinery; changes product class |
| Mandatory reviewer pipelines / fixed cadences | **DO NOT ADOPT** | contradicts H2/H10, the confirmed differentiators |
| Agent Teams peer/mesh topologies | **DO NOT ADOPT** | contradicts root-to-child + primary-integration authority |
| Deterministic workflow engines | **DO NOT ADOPT** | different product; complementary (users may invoke explicitly; MAO yields) |
| Fixed role rosters / phase methodologies (GSD/BMAD) | **DO NOT ADOPT** | that is the category MAO arbitrates among, not one it should join |

## 18. Required experiments (full designs: 07)

Priority: **E1** Superpowers 6.4.1 upgrade-check (due now — mandated by the frozen
README's own discipline) → **E9** Codex adapter re-audit (fixes E-2 class facts) → **E7**
plugin prototype + eval suite (unblocks A1/A3, validates 04) → **E3/E6/E8**
(artifact-channels, authorized-nesting, failed-child — the named scenario gaps) → **E5**
GSD isolated coexistence (first foreign-methodology evidence; needs owner approval for
isolated install) → **E4/E12** ZCode live re-validation + plugin parity → **E10/E11**
Agent Teams / Codex-Ultra interactions (when cheap) → **E13** tri-runtime parity battery
(capstone).

## 19. Owner decisions (full: 08)

D1 trigger model (recommend: hybrid status quo, revisitable against E7 data; explicit-
only is the fallback) · D2 enforcement degree (recommend: prose + opt-in read-only
instrumentation; guards rejected) · D3 scope (recommend: remain narrow — clearest call
in the register) · D4 compatibility promise (recommend: best-effort, version-pinned;
a broad guarantee is the only dishonest option) · D5 public name/identity (genuine owner
choice; constraints given) · D6 distribution sequencing (recommend: Claude plugin
prototype + evals + doctor before any listing; Codex stays script-channel until the eval
suite can satisfy portal requirements).

## 20. Recommended MAO vNext objective

**One sentence:** make the frozen v3 semantics publicly distributable and publicly
*provable* — namespaced plugin packaging with explicit script-based integration,
automated behavioral regression on the platform's own eval harness, corrected and
version-anchored adapters, a read-only doctor, and a version-pinned compatibility matrix
— changing nothing about what MAO decides, only about how it is shipped, verified, and
disclosed.

**The direct answer to the product question** ("Compared with SDD and similar
skills/plugins, what genuinely differentiates our MAO today?"):

> Four things, each behaviorally evidenced and absent from every compared system at the
> same granularity: per-seat materiality justification (including "zero agents is a
> normal answer to 'use subagents'"), exclusive per-task orchestration authority with
> explicit-by-name yield, an adversarially-tested artifact trust boundary for embedded
> workflow directives, and anti-overdelegation as the organizing objective with published
> same-seed cost evidence. The *idea* of benefit-gated delegation is no longer rare —
> vendors now ship it as guidance — but no compared product implements it as a portable,
> arbitration-aware policy with regression evidence, and none addresses controller
> coexistence at all. Everything else MAO does is shared, common, or deliberately absent.

No superlatives beyond the evidence; no marketing conversion; the differentiators are
claimed exactly as proven and bounded exactly as limited (single model family, one
behaviorally-tested competitor pair, prose enforcement).
