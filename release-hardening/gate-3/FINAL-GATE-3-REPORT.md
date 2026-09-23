# FINAL GATE-3 REPORT — İAA Release Hardening

Date: 2026-09-23. Controller: the main Claude Code / GLM-5.3 session, sole
controller per Gate brief §0 (no İAA/SDD/GSD/Superpowers or other
orchestration framework used as controller). Branch:
`release-hardening/gate-3` (base `main@0d4c5631132ad94968d884358c70defe1a288c3f`
= `v0.1.0-rc.1`). Four read-only research subagents were used for
independent external research streams (licensing, upstream versions,
namespace collisions, Claude-eval grader semantics), each returning
evidence only — all judgments, code, validations, and git operations were
performed by the main session. Repository remained **PRIVATE** throughout;
no marketplace submission; no public release; no `v0.1.0` tag; no force
push; `v0.1.0-rc.1` untouched.

Expected outcome, checked: **İAA 0.1.0-rc.1 + FINAL PUBLICATION EVIDENCE +
LICENSE DECISION PACKAGE + CORRECTED EVAL METHODOLOGY + FINAL CODEX/ZCODE
STATUS + PUBLICATION RUNBOOK + ZERO CORE SEMANTIC CHANGE — all delivered.**

---

## Q1. Is İAA 0.1.0 technically ready for public release?

**Yes, pending owner decisions only.** Every technical publication gate
that can be closed without owner action or a GUI has been closed and
evidenced (see Q2/Q3). The remaining items are owner choices (license
approval, optional GUI leg, email policy), not technical defects.

## Q2. What exact technical blockers remain?

None that block publication. Standing, honestly-scoped (non-blocking):

1. ZCode plugin-form GUI leg (owner checklist, ~5 min; running it here
   would mutate the owner's live ZCode state into the duplicate-activation
   condition İAA itself forbids). Status stays STRUCTURALLY COMPATIBLE
   until then — honest, not a blocker.
2. Upstream version drift (Claude 2.1.280 / Codex 0.156.1 / ZCode 3.14.3
   vs tested set) — handled by the version-pinned claims discipline; no
   re-verification trigger has fired (Superpowers 6.4.1 remains current).
3. npm name `iaa` is taken — irrelevant (npm is not a distribution
   channel); recorded for any future npm idea.
4. GSD/BMAD/Agent-Teams/other-model gaps — standing, deliberate,
   UNVERIFIED-labeled.

## Q3. What exact OWNER decisions remain?

1. **LICENSE**: approve OPTION A (MIT + NOTICE, candidates verbatim in
   `release-hardening/gate-3/license-candidate/`) or direct otherwise
   (see Q4/Q5). Include or substitute the copyright-holder line
   (`isakli05` handle vs legal name — legally equivalent).
2. **Commit-email posture**: history carries the owner's personal address
   (09 §3); keep, or use GitHub noreply for future commits (history is
   never rewritten per policy).
3. **LCO citation** in docs/HISTORY + web-pack 07: keep (evidence
   citation) or generalize.
4. **Optional**: execute the ZCode GUI checklist (05 §6) to upgrade that
   row to TESTED.
5. **Final sign-off** to execute PUBLICATION-RUNBOOK.md (the only
   remaining irreversible step sequence).

## Q4. What license is recommended and why?

**RECOMMENDED: OPTION A — MIT + NOTICE.** Why: 100% original single-holder
content; the only redistributed third-party material is one short
functional Superpowers template line (MIT-licensed upstream; not a
"substantial portion"; short functional phrases are outside copyright
subject matter — no obligation, courtesy attribution only); nothing
vendored; MIT is the ecosystem-matched choice (Superpowers itself ships
MIT through the same channels) and is accepted as SPDX `"MIT"` by all
three target registries; a no-license public repo would leave every user
technically unlicensed — the opposite of the project's purpose. NOTICE is
optional under MIT (the mechanism is Apache-2.0 §4(d) doctrine) and is
offered as the consolidated courtesy-attribution surface promised in
Gate 2. Patent note: MIT carries no explicit patent grant (implied-only
by majority reading) — immaterial for a policy/skill distribution with no
known patents. Not legal advice; the audit found zero evidence requiring
an alternative (no OPTION B is recommended).

## Q5. Was any root LICENSE actually added?

