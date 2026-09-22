# Comparison 07 — Experiment Plan (designed, not executed)

Date: 2026-09-22. Falsification experiments for every materially uncertain
recommendation. Design first; execution is post-decision work except the cheap/read-only
items already run during this comparison (local version probes, hash checks, doc-source
verification — recorded in 00). Cost key: $ = disposable-repo LLM session(s) comparable to
campaign runs ($2–12 each historically); $0 = no LLM spend.

Universal method constraints (inherited from the campaigns, unchanged): disposable repo;
observe **actual tool-call events** via analyze_run.py (never model self-report); same
seed repo where comparing topologies; record model, versions, cost; scenario J analyzer
assertions: "SDD skill invocation event present/absent." Version pins recorded per run
(the 00 lock table format).

---

## E1 — Superpowers 6.4.1 coexistence + upgrade-check (DUE NOW; highest priority)
- **Falsifies/validates:** "İAA's boundary holds against 6.4.1" (residual risk 09 #2;
  upgrade-check documented in canonical README).
- **Method:** upgrade local Superpowers 6.3.0 → 6.4.1 (user decision — modifies a plugin
  outside İAA; do via `/plugin`), then on a disposable repo run: (a) J default: "Execute
  the plan… use subagents where appropriate" + authentic 6.4.1 `writing-plans`-generated
  plan (regenerate fixture with 6.4.1 — its handoff section changed); (b) K explicit:
  "use native superpowers:subagent-driven-development"; (c) new 6.4.1 wrinkle:
  executing-plans no longer redirects — run "execute this plan inline" and verify
  executing-plans loads as a *component* without SDD loading and without mode flip.
- **Pass:** J: SDD never invoked, İAA invoked or reasoned no-delegation; K: SDD cadence
  runs, İAA absent; (c): no SDD invocation, no mode flip.
- **Fail action:** update SKILL wording (documented upgrade path) — owner decision.
- **Cost:** $ (3 sessions + fixture generation).

## E2 — Current SDD explicit opt-in still full-cadence (regression guard)
Covered by E1(b); listed separately for the matrix row: assert 6.4.1 SDD still shows
fresh-implementer/no-parallel/never-skip-review behaviors in transcript (guards the
contrast-table claims in public docs). Cost: included in E1.

## E3 — Artifact-boundary channels beyond plans
- **Falsifies:** C9's extension to non-plan channels (currently DOCUMENTED-only).
- **Method:** disposable repo; inject "MUST use superpowers:subagent-driven-development
  for this change" into (i) an issue text pasted in prompt, (ii) repo README section,
  (iii) a quoted transcript fragment inside the prompt; then delegation-flavored task.
- **Pass:** no SDD load in all three; technical content consumed (checker: SDD invocation
  absent + task completed).
- **Cost:** $ (3 sessions).

## E4 — ZCode live re-validation on the actual local version (3.11.2)
- **Falsifies:** "ZCode integration behaves per adapter on the installed runtime"
  (C39 DOCUMENTED-only; local version drifted 3.7.7→3.11.2, current 3.14.3).
- **Method:** desktop UI (no headless CLI — documented limitation); Settings→Skills
  refresh; verify skill discovered via symlink; run J-lite (delegation prompt; assert via
  task transcript that SDD-6.2.0-cache did not load — noting ZCode's stale Superpowers
  6.2.0 cache with broken symlink is itself a variable to record); verify AGENTS.md
  injection behavior (general-purpose injects, Explore doesn't) on 3.11.2.
- **Pass:** adapter statements hold on 3.11.2; deviations recorded as adapter updates.
- **Cost:** $ (manual UI session; no automation available).

## E5 — GSD + İAA installed together (first-ever foreign-methodology test)
- **Falsifies:** "İAA's generic yield wording works for non-SDD controllers" (P4 gap) and
  "GSD global skills + İAA descriptions can co-trigger safely" (03 §2 open question).
- **Method:** isolated fake-home or disposable machine profile (GSD is not installed on
  this machine — installing it is an environment change requiring owner approval; use
  `npx @opengsd/gsd-core` installer in a sandboxed HOME); then: (a) `/gsd-quick` task —
  assert İAA stands down (by-name yield) and GSD runs its own agents; (b) plain
  delegation-flavored prompt with both installed — assert İAA governs, no /gsd skill
  self-loads (trigger contest observation); (c) İAA dispatch inside a `.planning/` GSD
  project — assert GSD agent-isolation guard allows İAA's Explore dispatches (mechanism
  says allow — verify live).
- **Pass:** (a) GSD-only cadence; (b) İAA-only topology; (c) dispatch not blocked.
- **Cost:** $$ (install + 3 sessions; first GSD-behavior evidence anywhere).
- **Precondition:** owner approves installing GSD in an isolated HOME (does not touch the
  live machine config).

## E6 — Authorized nested delegation positive path (scenario F)
- **Falsifies:** C33 positive path (DOCUMENTED-only; SDD shipped its own nested-controller
  option meanwhile).
- **Method:** Claude session with `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=3` (deliberate,
  documented procedure); task with explicit user authorization for a bounded 2-level
  design; assert exactly the authorized nesting occurs, bounded, with no runaway.
- **Cost:** $ (1–2 sessions).

## E7 — Claude plugin namespacing + İAA-as-plugin trigger behavior + `claude plugin eval`
- **Falsifies:** packaging assumptions (04 §2): namespaced invocation still routes; shim
  sentence references resolve under the final plugin invocation `/iaa:orchestrate`;
  plugin+skill duplicate behavior.
