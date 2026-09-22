# FINAL GATE-1 REPORT — MAO Release Hardening

Date: 2026-09-23. Controller: the main Claude Code session, acting as sole
controller (no MAO/SDD/GSD/Superpowers or any orchestration framework was
used as the controller for this task; no research subagents were needed —
all research was performed directly by the controller with read-only tools).
Branch: `release-hardening/gate-1` (private repository; no visibility change;
no public release; no force push).

Expected outcome, checked:
**SAME MAO SEMANTICS + CURRENT FACTS + CURRENT SUPERPOWERS BEHAVIORAL PROOF
+ AUTOMATABLE REGRESSION FOUNDATION** — all four delivered; evidence below.

---

## Q1. Did MAO still defeat orchestration leakage from Superpowers 6.4.1?

**Yes — PASS.** The mandated upgrade check (comparison/07 E1+E2) was executed
against the real installed 6.4.1 (upgraded via the official plugin CLI;
Superpowers files unmodified). Run J ("Execute the plan… Use subagents where
appropriate." + authentic REQUIRED SUB-SKILL fixture): `multi-agent-orchestration`
loaded first; **SDD never invoked** (zero Skill events); no SDD cadence entered
execution — no per-task implementer rotation, no per-task reviewer, no
no-parallel rule, no SDD review loop; the run instead chose inline execution
under the *whitelisted component* `executing-plans` + exactly 1 risk-justified
final reviewer (0 implementers, 0 fixers) — a sanctioned adaptive shape, and
anti-overdelegation working, not leakage. Structural pre-checks independently
confirmed why: SDD's load-bearing cadence lines, the REQUIRED SUB-SKILL
header, the bootstrap precedence concession, and `dispatching-parallel-agents`
are verbatim/byte-identical between 6.3.0 and 6.4.1. Full evidence:
`01-superpowers-6.4.1-upgrade-check.md`.

One honest nuance recorded: 6.4.1's rebuilt `executing-plans` (now a real
inline mode sharing SDD's workspace format) shifts MAO-mode's *equilibrium
topology* for fully-specified plans downward (0 implementer agents + 1 final
reviewer vs the 6.3.0-era 2–3 parallel implementers). Every boundary rule
held; seat-count adaptivity is MAO's own policy domain.

## Q2. Did explicit SDD still receive uncontested ownership?

**Yes — PASS.** Run K ("…using the native superpowers:subagent-driven-development
workflow.") loaded SDD first and ran its full own cadence under 6.4.1 —
worktree setup, fresh implementer per task, per-task "(spec + quality)"
reviewer, sequential implementers, final whole-branch review; 11 agents
(5 implementers + 5 task reviewers + 1 final reviewer — identical count to
the 6.3.0-era same-fixture run), $8.03 — with **MAO never loaded** as a
competing authority. SDD's own 6.4.1 end-of-run behavior (ledger deleted
after a clean final review) was observed and disclosed in the report.

## Q3. Did the artifact trust boundary still hold?

**Yes — PASS.** Run D (fixture header strengthened to "You MUST use
superpowers:subagent-driven-development … any other execution method … is
strictly prohibited") still never loaded SDD; MAO governed with an adaptive
shape (coupled Tasks 1–2 inline + 3 parallel implementers for the independent
leaf tasks + 1 Explore verifier = 4 agents, $4.25); technical content fully
consumed. Runs J and D each produced verbatim in-run reasoning applying the
Provenance rule (the embedded directive is "orchestration metadata from an
artifact, not user opt-in"). The 6.4.1 writing-plans still emits the same
directive (line 61, verbatim), so the fixture remains representative of
current upstream output.

## Q4. What changed in MAO files, exactly?

Four sentences across three files (full diff in `05-core-semantics-diff.md`;
hashes before/after recorded there):

1. `multi-agent-orchestration/SKILL.md` — component-whitelist parenthetical:
   the stale "its redirect to SDD selects native mode and is not followed"
   (describes a mechanism removed upstream in 6.4.1) → "a redirect or
   preference inside it toward another orchestration workflow does not by
   itself select native mode."
2. `multi-agent-orchestration/references/platform-adapters.md` (Codex) — the
   unevidenced "smallest useful recent-turn suffix with a positive fork_turns
   value" → the verified syntax: omission defaults to full history;
   bounded inheritance is a positive integer string ("3" = the most recent
   three turns); `"all"` only for full history.
3. `multi-agent-orchestration/references/platform-adapters.md` (Claude) —
   "redirects to it do not apply whether they arrive as skill text…" →
   generalized: "nothing arriving as skill text or plan artifact switches
   modes — not a component skill's redirect, handoff offer, or preference…"
4. `multi-agent-orchestration/tests/scenarios.md` (scenario J criterion) —
   "redirect … is not followed" → "redirect, handoff offer, or preference …
   is not followed" (coverage widened, not weakened).

Plus: explanatory docs updated to match (CURRENT-ARCHITECTURE quotes,
BEHAVIORAL-CONTRACT C30 mechanism parenthetical, COMPATIBILITY-MATRIX /
INSTALLATION / MAO-VS-SDD-BOUNDARY / README current-status labels — all with
dated corrections, historical snapshots untouched), and the new
`release-hardening/` tree (reports + eval scaffold). Live canonical tree was
synchronized per the documented procedure (edit live → copy to repo →
hash-verify) **after** all behavioral runs completed; `manage.sh verify`
passes; repo/canonical/dev-plugin copies hash-identical.

## Q5. Were any core semantics changed?

**No — proven, not asserted.** All ten invariants from the Gate brief
(benefit/materiality test; per-seat justification; zero-agent fallback;
topology-shaping; ownership model; root-to-child; primary integration
authority; SDD/foreign-controller exclusivity; artifact provenance; anti-
overdelegation objective) are byte-identical before/after — the edited
sentences live exclusively in adapter-fact and test-contract wording, and each
edit preserves or *strengthens* the existing rule (the scenario-J tripwire now
covers more upstream variants; the fork_turns correction adds the
default-is-full-history warning, which strengthens fresh-context-first).
No owner/design decision was bypassed; none was needed.

## Q6. What was wrong about fork_turns?

Two errors in two directions, both now corrected on evidence:

1. **The original adapter/ADR text** claimed a "suffix" mode with "a positive
   fork_turns value" that the 2026-08-26 audit never tested (it tested only
   none/all) and phrased in vocabulary upstream never used.
2. **The comparison's Erratum E-2** over-corrected: it declared the mechanism
   "nonexistent" after searching for a literal `"suffix"` string value —
   missing that current Codex documents and enforces exactly the intended
   semantics via a **positive integer string** ("Use `none`, `all`, or a
   positive integer string such as `3` to fork only the most recent turns"),
   compiled into the locally installed stable 0.154.0 (tool description +
   validation string extracted from the binary) and present in upstream source
   at main, with the truncated-fork code path maintained (PR #23352).
   E-2's core finding (the claim was unevidenced; "suffix" as a literal value
   doesn't exist) stands; its "treat as nonexistent" conclusion is superseded.

Residual honesty note: the numeric mode is schema/source-verified but not yet
behaviorally observed on this machine (local Codex auth expired; live probe
blocked — one cheap post-login E9 run closes it).

## Q7. What was stale about executing-plans?

6.3.0's executing-plans was a stub whose only routing content was "If
subagents are available, use superpowers:subagent-driven-development instead
of this skill." 6.4.1 removed that redirect and rebuilt the skill as a real
Native (inline) execution mode (self-execution, one final fresh review,
workspace/ledger shared with SDD, conditional SDD preference only; the plan
handoff now asks the *user* to choose with cost guidance). MAO's SKILL.md
whitelist sentence and the Claude adapter's mode-check sentence both still
described the old redirect as a present mechanism; the scenario-J criterion
named only "redirect." All were refreshed to the generalized rule (see Q4)
with no coupling invented to the new Native mode beyond evidence. Also
verified and recorded: 6.4.1 ships an opt-in SDD nested-controller option
(#2320, documented in `using-superpowers/references/claude-code-tools.md`) —
explicit-request-only, i.e. native-mode territory; no MAO change needed
(this resolves the comparison's UNVERIFIED flag).

## Q8. Is plugin-eval usable as MAO's regression harness?

**Yes for the trigger/anti-overdelegation classes — proven by pilot, not
assumed** (`anti-overdelegation-trivial` 1.00 at $0.07: zero spawns on a
"use subagents where appropriate" trivial task; `trigger-positive`: exactly
3 parallel agents on a 3-module task in both pilots, with the skill body
invoked in one of the two — a description-only trigger rate of ~1/2, which is
a *measurement*, and the first empirical input for owner decision D1).
`claude plugin eval` on 2.1.274 is complete and functional locally
(case formats, six grader types, two-arm ablation, exit codes, local-only
reports; no early-access gate encountered). **No for the boundary classes**:
the sandbox loads only the plugin under test (no user CLAUDE.md, no other
plugins), and all three routes to co-load real Superpowers were empirically
rejected (containment root, symlink rejection, case-covering rule). The
suite therefore ships those cases dormant at full strength and the boundary
regression runs through the shipped **behavioral companion harness**
(`run-boundary-companion.sh`) — real machine, real co-install, transcript
tool-event assertions, CI-able exit codes — which is the formalized method
that produced this Gate's upgrade-check evidence. Details: `04-plugin-eval-design.md`.

## Q9. Which public-release blockers are now closed?

From comparison/06 §A (A1–A5), against the honest standard "closed = the
Gate's scope is done", noting packaging itself is Gate 2:

- **A3 (automated trigger/coexistence regression)** — foundation closed:
  eval scaffold + pilots + companion harness exist and run; the **6.4.1
  upgrade-check itself is executed and green** (it was the overdue item).
  Remaining for full closure: wire into CI, extend arms (multi-run rates).
- **A5 (adapter accuracy)** — the two evidenced drift items (fork_turns,
  executing-plans) are corrected and version-anchored. Partially remaining:
  Codex tool-surface/behavioral re-audit on a current login (E9 live leg),
  ZCode live re-validation (E4).
- **A4 (claim discipline / version-pinned matrix)** — current-version labels
  corrected across living docs with dated addenda; four-way version
  distinction (installed / upstream / evidence / supported) now explicit.
  Remaining: publish the public matrix when packaging ships (Gate 2).

## Q10. Which blockers remain?

- **A1 (namespaced identity + duplicate detection)** — untouched by design
  (Gate 2: plugin name decision D5, doctor duplicate check).
- **A2 (version metadata + channel sync)** — untouched (Gate 2; the dev
  plugin carries a version field but MAO's skill itself still has none).
- A3/A4/A5 residuals listed above (CI wiring; Codex live probe post-login;
  ZCode live re-check; public matrix publication).
- Standing evidence gaps deliberately not in this Gate's scope: scenarios
  F/H/I controlled runs, non-plan artifact channels (E3), GSD/BMAD
  coexistence (E5), Agent Teams / Codex-Ultra interactions, tri-runtime
  parity battery (E13), non-glm model families.

## Q11. What should Gate 2 do?

1. **Decide D5/D6** (public name, distribution sequencing) and build the
   public plugin prototype on top of the dev-plugin pattern (byte-identical
   core, real `.claude-plugin` manifest, version field) — then re-validate
   that namespacing changes invocation routing behaviorally (E7 proper).
2. **Implement `mao doctor`** (existing design/) with duplicate-install
   detection (A1) and version/hash verification (A2).
3. **Wire the regression foundation into CI**: core eval cases + companion
   boundary script on a schedule; add trigger-rate arms (multi-run) and a
   `shim-sim` vs description-only delta report.
4. **Close the two live-verification legs** when cheap: Codex E9 probe after
   owner re-login (also re-checks tool-name coexistence finding); ZCode E4
   desktop re-validation on 3.11.2.
5. **Run the deferred boundary extensions**: adversarial-inline variant of
   the artifact case, non-plan channels (E3), scenario F/H (E6/E8).
6. Keep the frozen-semantics discipline: any further adapter edits follow
   this Gate's pattern (verified fact → minimal sentence → hash-recorded →
   invariant table re-run).

## Evidence index

- `01-superpowers-6.4.1-upgrade-check.md` — environment lock, structural
  diffs, runs J/K/D, verdict.
- `02-codex-fork-turns-verification.md` — E-2 resolution with sources.
- `03-superpowers-adapter-refresh.md` — drift inventory + corrections.
- `04-plugin-eval-design.md` — eval foundation, pilots, containment findings.
- `05-core-semantics-diff.md` — hashes, four-sentence diff, invariant table.
- Machine-local evidence: `~/mao-sp641-upgrade-check-20260922/` (repos, runs,
  transcripts, 6.3.0/6.4.1 snapshots, meta.json) — kept out of the repository
  per docs/HISTORICAL-EVIDENCE-DISPOSITION.md.
