# Comparison 06 — Gap Analysis

Date: 2026-09-22. Gaps separated into: **A** public-release blockers · **B** core
orchestration defects · **C** capability gaps · **D** evidence gaps · **E** optional
improvements. Each gap: evidence → impact → risk → direction → complexity → host-runtime
overlap. Optional improvements are deliberately NOT promoted to blockers.

## A. PUBLIC-RELEASE BLOCKERS (required for safe public distribution)

### A1 — Un-namespaced identity + duplicate-install surface
- **Evidence:** limitation #9; Claude docs: same-named personal+plugin skills **both
  load**; two MAO copies = two routing sentences in one listing (trigger contest with
  itself). Plugin packaging namespaces but introduces exactly that duplicate class.
- **Impact:** silent shadowing/duplication on other users' machines → nondeterministic
  routing, the failure class MAO exists to prevent.
- **Risk if shipped without fix: HIGH** (reputation: "MAO caused the collision it warns
  about").
- **Direction:** choose public plugin name (08-D5); ship duplicate detection in `mao
  doctor` + install-time check; docs rule ("don't install both forms").
- **Complexity:** low-moderate (packaging + doctor).
- **Host overlap:** partial — namespacing mechanics exist (plugin system); detection of
  duplicates does not.

### A2 — No version metadata / channel-sync guarantee
- **Evidence:** limitation #10; Claude update pinning is semver-based; ZCode marketplace
  requires manifest==entry version match; plugin auto-update can drift a plugin MAO past
  the owner's upgrade-check discipline.
- **Impact:** users on mixed versions; support burden; untraceable bug reports.
- **Risk: MEDIUM-HIGH.**
- **Direction:** version field at packaging layer + skill-hash verification (manage.sh
  verify already hashes canonical — extend to compare against packaged hash).
- **Complexity:** low.
- **Host overlap:** platforms carry version metadata but not cross-channel consistency
  checks.

### A3 — Trigger/coexistence regression suite not automatable today
- **Evidence:** scenario J/K/A/B/D are manual (transcript analyzer); upgrade-check for
  Superpowers 6.4.1 **currently due and unrun** (limitation #2); `claude plugin eval`
  exists with trigger-rate graders (2.1.269+) but MAO has no eval suite.
- **Impact:** every upstream drift re-opens the core contest with no automated tripwire;
  public users won't run manual scenarios.
- **Risk: HIGH** (this is the product's central behavioral guarantee).
- **Direction:** encode scenarios as `claude plugin eval` cases (Claude channel first;
  Codex/ZCode manual recipe retained); run the 6.4.1 upgrade-check now (07-E1).
- **Complexity:** moderate (eval authoring + co-presence arm setup).
- **Host overlap:** yes for Claude (plugin eval) — adopt host capability rather than build
  (task §11 precedent).

### A4 — Claim discipline + compatibility matrix must ship public
- **Evidence:** PUBLIC-DISTRIBUTION-ARCHITECTURE §"claim discipline"; comparison shows all
  non-SDD pairs untested (03); version skew is itself a hazard (ZCode cached SDD 6.2.0).
- **Impact:** overclaiming = fabricated compatibility promises.
- **Risk: MEDIUM** (trust), low technical.
- **Direction:** publish matrix with version pins; "not tested together" lines stay
  explicit.
- **Complexity:** low (docs).
- **Host overlap:** none needed.

### A5 — Adapter text accuracy vs current platforms (E-2 class)
- **Evidence:** Erratum E-2 (fork_turns "suffix" — unevidenced locally, nonexistent
  upstream); executing-plans redirect language stale vs 6.4.1 (00 §4B.3); Codex
  documented tool-surface drift (send_input/resume_agent/close_agent vs audited
  send_message/followup_task/interrupt_agent).
- **Impact:** public users on current runtimes get advice referencing nonexistent
  mechanisms — credibility damage disproportionate to size.
- **Risk: MEDIUM.**
- **Direction:** adapter wording refresh pass, gated behind behavioral re-verification
  (07-E4/E9); keep adapters as verified-facts-only docs.
- **Complexity:** low (wording) / moderate (verification).
- **Host overlap:** no — this is MAO's own doc accuracy.

*(A1–A5 together = the honest minimum for "safe public distribution." Everything else
below is not a release blocker.)*

## B. CORE-ORCHESTRATION DEFECTS (actual problems in current semantics)

### B1 — Codex nesting guard is policy-only against an officially unbounded surface
- **Evidence:** baseline limitation #3; current: Responses-API multi-agent officially
  documents "Child agents can also spawn their own sub-agents" with "no fixed limit on…
  tree depth"; CLI `max_depth` issue-documented as ignored by V2 + open enforcement bugs
  (#46704 on 0.155.1).
- **Impact:** the one runtime where MAO's root-to-child rule (C33) has no platform backstop
  is the runtime moving *further* from one.
- **Risk: MEDIUM** (briefs still carry "Do not spawn subagents"; rejection side proven at
  0.149.1; untested since).
- **Direction:** behavioral re-verification on current Codex (07-E9); consider
  documenting the guard as best-effort on Codex in public claims.
- **Complexity:** low (test) — no mechanism fix is available to MAO without violating its
  own non-invasiveness (it cannot patch Codex).
- **Host overlap:** the host owns this gap; MAO can only verify and disclose.

### B2 — Authorized-nesting positive path is unevidenced policy
- **Evidence:** C33 positive path DOCUMENTED-only; scenarios F never run. Meanwhile SDD
  6.4.1 release-notes an opt-in nested-controller mode (#2320) — upstream shipped a
  nested topology before MAO ever exercised its own.
- **Impact:** a rule MAO advertises (raise depth deliberately for bounded designs) has
  zero behavioral evidence.
- **Risk: LOW-MEDIUM.**
- **Direction:** run 07-E6 once; or soften public wording to "untested path."
- **Complexity:** low (one scenario).

### B3 — Failed/interrupted child recovery (scenario H) never executed
- **Evidence:** C15 DOCUMENTED-only; 08-test record "gap". GSD/BMAD both ship failure
  machinery (GSD blocked-story semantics + forensics; BMAD "blocked" permanence + repair
  loop caps) — the class is real in the field.
- **Impact:** MAO's recovery contract is untested prose.
- **Risk: LOW** (rare event; primary-validation ownership bounds the blast radius).
- **Direction:** 07-E8; keep as documented-gap disclosure if not run pre-release.
- **Complexity:** low-moderate (needs fault injection in a disposable repo).

No other semantic defects were found: the frozen v3 boundary semantics held against all
current evidence (SDD contract unchanged; bootstrap concession intact; platform mechanics
compatible — 00 §4B, 03).

## C. CAPABILITY GAPS (useful, absent)

### C1 — Diagnostics surface (`mao doctor`)
- **Evidence:** proposal exists (design/); Superpowers ships diagnosing-superpowers
  (path:line forensics); GSD ships /gsd-health + /gsd-forensics + runtime-identity; MAO
  ships verify() (self-integrity only).
- **Impact:** public users cannot answer "is my MAO healthy; what else can claim
  authority here?"
- **Risk of absence: MEDIUM** for public; **Direction:** implement proposal as read-only
  reporter (REPORT never mutate — its own hard constraint is right).
- **Complexity:** moderate. **Host overlap:** /skill-doctor covers per-skill usage stats,
  not cross-framework authority detection — no overlap.

### C2 — Observability/ledger of delegation decisions
- **Evidence:** 02 §4.3; SDD ledger (compaction-respawn rationale verbatim upstream);
  GSD STATE.md. MAO: nothing (by design, but the *decision-trace* absence is distinct
  from the state absence).
- **Impact:** debugging MAO-mode runs requires transcript archaeology.
- **Risk: LOW. Direction:** EXPERIMENT class — a SubagentStop/Stop observer hook that
  *logs* (never blocks) MAO-relevant events to a local file; must stay opt-in and
  non-invasive-compliant. **Complexity:** moderate. **Host overlap:** OTel hook events
  (2.1.280 hook_execution_complete etc.) partially cover telemetry — check host first.

### C3 — Resume/continuity across compaction
- **Evidence:** SDD ledger exists specifically because "controllers that lost their place
  have re-dispatched entire completed task sequences"; GSD state survives /clear. MAO's
  primary-agent contract has no compaction story.
- **Impact:** long MAO-mode runs can repeat completed work after compaction.
- **Risk: LOW-MEDIUM on long tasks. Direction:** EXPERIMENT — light "delegation state"
  scratchpad convention inside the brief (not a framework ledger); evaluate before
  adopting. **Host overlap:** workflows/teams solve resume their own way; not applicable
  to MAO's mode.

### C4 — Per-seat skill attachment (GSD-style) / model-tier guidance
- **Evidence:** GSD `agent_skills` config attaches plugin skills to agents; model
  profiles. MAO deliberately maps to capability classes (C21) — **no gap; keep** (recorded
  here because it surfaced; classified DO-NOT-ADOPT in final table).

## D. EVIDENCE GAPS (claims not yet provable)

1. Non-plan artifact channels for the provenance rule (issues/READMEs/transcripts) —
   DOCUMENTED-only (C9). Test: 07-E3.
2. Non-glm-5.3 model families — all behavioral claims single-model (limitation #7).
   Direction: extend eval suite across models when plugin-eval harness exists (it runs
   real sessions per model).
3. GSD coexistence (trigger + yield directions) — mechanism questions now answered from
   source (03 §2) but behavior untested. Test: 07-E5.
4. Agent Teams interaction (auto-formation caveat). Test: 07-E10 (flag-gated, cheap).
5. Codex/ZCode post-campaign behavioral re-validation (limitation #6; tool-name drift).
   Test: 07-E4/E9.
6. ZCode local skew: machine at 3.11.2, adapter anchored to 3.7.7, current 3.14.3 — live
   refresh + behavioral spot-check needed. Test: 07-E4.
7. Claude-native Workflow / ZCode dynamic workflow invoked inside an MAO task (yield-rule
   coverage for by-name workflow *tools*, not just skills). Test: 07-E10.
8. `skillOverrides`-style mute interactions with a future plugin-form MAO (knob gap is
   official — public doc must state it).

## E. OPTIONAL IMPROVEMENTS (non-essential)

- E-opt1: `when_to_use` frontmatter split (Claude) to enrich listing within the 1,536
  budget while keeping description ≤250 for ZCode — packaging-layer nicety, no semantics
  change (research/03 model C).
- E-opt2: Codex `agents/openai.yaml` metadata (display + implicit-invocation declared
  explicitly = self-documenting trigger posture; keeps default true).
- E-opt3: Doctor's Class-3 trigger-overlap scan (description-substring heuristics,
  HEURISTIC-labeled) — from the proposal, already scoped.
- E-opt4: Public example fixture library (the 438-line adversarial plan + scenario
  scripts) so users can run J/K themselves — support material, not product surface.
- E-opt5: Cross-publication of measured campaign economics with full scope labels
  (transparency, not marketing).

## Blocker count discipline (task §13)

Five blockers (A1–A5), all packaging/validation-layer. **Zero blockers demand changing
MAO's orchestration semantics.** The frozen v3 policy survived the entire current-state
comparison without a single counter-finding (see FINAL report §3); the defects found (B1–
B3) are verification/disclosure items, and B1's root cause is upstream. This is the
strongest single output of the gap analysis: **public readiness is a packaging-and-evidence
problem, not a redesign problem.**
