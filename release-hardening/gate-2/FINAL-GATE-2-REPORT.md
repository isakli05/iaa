# FINAL GATE-2 REPORT — İAA Release Hardening

Date: 2026-09-23. Controller: the main Claude Code / GLM-5.3 session, acting as
sole controller per Gate brief §0 (no İAA/SDD/GSD/Superpowers or any other
orchestration framework used as controller; no research subagents — all
research performed directly with read-only tools). Branch:
`release-hardening/gate-2` (base `330d0c1`, the approved post-identity-migration
`main`). Repository remained **PRIVATE** throughout; nothing was published to
any marketplace, directory, or public release channel; no force push; no
visibility change.

Expected outcome, checked:
**SAME İAA ORCHESTRATION SEMANTICS + ONE AUTHORITATIVE CORE + /iaa:orchestrate +
CLAUDE PACKAGE + CODEX PACKAGE + ZCODE PACKAGE + iaa doctor + LEGACY MIGRATION +
CI/EVALS + CLEAN INSTALL/UPDATE/UNINSTALL + PRIVATE RELEASE CANDIDATE.**

## Q1. What public package version model was selected?

`0.1.0` SemVer first-public-release model with a separate behavioral/policy
revision axis (`v3`) and RC identifiers `0.1.0-rc.N`; single source of truth
`VERSION` → stamped into every manifest by `scripts/build-packages.sh`, enforced
by `scripts/check-parity.sh` in CI. Historical internal lineage counts are NOT
reused as public versions. Gate 2 ships `0.1.0-rc.1`. (01-versioning-model.md)

## Q2. Is `iaa` technically valid across targeted runtime packaging?

Yes — checked 2026-09-23 against current syntax rules (Claude kebab-case; ZCode
`^[a-z0-9][a-z0-9._-]{0,127}$`; Codex convention) and live registries (GitHub
repo search; claude-plugins-official 310 plugins; codex openai-curated; ZCode
official 26; local marketplaces; superpowers skills): **no collision, no exact
conflict**; no runtime-specific slug divergence needed. Re-check at submission
time remains a Gate-3 checklist item. (02-identity-technical-validation.md)

## Q3. Is there exactly one authoritative behavioral core?

Yes. `iaa/` in the repository is the single core; `packaging/{claude,codex,zcode}`
and the dev-plugin skill copy are **generated projections** (PROVENANCE markers,
deterministic `build-packages.sh`, `check-parity.sh` byte-parity + determinism
gates in CI). No hand-edited semantic copies exist; drift fails CI.

## Q4. Is the git repository now the authoritative development source?

Yes — implemented and cut over (§6 / 04-source-of-truth-normalization.md):
`scripts/iaa deploy` (stage → byte-verify → swap → provenance.json → rollback
retained) is the only writer of `~/.local/share/iaa`; consumer links unchanged;
`iaa doctor` verifies live-tree hashes against provenance or the checkout; the
"edit live, copy back" procedure is retired in docs/SOURCE-OF-TRUTH.md.

## Q5. How is Claude Code packaged?

A generated plugin at `packaging/claude/`: `.claude-plugin/plugin.json` (name
`iaa`, displayName, version), `skills/iaa` (byte-exact core), explicit-only
`skills/orchestrate` (→ `/iaa:orchestrate`), `bin/iaa` (management CLI on the
Bash PATH), README. No MCP/agents/hooks/daemon/commands-dir. `claude plugin
validate --strict` passes with zero warnings; real install/invocation validated
in a disposable config (Q6); repo-root `.claude-plugin/marketplace.json` makes
the repository itself a Claude marketplace. (05-claude-packaging.md)

## Q6. Is `/iaa:orchestrate` real and validated?

Yes. Live run (disposable config + repo, Claude Code 2.1.274, GLM-5.3 profile):
`/iaa:orchestrate <trivial task>` resolved → `Skill: iaa:iaa` loaded → task
completed inline with **0 agent spawns**, $0.10, transcript-verified. Eval case
`explicit-orchestrate`: 3/3 in the full campaign — invocation indicator fired
3/3, zero-agent 3/3, score 1.00 (10-trigger-characterization.md). Contract documented in
docs/INVOCATION.md. It is a thin entry to the same core — no second
implementation exists.