**NO.** Exact candidates live at `release-hardening/gate-3/license-candidate/{LICENSE,NOTICE}`
only. Installing them is runbook Phase A, after owner approval.

## Q6. How were historical absolute paths handled?

Three-class policy (`02-historical-path-policy.md`): class A
hash-pinned/dated provenance preserved byte-exact (87 enumerated lines —
CANONICAL-README ×56, audit ×17, identity-migration ×6, gate-2/04 ×2,
raw diffs ×6); class B current docs verified portable; class C
explanatory summaries normalized where safe — exactly two current-facing
docs rewritten to `~/`-relative forms (9 lines total, no hash pinned to
either). Packages contain no `/home/isa` strings at all.

## Q7. Was trigger evaluation correctly separated into trigger /
materiality-policy / forced-benefit?

**Yes** (`03-trigger-eval-methodology.md`): class A trigger (skill-load
indicator, no agent requirement), class B materiality/policy-compliance
(explicit `min: 0` caps — fixing the omitted-`min`-defaults-to-1 bug that
produced "Agent called 0x (expected 1..3)" — plus synthesis rubric), class
C forced-benefit (new scaffolded fixture with pre-established benefit;
ONLY this class expects ≥1; max 3 is fixture-contract-derived, not
arbitrary). Grader semantics confirmed against the official
plugin-evals documentation before the fix.

## Q8. What did the corrected evals show?

Single-arm validation (`--ablation none`, n=3/case, 6 sessions, $6.06,
Claude Code 2.1.274, GLM-5.3 profile, plugin namespace `iaa` 0.1.0-rc.1):

- **trigger-positive 3/3 at score 1.00** — including a 0-agent run that
  the OLD grader failed and the corrected grader correctly passes
  (zero-agent fallback recognized, not penalized). The Gate-2 0.73
  decomposition is validated post-hoc: behavior never changed; the
  question did.
- **forced-benefit-delegation: delegation materialized 3/3** — exactly
  one worker per module (3 agents) in every run, caps respected on both
  tool names, synthesis complete.
- One honest datum: run0 delegated correctly WITHOUT the skill loading
  first (description-channel variance, plugin-only arm) — isolated by the
  class-A indicator exactly as designed; a trigger-rate measurement, not
  a policy failure. No product action taken or implied.

## Q9. Did Codex final dynamic validation pass?

**Yes — the Gate-2 gap is closed** (`04-codex-final-validation.md`):
authentication was available; a live authenticated Codex session in a
disposable home (plugin installed, no skills-dir duplicate, byte-identical
cache core verified) **discovered `iaa:iaa` in its session skills table
served from the plugin cache** and, on the `$iaa` probe, loaded the actual
core and answered the materiality + zero-agent-default question correctly
(5,770 tokens, transcript-verified). Honest mechanism note: `$iaa` in
exec mode resolves model-mediated via the skills table, not token
expansion. Native multi-agent surface re-confirmed in the platform's own
developer context (fork_turns semantics unchanged).

## Q10. What is Codex's publication-safe status?

**TESTED** (both forms, version-pinned to codex-cli 0.156.0): skills-dir
form (campaigns + E9 live spawn/fork_turns) and plugin form (lifecycle +
live discovery/invocation, this Gate; behavioral evidence via the
byte-identical core). Matrix updated accordingly.

## Q11. Did ZCode final validation pass?

**Everything safely automatable passed** (`05-zcode-final-validation.md`):
official zai-org validator re-run this Gate → `OK: 1 plugin(s) validated`;
manifest/marketplace/version parity, byte-exact core projection, layout
and description budgets, plus a new machine-context datum (ZCode's own
registry demonstrably consumes claude-marketplace-shaped entries). The
GUI/live-install leg was NOT executed — deliberately: it requires the
owner's desktop interaction and would create the duplicate-activation
state on this machine (skills-dir `iaa` already active in `~/.zcode`).
Not claimed as passed; precise owner checklist provided.

## Q12. What is ZCode's publication-safe status?

**STRUCTURALLY COMPATIBLE** for the plugin form (unchanged, now with
fresh validator evidence + the registry datum); skills-dir form TESTED
(historical production usage). Not PREVIEW (validator-backed structural
claim exists); not TESTED/PARTIALLY TESTED (no in-app behavioral
evidence). Upgrade path defined.

## Q13. Did `iaa` pass submission-time namespace checks?

