# Gate 3 — 10: Core Semantic Parity After Gate 3

Date: 2026-09-23. Method: compare the Gate-3 branch (through the final
Gate-3 commit) against the approved base
`main@0d4c5631132ad94968d884358c70defe1a288c3f` (= `v0.1.0-rc.1`), by hash
and by change classification. Expected category: **D = NONE**.

## 1. Hash proof (behavioral core, base vs Gate-3 worktree)

`git show 0d4c563:<path> | sha256sum` vs worktree — all **IDENTICAL**
(and identical, in turn, to the Gate-2/Gate-1 freeze tables back to the
post-migration base `330d0c1`):

| File | sha256 (both sides) |
|---|---|
| `iaa/SKILL.md` | `73f7b8870a578cba5bf702c38353112c66e6c410504d89d23fb96b14930b9eba` |
| `iaa/references/delegation-contract.md` | `23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632` |
| `iaa/references/platform-adapters.md` | `849b769cf4846fede9bf624b4c36a86ee921c586c3030c0589c06c61abec82d2` |
| `iaa/scripts/manage.sh` | `21964702e3c581c721657dd6b2581aec57cbe3c853da5c86be112531dd0ccf8e` |
| `iaa/tests/scenarios.md` | `5fa9617ed9eabef69ffc348d03f210fab9def08c7d2ca5d9de724c705cf` |

Every projection of the core is byte-exact to these digests
(`scripts/check-parity.sh`, all four projections, re-run green this Gate
including the regeneration-determinism step), and the deployed live tree
`~/.local/share/iaa/iaa` is `diff -r`-identical to the repo core. **The
behavioral core did not change by one byte through Gate 3.**

## 2. Change classification (Gate-3 diff vs base)

| Category | Content | Scope |
|---|---|---|
| **A — packaging/infrastructure** | `scripts/build-release.sh` (deterministic package-tarball repack; §14); eval suites (`release-hardening/evals/gate3/**`, corrected `min: 0` cap graders, dev-suite README inventory table); refreshed local `dist/` artifacts (untracked) | no core file touched |
| **B — factual adapter changes** | **NONE** — `platform-adapters.md` byte-identical; Gate-3 validations *confirmed* existing assumptions (Codex plugin-channel discovery; fork_turns semantics in 0.156.0's own developer context) | zero |
| **C — invocation-mechanism changes** | **NONE** — no new entry points, no manifest/skill surface changes (manifests untouched: version remains 0.1.0-rc.1 everywhere) | zero |
| **D — semantic behavior changes** | **NONE** (provably, by §1) | — |
| docs | README + docs/COMPATIBILITY (Codex plugin row → TESTED with Gate-3 evidence; upstream-context note), docs/HISTORICAL-EVIDENCE-DISPOSITION (path normalization), web-project pack (00/09/MANIFEST refresh), new `release-hardening/gate-3/**` records | explanatory tier |
| historical evidence | untouched (audit/, historical-notes/, comparison/, research/, design/, identity-migration/, gate-1/gate-2 reports — including their absolute paths per the class-A policy) | by policy |

The prepared-but-NOT-applied 0.1.0 version flip
(`prepared-0.1.0-version-flip.diff`) touches 15 version-stamp lines and
zero core files — validated in a scratch clone only; not part of any
Gate-3 commit's tree state beyond the recorded diff artifact.

## 3. Frozen-invariant table (freeze §1 → status)

Every invariant maps to byte-identical policy text (§1). Behavioral
re-exercise this Gate where testable:

| Invariant | Text | Behavioral check this Gate |
|---|---|---|
| benefit/materiality test | unchanged | forced-benefit class: benefit materialized into exactly-one-worker-per-module 3/3 |
| anti-overdelegation objective | unchanged | caps respected in all 6 eval sessions (0 or 3 agents, never >3, both tool names) |
| zero-agent fallback | unchanged | trigger-positive run1: 0 agents **scored PASS** under the corrected grader — the fallback is now correctly recognized by the suite, not penalized |
| per-seat justification | unchanged | forced-benefit: no unjustified 4th seat in any run (max 3 = fixture contract) |
| adaptive topology | unchanged | 0-or-3 adaptive split persists on the small-module class (unchanged behavior vs Gate 2) |
| dependency-aware shaping | unchanged | not re-exercised (no multi-wave scenario; text unchanged) |
| read-heavy preference | unchanged | class-C workers were read-only analyses |
| exclusive/disjoint write ownership | unchanged | read-only fixtures; no writers |
| primary-owned shared contracts | unchanged | synthesis owned by primary in all runs (rubric-verified coverage) |
| root-to-child constraint | unchanged | no nested spawns in any session |
| primary final integration | unchanged | synthesis-rubric PASS requires primary-integrated final answers |
| independent-verification materiality | unchanged | no manufactured reviewers observed |
| orchestration-controller ownership | unchanged | not re-run (no boundary-relevant change; Superpowers still 6.4.1 — no re-verification trigger); evidence basis: Gate-2 §17 j/k PASS |
| explicit by-name yield | unchanged | same as above (Gate-2 eval yields 6/6 + k PASS stand) |
| artifact trust boundary | unchanged | no boundary-relevant change; Gate-2 §17 evidence stands |
| foreign-controller exclusivity | unchanged | Codex live probe: plugin channel injects skill only, no second authority |
| "installed ≠ active controller" | unchanged | disposable Codex home: plugin installed, no auto-seizure; zero-agent probe clean |
| non-invasiveness | unchanged | all Gate-3 validations in disposable homes; real machine untouched except the documented `dist/` refresh |

## 4. Boundary-companion non-re-run justification

Gate 3 changed no projection bytes, no live-tree bytes, no neighbor
version (Superpowers 6.4.1 remains latest — 07-version-recheck). The
re-verification discipline (version movement or boundary-relevant change)
is therefore not triggered; re-running j/k (~$12) would re-measure an
unchanged configuration. Carried as an optional release-day confidence
step in the runbook (Phase B8).

## 5. Verdict

**D = NONE.** Gate 3 changed release methodology (evals, determinism,
documentation, licensing preparation) and provably nothing in İAA's
orchestration behavior. No owner/design decision was bypassed; the one
deliberate test-contract change (grader `min: 0`) makes the suite MATCH
the policy it always claimed to test — the policy itself was not touched.