## Q7. Is the historical global instruction shim still required?

Yes — determination **B** (explicit integration step): plugins cannot write
instruction files (structural, verified); the instruction channel is the
load-bearing routing layer of every boundary campaign (ADR-0001/0002);
the instruction channel additionally correlates with the delegation decision
itself (measured: delegation followed in 5/5 shim-sim vs 2/5 description-only
runs on the same prompt), and contest behavior is unmeasurable without it.
A SessionStart-hook injection was rejected as a semantics change. (05 §4)

## Q8. If required, how is it installed safely?

`iaa integrate --runtime claude --mode plugin`: explicit, user-run, never
invoked by plugin installation; marker-delimited ownership identical to the
tested installer (block content byte-parity unit-tested); backup before every
mutation; `--dry-run`; reversible via `iaa unintegrate`; creates **no** skill
links in plugin mode (no duplicate activation); detectable by `iaa doctor`.
Script mode delegates to the unchanged `manage.sh install`.

## Q9. How is Codex packaged?

`packaging/codex/`: official layout (`.agents/plugins/marketplace.json` at the
package root + `plugin/` with `.codex-plugin/plugin.json` + skills). Skills-dir
+ script remains the **primary** Codex form (decision D6); the plugin form is
assembled and lifecycle-validated locally on codex-cli 0.156.0 (marketplace
add/list, install → enabled + version-pinned cache, remove, marketplace
remove — no unrelated config touched). E9 closed: numeric `fork_turns: "3"`
behaviorally confirmed live. Dynamic plugin-discovery session remains the one
documented gap. (06-codex-packaging.md)

## Q10. How is ZCode packaged?

`packaging/zcode/`: option B — thin `.zcode-plugin` adapter in the official
marketplace-repo convention (`marketplace.json` + `plugins/iaa/`), i18n
descriptions, category; **passes the official zai-org validator** (fetched,
Apache-2.0, not vendored). GUI install documented as an exact manual checklist,
explicitly not claimed executed. (07-zcode-packaging.md)

## Q11. Does `iaa doctor` work?

Yes — `scripts/iaa doctor [--json]`, POSIX sh, read-only by construction
(proven by unit test: whole-tree hash unchanged), shipped identically at
repo `scripts/iaa` and plugin `bin/iaa` (parity-checked). Real-machine run:
exit 0, correct findings. 13 unit tests pass. (08-iaa-doctor.md)

## Q12. What does `iaa doctor` detect?

Package/policy/source versions; per-runtime skill installs (link/dir), Claude
plugin registration + cached-core hash parity, Codex plugin registration +
`[agents]` config (read-only), ZCode presence; duplicates (plugin+skills-dir,
and loadable backup-link symlinks in skills dirs — a live-observed hazard);
LEGACY former-MAO classes ×4; stale links; stale/duplicated/malformed markers;
core↔projection hash drift (vs provenance or checkout); Superpowers (TESTED
tag) / GSD / BMAD / warp / agent-teams (UNVERIFIED tags); spawn-depth state.
Exit codes: 0 healthy, 1 actionable İAA problem, 2 usage; never non-zero merely
for an untested framework.

## Q13. How are former-MAO legacy installations handled?

Detect → report exactly → explain (docs/LEGACY-MIGRATION.md) → migrate only on
explicit `manage.sh install` (backup-first, transactional: legacy markers
stripped with backup and replaced in-run, legacy links unlinked only when
resolving to İAA's source, state dir adopted, source tree left as historical
evidence) → verify (`manage.sh verify` + `iaa doctor`). Unit-tested (detection
×4; full transaction T13). No auto-delete anywhere.

## Q14. Is install/update/uninstall ownership safe?

Yes — the complete ownership table is documented (docs/UNINSTALL.md) and
matrix-validated: m12 (plugin+integration fully removed), m13 (reinstall), m14
(malformed markers → refuse, file untouched), m15 (user prose / foreign plugin
state / unrelated settings intact), m16 (deploy rollback). Marker-pair
integrity is validated before mutation; abort rather than guess. Update cycle
validated end-to-end (0.1.0-alpha.1 → 0.1.0-rc.1, old cache retained).

## Q15. What CI layers exist?