**Yes for every targeted channel** (`06`): GitHub (only tiny academic
exact-name repos), Claude official marketplace (0 matches in the full
manifest + directory + code search), Codex openai/plugins (60 entries, no
`iaa`), ZCode official marketplace (0 matches). New fact: **npm `iaa` is
taken** (dormant third-party package) — npm is not an İAA channel, so no
rename and no slug divergence needed; recorded for the future. Final
re-check immediately before each submission is a runbook step.

## Q14. What current upstream versions were re-checked?

Claude Code 2.1.280 (npm stable tag: 2.1.267), Codex CLI 0.156.1, ZCode
3.14.3, Superpowers 6.4.1 (= current, matches tested), GLM-5.3 profile —
all with sources and access dates (`07`); documented plugin-system version
floors checked (none affects İAA; `CLAUDE_CODE_PLUGIN_DIRS` at 2.1.280 is
unused).

## Q15. Are public compatibility claims version-pinned?

**Yes** — unchanged discipline, re-verified: every TESTED row names
runtime+version+evidence; the matrix now carries an upstream-latest
context note (tested versions ≠ latest claims); Superpowers remains
pinned to 6.4.1; GSD/BMAD/Agent Teams/warp/other models remain UNVERIFIED;
no universal-compatibility language anywhere (validate-static scope check
green).

## Q16. Is README publication-ready?

**Yes** (`11` review): exact H1; all required topics present and accurate;
no marketing language; no unsupported claims (unique/first/best/
deterministic/universal/cheaper absent); portable paths throughout; this
Gate's edits: portable doctor anchor (was a deep gate-report link),
version-pin discipline wording, license-status line pointing at the
Gate-3 package. Development/audit language retained only where it builds
trust (evidence methodology) or states limitations.

## Q17. Is the web-project pack current and parity-clean?

**Yes** (`13`): all six `sources/` files re-verified byte-exact to the
current core (hashes unchanged — the core did not move); numbered docs
00/09 refreshed for Gate-2/3 resolution state (packaging shipped, trigger
model settled, Superpowers 6.4.1 local, current date framing); 07
path-normalized; MANIFEST updated with the Gate-3 parity note.

## Q18. Are release artifacts reproducible?

**Yes — after a real fix** (`08`): Gate-2's three package tarballs were
content-reproducible but NOT byte-reproducible (tree-ish `git archive`
stamps current time; proven by fresh-clone rebuild diverging at the mtime
bytes with identical extracted content). `scripts/build-release.sh` now
repacks them deterministically (commit-epoch mtime, sorted names,
normalized ownership, `gzip -n`). Verified: two independent rebuilds from
`v0.1.0-rc.1` in a fresh clone at a different path → **all four tarballs
+ SHA256SUMS byte-identical**; content parity vs the Gate-2 set proven;
canonical hashes recorded (src `a6f1a1d3…` unchanged from Gate 2). No
transient staging in any archive; one authoritative core; parity green.

## Q19. Did the final publication-safety scan pass?

**GREEN** (`09`): no secrets (deep pattern grep + automated scan), no raw
transcripts/conversation logs/eval outputs, no credential files tracked,
no emails/account-IDs/billing in file contents, machine paths per policy,
third-party/licensing posture unchanged. Two owner-visible (non-secret)
items: commit-metadata email exposure → runbook decision; LCO citation
keep/generalize.

## Q20. Did any orchestration semantics change?

**NO — D = NONE, proven by hash** (`10`): all five core files
byte-identical to `main@0d4c563` (and to every freeze table back to
`330d0c1`); all four projections + the deployed live tree byte-exact; all
18 frozen invariants map to unchanged text; category B (adapter facts) =
zero; category C (invocation mechanics) = zero. Behavioral re-exercise
where testable (6 eval sessions) confirmed materiality, zero-agent
fallback (now correctly scored), anti-overdelegation, bounded topology.
Boundary j/k not re-run — justified: no boundary-relevant byte changed and
no neighbor version moved.

## Q21. Is the 0.1.0 version flip applied or only prepared?

**PREPARED ONLY.** The exact 15-file, version-stamp-only diff is validated
(parity + static green at 0.1.0, no core files) and stored at
`release-hardening/gate-3/prepared-0.1.0-version-flip.diff`; `VERSION`
still reads `0.1.0-rc.1` on this branch. Application is runbook Phase C,
after license approval (Phase A) — pending final publication
authorization.