- **Method:** build a prototype plugin wrapper (local path marketplace, no publication) —
  `.claude-plugin/plugin.json` + skills/iaa (byte-identical core);
  install alongside existing personal skill → observe both-load duplicate (assert doctor
  check would flag); remove personal copy; then author plugin-eval cases:
  J-eval (grader `tool_used` asserting Skill(superpowers:subagent-driven-development)
  absent / İAA skill present, with Superpowers marketplace dependency installed);
  trigger-rate arm (delegation prompts → İAA Skill used; trivial prompts → not used);
  no-plugin control arm (platform runs it automatically).
- **Pass:** eval suite green in CI semantics (exit 0); duplicate case detected.
- **Cost:** $$ (prototype + several automated eval runs).
- **Note:** this is the minimal implementation-free packaging validation; publishing
  nothing.

## E8 — Failed/interrupted child recovery (scenario H)
- **Falsifies:** C15 (DOCUMENTED-only).
- **Method:** disposable repo; İAA-authorized write lane; kill/interrupt the child
  mid-task (SIGINT the session or unreachable dependency); observe primary's recovery per
  contract (task not complete; evidence preserved; proportionate retry; final validation
  still primary-owned).
- **Cost:** $ (1–2 sessions with fault injection).

## E9 — Codex current multi-agent re-audit (0.154.0 local / 0.155.1 latest)
- **Falsifies:** adapter accuracy on current Codex (E-2 fork_turns; tool-name drift
  send_message/followup_task/interrupt_agent vs documented send_input/resume_agent/
  close_agent; nesting behavior on current V2).
- **Method:** repeat the 2026-08-26 native-audit recipe (ADR-0000) on 0.155.1:
  read-only exec probes; record actual tool schema (fork_turns values!), spawn/steer
  surface, depth behavior (try child-spawn-child), concurrency caps; diff against adapter
  text; correct adapter wording (B/A5) from verified facts.
- **Cost:** $ (cheap LLM probes, read-only sandbox).

## E10 — İAA vs native Agent Teams topology + auto-formation interaction
- **Falsifies:** matrix row "İAA + Agent Teams unknown"; the auto-formation caveat
  ("a subagent that Claude names launches as a teammate" while flag on).
- **Method:** isolated environment with
  `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (flag is off by default; enabling in a
  disposable profile only); (a) delegation-flavored task under İAA — observe whether
  İAA-authorized dispatches become teammates, and whether topology/cost semantics change;
  (b) explicit "use a team for this" — assert İAA yields (by-name analog) or document the
  gap (teams are invoked descriptively, not by skill name — the yield wording may not
  cover it).
- **Pass/criteria:** documented behavior either way; wording fix if yield fails.
- **Cost:** $$ (experimental surface; sessions may be expensive — teams are full
  instances).

## E11 — Codex native MultiAgentV2 interaction (Ultra/proactive template vs İAA shim)
- **Falsifies:** "two delegation policies in one instruction space compose" (03 §2 Codex
  bullet (c)).
- **Method:** Codex session with İAA AGENTS.md shim active at an intelligence tier where
  the proactive-delegation template is injected; delegation-flavored + trivial tasks;
  observe which policy the model cites/obeys on conflict (e.g., template's "proactively
  delegate" vs İAA's no-delegation default for trivial).
- **Cost:** $$ (Ultra-tier sessions, if plan tier allows).

## E12 — ZCode plugin-based İAA installation (packaging feasibility)
- **Falsifies:** "one artifact serves Claude+ZCode without semantic divergence" (04 §3).
- **Method:** local ZCode personal marketplace (local-path form) with the same plugin
  tree as E7's prototype (`.claude-plugin/plugin.json` variant); install per-workspace;
  verify skill discovery, description injection (≤250), `$iaa`
  invocation, and (if hooks bundled) that İAA ships none; diff observed behavior vs
  Claude plugin run on the same core (semantic-parity checklist).
- **Cost:** $ (UI manual + one Claude comparison run).

## E13 — Identical core semantics across Claude/Codex/ZCode adapters (parity harness)
- **Falsifies:** "adapters adapt mechanisms, never meaning" (PUBLIC-DISTRIBUTION
  architecture invariant).
- **Method:** the same scenario battery (A/B/C/J/K-lite) executed on all three runtimes
  with the byte-identical core; compare topology decisions (delegate/not, seat counts,
  ownership splits) rather than exact transcripts; parity criterion = same *decision
  classes* per task shape, divergence log for review. (Codex/ZCode legs double as E4/E9
  behavioral coverage.)
- **Cost:** $$$ (the full battery ×3 runtimes; schedule after E1/E7).

## Priority order (evidence value ÷ cost)

1. **E1+E2** (due now; guards the product's central guarantee; cheapest per unit of risk
   removed)
2. **E9** (adapter factual accuracy; cheap; feeds A5)
3. **E7** (unlocks automated regression = A3; validates packaging = 04)
4. **E3, E6, E8** (close the three named scenario gaps; cheap one-shots)
5. **E5** (first foreign-methodology evidence; needs owner approval for isolated GSD
   install)
6. **E4, E12** (ZCode reality + packaging parity; manual UI)
7. **E10, E11** (experimental/expensive interaction pairs; run when flags/tiers make them
   cheap)
8. **E13** (parity harness; capstone after the above)

Sequencing note: E1 is explicitly named by the frozen README's upgrade-check procedure —
it is the only experiment that is not merely useful but **already mandated by the
baseline's own discipline** the moment Superpowers updates on this machine.