A: static/no-model (`static.yml`, every PR — parity, manifests, frontmatter,
doc links, ASCII names, secret scan, identity scopes, determinism, 13 doctor
unit tests, optional plugin validation + official ZCode validator fetch).
B: model evals (`model-evals.yml` — manual dispatch + weekly schedule, never on
push; two-arm trigger suite against the real package; credentials via secret).
C: real-machine companion (`boundary-companion.yml` — self-hosted
`iaa-boundary` label, dispatch-only, pre-flight gates). (09-ci-regression.md)

## Q16. What did trigger characterization show?

68 real sessions against the public package (two-arm; GLM-5.3 profile, Claude
Code 2.1.274, plugin 0.1.0-rc.1; $15.74). Headlines (10-trigger doc):
**false positives 0/13**; **false negatives on obvious positives 0/5** (skill
fired 5/5 — the Gate-1 1/2 pilot is revised as small-sample variance);
**explicit `/iaa:orchestrate` 3/3** resolution with 3/3 zero-agent fallback;
**by-name yield 6/6** (SDD-named and unknown-workflow-named); anti-overdelegation
5/5+5/5. The one sub-1.0 score (trigger-positive 0.73) decomposes into a
grader band stricter than the policy (3 in-policy 0-agent choices) + one z.ai
529 judge failure; the grader was NOT weakened — band decision recorded for
the owner. New A/B datum: description-only and shim-simulated channels both
load the skill 5/5, but delegation followed in 2/5 vs 5/5 runs — a measured
channel-dependent behavioral delta that supports keeping the explicit
integration step (Q7/Q8) while correcting the earlier "weaker triggering"
claim to "equal loading, divergent delegation choice, contest behavior
unmeasurable in-sandbox".

## Q17. Did packaged Superpowers 6.4.1 coexistence remain correct?

**Yes — j PASS + k PASS on the real machine** (12-packaged-boundary-validation.md):
J: İAA governed, SDD never loaded, REQUIRED SUB-SKILL ignored,
executing-plans used as a whitelisted inline component, 1 risk-justified
Explore reviewer ($4.71). K: SDD governed its full 6.4.1 cadence (11 agents,
identical topology to Gate 1, $7.85) with **zero** İAA invocations. One
verdict-mechanics bug in the companion's SDD grep (case sensitivity) was found
on first true end-to-end execution, fixed, and disclosed — the behavioral
evidence is transcript-derived and unaffected.

## Q18. Which installation-matrix cases passed?

m1–m3, m5, m7–m16 **PASS** (14); m4 (Codex dynamic session) and m6 (ZCode GUI)
**SKIP** as documented environment limits with prepared manual procedures.
(11-installation-matrix.md)

## Q19. What compatibility claims can honestly be published?

docs/COMPATIBILITY.md (publication matrix): TESTED — İAA alone (3 runtimes),
idle coexistence with Superpowers 6.4.1, İAA-governs boundary (incl.
adversarial artifact), explicit-SDD yield, legacy migration, Claude native
subagents, Codex MultiAgentV2 incl. numeric fork_turns. PARTIALLY TESTED —
Claude plugin channel, Codex plugin form. STRUCTURALLY COMPATIBLE — ZCode
plugin form (official validator; GUI pending). UNVERIFIED — GSD, BMAD, Agent
Teams, warp-codex, unknown plugins, non-GLM models. Known frictions documented
(duplicate forms, skillOverrides reach, trigger-overlap flank, backup-link
hazard). No universal-compatibility claim anywhere.

## Q20. Was the web-project source pack refreshed and parity-verified?

Yes — all six `sources/` files now byte-exact to the current approved core
(the three drifted pre-Gate-1 snapshots synced; sha256s recorded in MANIFEST);
numbered docs updated for repo-authoritative model + `/iaa:orchestrate`
terminology; historical documents remain historical; ASCII filenames +
Unicode prose verified (validate-static).

## Q21. Did any core orchestration semantics change?

**No — D = NONE, proven by hash** (14-semantic-parity.md: the five core files
are byte-identical to base `330d0c1`; all five projections byte-exact; the
deployed live tree byte-exact; category B = zero adapter edits — E9 only
*confirmed* existing text; category C limited to the thin entry skill and
byte-parity shim mechanics). The frozen-invariant table maps every invariant
to unchanged text plus this Gate's behavioral re-exercise where testable.