## Q22. Does v0.1.0-rc.1 remain intact?

**Yes**: annotated tag still dereferences to `0d4c563…`, in main ancestry,
untouched; no `v0.1.0` tag exists (verified); artifacts rebuilt FROM the
tag are content-identical to the shipped set.

## Q23. Is the repository still PRIVATE?

**Yes** (verified via API after all work: `visibility: PRIVATE`). No
marketplace submission, no visibility change, no public release.

## Q24. Is the exact publication runbook complete?

**Yes** — `PUBLICATION-RUNBOOK.md`: 27 numbered steps across 9 phases
(pre-approval → license install → deterministic checks → version flip →
main integration → tag/artifacts → visibility → GitHub release →
marketplace submissions → post-publication smoke/doctor/docs), with every
irreversible step explicitly marked (**[IRREVERSIBLE]** /
**[IRREVERSIBLE — EXTERNAL]**), namespace re-check before submissions,
per-channel fallbacks (runtime-specific slug rule), and a rollback/incident
procedure for every failure stage. NOT executed.

## Q25. What single next owner-approved action should occur?

**Approve OPTION A (MIT + NOTICE) and direct execution of
`release-hardening/gate-3/PUBLICATION-RUNBOOK.md` from Phase A.** That one
authorization sequence (license → flip → merge → tag → publish) is the
complete remaining path to a public İAA 0.1.0; every step inside it is
pre-validated by this Gate.

## Q26. Post-0.1 roadmap note — JEV optional decision-backend experiment

Recorded (NOT implemented; no architecture change; no runtime dependency):

> Evaluate Jev by TypeSafe as an OPTIONAL typed decision backend for
> İAA's materiality, seat-justification, and topology-selection gates.

Research constraints agreed for that future track: İAA retains
orchestration authority; the primary LLM retains task understanding and
final integration; native decision mode remains the baseline/fallback;
JEV starts EXPERIMENTAL and optional; benchmark native-vs-JEV before any
adoption (metrics: unnecessary delegation, missed useful delegation,
topology quality, decision latency/cost, confidence calibration, fallback
behavior); privacy/API-key/network dependencies reviewed before adoption.

---

## Execution notes (disclosed)

1. First eval-validation launch failed on YAML frontmatter (unquoted
   `colon+space` in my rewritten `expected_outcome`) — caught by the
   harness before any paid session; fixed; re-run green. The failed
   attempt cost $0 (case loading failure).
2. The determinism investigation surfaced that Gate-2's package tarballs
   were mtime-nondeterministic (gate-2's byte-identical claim held only
   for the src tarball) — fixed, verified, old vs new content parity
   proven, disclosed here and in `08`.
3. One intermediate build attempt stamped INT64_MIN mtimes (annotated-tag
   message captured instead of the epoch by `git show --format=%ct`);
   caught by tar's own warning on extraction, fixed with `git log -1
   --format=%ct` + a numeric guard; the intermediate artifacts never left
   /var/tmp and were superseded before any hash was recorded.
4. A `zcode --version` probe launched the GUI app and hung; killed;
   plugin surface mapped from state files + docs instead.
5. Research subagents: four, all read-only, evidence-only returns (no
   decisions, no writes, no git) — per §0 of the brief.

## Evidence index (gate-3/)

01-license-review · 02-historical-path-policy · 03-trigger-eval-methodology ·
04-codex-final-validation · 05-zcode-final-validation · 06-submission-name-recheck ·
07-version-recheck · 08-release-artifact-reproducibility · 09-final-publication-safety ·
10-semantic-parity · PUBLICATION-RUNBOOK · license-candidate/{LICENSE,NOTICE} ·
prepared-0.1.0-version-flip.diff. Machine-local evidence:
`/var/tmp/iaa-gate3-evals/` (eval aggregates + prepared-flip origin),
`/var/tmp/iaa-g3-codex/` (disposable Codex home + rollout),
`/var/tmp/iaa-g3-repro/` (reproducibility clone) — kept out of the
repository per the evidence-disposition policy.

---

## Verdicts

**TECHNICAL PUBLICATION READINESS: READY**

**OWNER AUTHORIZATION READINESS: READY** (awaiting the owner decisions in
Q3 — principally the license approval — before the runbook's first
irreversible step)

Then STOP. İAA remains private; nothing was published.
