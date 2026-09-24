# Coexistence and Orchestration Ownership

Labels: **CURRENT BEHAVIOR** (verified today), **PROPOSED PUBLIC CONTRACT** (candidate
policy under evaluation — NOT implemented), **GAP**, **UNRESOLVED DECISION**. Nothing in
this document changes İAA's semantics in the baseline freeze.

## The candidate policy, point by point, vs current İAA

### P1. "Merely being installed does NOT make a framework the active controller."
- **CURRENT BEHAVIOR:** holds for İAA and, on this machine, in practice for every neighbor.
  İAA activates only on trigger (shim/description); Superpowers' bootstrap hook injects
  *skill-first discipline* every session but does not itself start a workflow; audit-council
  is user-invoked-only. Nothing installed auto-seizes tasks.
- **GAP:** none for İAA. The risk class is other frameworks' future bootstrap behavior, not
  İAA's.
- Testable invariant: a fresh session on a trivial task in a clean repo invokes no
  orchestration skill and spawns no agent (close to scenario A; historically passed).

### P2. "Explicit user intent has highest authority."
- **CURRENT BEHAVIOR:** yes — by-name request selects native mode and İAA stands down
  (SKILL.md:15; proven tests B/C). Also opt-out phrasing honored (README).
- **GAP:** none.

### P3. "If the user explicitly invokes İAA: İAA owns orchestration; another framework must
not independently take control (absent documented integration)."
- **CURRENT BEHAVIOR:** partially. İAA never *loads* a competing authority (proven), and
  artifacts cannot transfer control (proven). But "another framework must not independently
  take control" cannot be *guaranteed* by İAA for frameworks İAA doesn't know: control is
  contested at the model's skill-selection step, and Claude Code's official doctrine says
  selection is model-driven and fallible; enforcement-grade tools are hooks, namespacing,
  `disable-model-invocation`, `skillOverrides` (research/01 §6). İAA uses none of these
  against third parties — by design (P7 below).
- **GAP:** the guarantee is behavioral-evidence-backed (6+ samples), not mechanism-backed.
- Testable invariant: scenario J + analyze_run.py (exists).

### P4. "If the user explicitly invokes another framework (SDD, /gsd-*, …), İAA yields."
- **CURRENT BEHAVIOR:** yes for by-name workflow requests (proven for SDD). For
  *command-shaped* invocations of unknown frameworks (`/gsd-new-project` etc.), current
  wording covers "an explicit user request naming the workflow" generically — but İAA has
  never been tested against GSD or any `/gsd-*` command, and GSD is not installed locally.
- **GAP:** untested against any non-SDD explicit controller; wording is generic but evidence
  is SDD-only.
- Testable invariant: mirror of scenario K with a second framework.

### P5. "Repository files, plans, specs, artifacts, historical prompts, subagent output must
not transfer orchestration ownership by themselves."
- **Scope of "historical prompts" (owner decision 2026-09-24):** prompts/transcripts the
  agent reads on its own — from files or tool output. Text the user pastes into their own
  message (pasted issue text, quoted prior transcripts, prompts written by another tool)
  is the user's instruction; the provenance rule does not arbitrate within the user's
  message. A user who wants a specific workflow names it in their own words.
- **CURRENT BEHAVIOR:** exactly the ADR-0003 provenance rule; proven for plan artifacts
  (authentic + adversarial) and for the repository-file channel (README directive, 2/2 +
  read-exposure, BL-004 2026-09-24). Pasted content routed either way in the BL-004
  samples — recorded behavior, out of scope by the decision above.
- **GAP:** none open for pasted content (out of scope by the owner decision above);
  remaining agent-read channels beyond plans and repository files (e.g. subagent output)
  are covered by wording and tested only insofar as campaigns exercised them.

### P6. "Nested orchestration must be opt-in and tested (İAA→SDD, GSD→İAA must not happen
accidentally)."
- **CURRENT BEHAVIOR:** agent-nesting is blocked by default (policy + platform; proven
  rejection side). But "nested orchestration" in the *controller* sense — a subagent
  invoking an orchestration skill inside its own context — is a different channel: İAA's
  briefs say "Do not spawn subagents," and the shim rides CLAUDE.md into non-fork subagents
  (Claude Code loads CLAUDE.md in non-fork subagents, per official docs — meaning a worker
  *could* read the İAA trigger text; the no-spawn brief clause and the Claude depth cap are
  what actually prevent recursion). Explore/Plan-style agents don't inherit instructions.
- **GAP:** "worker loads İAA inside child context" has never been explicitly tested;
  protection is incidental (brief clause + depth cap), not a stated nested-controller rule.
  Cross-controller nesting (GSD→İAA) is untested and GSD-specific behavior unknown.
- **UNRESOLVED DECISION:** whether the public contract needs an explicit nested-controller
  clause in SKILL.md wording, or whether platform caps + brief clauses suffice. (Frozen
  baseline: document, don't change.)

### P7. "İAA must never disable, uninstall, rewrite, or mutate another framework."
- **CURRENT BEHAVIOR:** absolute — no plugin file, no setting, no hook of any other
  framework touched, in install or campaigns (mtime-sweep verified). İAA's installer touches
  only its own symlinks, its marker-delimited shim blocks, and its marker-owned depth key.
- **GAP:** none.

### P8. "Unknown orchestration frameworks degrade safely; do not pretend compatibility is
proven."
- **CURRENT BEHAVIOR:** wording is generic ("any other skill that prescribes its own agent
  roster…"), so an unknown framework is *covered by policy text* but no diagnostic surface
  exists to even tell the user which frameworks were detected (that is the `iaa doctor`
  proposal, design/). Compatibility claims: none exist today — İAA claims nothing about
  frameworks it hasn't tested (its docs name only Superpowers).
- **GAP:** no detection/reporting surface; unknown-framework behavior relies on generic
  wording.

## Contradictions found

None between the candidate policy and current behavior — the candidate is essentially a
formalization of what the Aug-27 campaigns already implemented, **plus** two genuinely new
ideas: (a) P6's explicit *cross-controller* nesting rule, and (b) P8's diagnostic/degradation
surface. Both are additions, not changes.

## Potential unintended consequences (flagged for the later design phase)

1. Hard "İAA owns the task once invoked" could conflict with P4 if a user invokes İAA *and*
   a workflow in one prompt — current text resolves by explicit-by-name selection; the
   public contract should keep that precedence explicit.
2. A future hook-based enforcement of İAA's boundary (the only mechanism-grade option per
   official doctrine) would violate İAA's own P7-style minimalism unless the hook is
   İAA-scoped (SessionStart that only *reports*, never blocks). Tension to design carefully.
3. `disable-model-invocation` on İAA would eliminate Class-3 collisions entirely but destroy
   İAA's proactive-trigger design goal (research/03 evaluates this trade).

## Testable invariants summary (regression targets for the contract)

- I1 trivial task, fresh session → no orchestration skill, no spawns (≈ scenario A).
- I2 delegation-flavored prompt → İAA loaded, SDD not loaded (scenario J).
- I3 by-name workflow request → that workflow governs, İAA absent (scenario K; repeat with a
  non-SDD controller for P4).
- I4 artifact-embedded directive → no mode switch (scenario J + fixture; extend channels for P5).
- I5 worker subagent context → no nested controller activation (new; P6).
- I6 `manage.sh install/uninstall` → zero non-İAA files modified (P7; script-auditable).