## Q22. Which publication blockers were closed?

From comparison/06 §A: **A1** (namespaced identity + duplicate detection:
plugin namespace `iaa` live-validated, doctor duplicate/backup-link checks,
install-time refusal paths), **A2** (version metadata + channel sync: VERSION →
manifests, provenance hashes, doctor drift checks), **A3** (automatable
regression: 3-layer CI wired from the Gate-1 foundation, trigger suite at n≥3
per class ⏳), **A4** (claim discipline: publication matrix shipped,
version-pinned), **A5** (adapter accuracy: Gate-1 corrections shipped through
every channel; E9 numeric fork_turns now behaviorally confirmed). Plus the
Gate-brief's own blockers: `/iaa:orchestrate` realized; source-of-truth
normalized; iaa doctor implemented; legacy migration documented+tested;
publication-safety audited; private RC assembled.

## Q23. Which blockers remain?

1. Owner decisions at publication time: repository **LICENSE** choice; handling
   of historical docs' absolute paths (accept as provenance vs generalize).
2. ZCode GUI checklist execution (needs the desktop app; prepared).
3. Codex plugin-form dynamic discovery session (needs an authenticated
   interactive disposable session; skills-dir form fully live-tested).
4. GSD/BMAD/Agent-Teams/other-model behavioral gaps — standing evidence gaps,
   deliberately not release-blocking per the brief.
5. Plugin-mode SDD-contest on the real machine — carried as PARTIALLY TESTED
   (channel carries byte-identical skill+shim; structural parity argued; not
   silently upgraded to TESTED).

## Q24. Is a PRIVATE release candidate ready?

**YES** — `v0.1.0-rc.1` tag + deterministic archives (`scripts/build-release.sh`
→ dist/*.tar.gz + SHA256SUMS, reproducible from the commit). Not published
anywhere. ⏳ pending: final commit + campaigns green.

## Q25. Is the repository ready to become PUBLIC?

**NOT YET** — honest verdict: PRIVATE RC **READY**; PUBLIC RELEASE **NOT
READY** pending: owner license decision, the ZCode GUI + Codex-dynamic legs
(optional but honesty-cheap), marketplace re-checks at submission time, and
explicit owner sign-off. No unresolved duplicate-install/namespace/source-drift/
unsafe-uninstall/controller-boundary regression exists (all tested green).

## Q26. Exact Gate-3 objective if one remains.

Execute the publication-day runbook: choose+add LICENSE (+NOTICE for the
Superpowers-derived fixture line); run the ZCode GUI checklist; run the Codex
plugin-form dynamic session; re-run marketplace name searches; flip `VERSION`
to `0.1.0`; re-run static CI + doctor + boundary companion at final versions;
owner review; then (and only then) visibility change + marketplace submissions.

## Execution incidents (disclosed, all resolved)

1. Test-development accident re-pointed the three live skill links at the repo
   for ~2 minutes (wrong env var name); restored from automatic backups,
   verify green; produced two hardening outcomes (env propagation fix; new
   doctor backup-link check). Full account: 11 §"Accidental live-machine
   incident".
2. Latent Gate-1 companion-script bugs found and fixed when first truly
   executed (`local a=$1 b=$a` under `set -u`; REPO_ROOT off-by-one;
   fixture-commit no-op) — the script had been formalized but not executed
   end-to-end before.
3. A `git add -A` briefly committed transient eval staging under
   `packaging/claude/evals/`; untracked + gitignored; race with the parity
   rebuild closed by a skip-when-staged guard.

## Evidence index (gate-2/)

00-semantic-freeze · 01-versioning-model · 02-identity-technical-validation ·
03-package-architecture · 04-source-of-truth-normalization · 05-claude-packaging ·
06-codex-packaging · 07-zcode-packaging · 08-iaa-doctor · 09-ci-regression ·
10-trigger-characterization · 11-installation-matrix · 12-packaged-boundary-validation ·
13-publication-safety · 14-semantic-parity. Machine-local campaign evidence:
`/var/tmp/iaa-gate2-evals/`, `/var/tmp/iaa-gate2-boundary/` (kept out of the
repository per the evidence-disposition policy).
