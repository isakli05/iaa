# Gate 2 — 14: Core Semantic Parity After Gate 2

Date: 2026-09-23. Method: compare the Gate-2 output against the §2 semantic
freeze (base commit `330d0c1`), by hash and by change classification.

## 1. Hash proof (behavioral core)

`git show 330d0c1:<path> | sha256sum` vs the Gate-2 final worktree (and the
deployed live tree) — all **IDENTICAL**:

| File | sha256 (both sides) |
|---|---|
| `iaa/SKILL.md` | `73f7b8870a578cba5bf702c38353112c66e6c410504d89d23fb96b14930b9eba` |
| `iaa/references/delegation-contract.md` | `23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632` |
| `iaa/references/platform-adapters.md` | `849b769cf4846fede9bf624b4c36a86ee921c586c3030c0589c06c61abec82d2` |
| `iaa/tests/scenarios.md` | `5fa9617ed9eabef69ffc348d03f210fab9a2099def08c7d2ca5d9de724c705cf` |
| `iaa/scripts/manage.sh` | `21964702e3c581c721657dd6b2581aec57cbe3c853da5c86be112531dd0ccf8e` |

Every packaging projection of the core is byte-exact to these digests
(`scripts/check-parity.sh`, all five projections). The deployed runtime tree
matches. **The behavioral core did not change by one byte.**

## 2. Change classification (Gate-2 diff vs base)

| Category | Content | Scope |
|---|---|---|
| **A — packaging/infrastructure** | `packaging/**` + templates, `VERSION`, `.claude-plugin/marketplace.json`, `scripts/iaa`, `scripts/build-packages.sh`, `scripts/check-parity.sh`, `scripts/validate-static.py`, `scripts/build-release.sh`, `tests/doctor/**`, `tests/install-matrix/**`, `.github/workflows/**`, eval suites (`release-hardening/evals/gate2/**`, companion script fixes), `.gitignore` | everything new; no core file touched |
| **B — factual adapter changes** | **NONE** — `iaa/references/platform-adapters.md` is byte-identical; the only adapter-related event (E9) *confirmed* existing text, requiring no edit | zero |
| **C — invocation-mechanism changes** | new thin `orchestrate` entry skill (generated template, explicit-only, delegates to the core); `bin/iaa`; plugin-mode integration in `scripts/iaa` writes the byte-identical shim (T6 unit-proven; CI-extracted-text parity) | mechanics only; no policy text |
| **D — semantic behavior changes** | **NONE** (provably, by §1) | — |
| docs | README rewrite, new public docs, updated current-state docs (dated notes), web-pack refresh | explanatory tier |
| historical evidence | untouched (audit/, historical-notes/, comparison/, research/, design/, release-hardening/01–05, identity-migration/) | by policy |

## 3. Frozen-invariant spot table (freeze §1 → status)

Every frozen invariant maps to byte-identical policy text (§1) and was
behaviorally re-exercised this Gate where testable:

| Invariant | Text | Behavioral check this Gate |
|---|---|---|
| benefit/materiality test | unchanged | trigger-positive topology (0-or-3 agents, never rosters) |
| anti-overdelegation objective | unchanged | trivial 5/5 zero-agent; ambiguous 5/5 caps; explicit-orchestrate 3/3 zero-agent |
| zero-agent fallback | unchanged | 5/5 + 3/3 + live run |
| per-seat justification | unchanged | boundary J: 1 risk-justified reviewer only |
| adaptive topology | unchanged | J: inline+1 reviewer; K: (native mode) full SDD cadence unimpeded |
| dependency-aware shaping | unchanged | (not re-exercised — no multi-wave scenario this Gate; text unchanged) |
| read-heavy preference | unchanged | J's single spawn = Explore reviewer |
| exclusive/disjoint write ownership | unchanged | J: no concurrent same-file writers |
| primary-owned shared contracts | unchanged | J: primary integrated |
| root-to-child constraint | unchanged | no nested spawns anywhere (evals + boundary) |
| primary final integration | unchanged | J: primary validated; transcripts show primary-side verification |
| independent verification materiality | unchanged | J: one justified reviewer, not manufactured |
| orchestration-controller ownership | unchanged | **boundary J PASS** (SDD never loaded in İAA mode) |
| explicit by-name yield | unchanged | **boundary K PASS** (İAA 0 invocations) + eval yields 6/6 |
| artifact provenance/trust boundary | unchanged | boundary J: REQUIRED SUB-SKILL ignored |
| foreign-controller exclusivity | unchanged | boundary K: no second authority applied |
| "installed ≠ active controller" | unchanged | idle coexistence (matrix m2) + no auto-activation anywhere |
| non-invasiveness | unchanged | matrix m15; doctor read-only proof; uninstall scoping |

## 4. Verdict

**D = NONE.** Gate 2 changed packaging, invocation mechanics, diagnostics,
CI/evals, and documentation — and provably nothing else. No owner/design
decision was required or bypassed for semantics; the one grader-band question
(10-trigger doc) is a test-contract calibration item, explicitly left to the
owner, and the grader was deliberately left unweakened.
