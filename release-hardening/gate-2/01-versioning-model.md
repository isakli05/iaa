# Gate 2 — 01: Versioning Model

Date: 2026-09-23. Decision context: Gate brief §3. İAA has a historical internal
policy lineage (v0→v3, see `docs/HISTORY.md` and `historical-notes/v0-v3-lineage/`)
that **predates public versioning**; no public package has ever been released.

## Decision

**A. Public package version: `0.1.0`** (SemVer; clean first-public-release model).

- The internal lineage count (v3) is deliberately NOT reused as a public semantic
  version: `3.0.0` would imply public v1/v2 releases that never existed. The brief
  mandates this unless technically justified; no such justification exists.
- `0.1.0` signals early public development honestly: pre-1.0 SemVer explicitly allows
  incompatible changes between minor versions, which matches İAA's real state
  (adaptation to host-runtimes still evolving).
- The single source of truth is the repo-root `VERSION` file; `scripts/build-packages.sh`
  stamps it into every package manifest, and `scripts/check-parity.sh` fails on any
  manifest whose version differs from `VERSION`.

**B. Behavioral/policy revision: separate axis, `policy v3`.**

- The behavioral core carries its lineage in documentation, not in the package version:
  policy v0→v1→v2→v3 (2026-08-26/27 campaigns), v3 unchanged since 2026-08-27;
  Gate 1 corrected adapter-fact sentences with invariants proven unchanged;
  the identity migration was token-only (see `identity-migration/03-semantic-immutability.md`).
- Recorded in `docs/POLICY-LINEAGE.md` (new) and surfaced by `iaa doctor`
  (`policy-revision: v3`) from `scripts/iaa`.
- Rationale: the package version answers "which distribution artifact is this?";
  the policy revision answers "which delegation semantics does it carry". Conflating
  them would force a package bump on every doc fix or silently misreport semantics.

**C. Tested runtime matrix (version-pinned, as of 2026-09-23):**

| Runtime | Tested version | Note |
|---|---|---|
| Claude Code | 2.1.274 | plugin validate/eval/install surface used by Gate 2 |
| OpenAI Codex CLI | 0.156.0 | upgraded locally since Gate 1 (docs said 0.154.0); plugin CLI present |
| ZCode | 3.11.2 installed (adapter text anchored to 3.7.7 behavior) | GUI-only plugin install; static validation in Gate 2 |
| Superpowers | 6.4.1 | boundary re-validated in Gate 1; packaging parity re-checked in Gate 2 §17 |
| Model | glm-5.3 (z.ai provider profile) | all behavioral evidence single-model |

**D. Tested competitor matrix:**

| Framework | Status |
|---|---|
| Superpowers / SDD 6.4.1 (Claude) | TESTED (Gate 1 + Gate 2 §17) |
| GSD / gsd-core | UNVERIFIED (not installed; no behavioral evidence) |
| BMAD | UNVERIFIED |
| Claude Agent Teams | UNVERIFIED (flag-gated, off locally) |
| Unknown orchestration plugins | UNVERIFIED by design; `iaa doctor` reports detection |

**E. Release-candidate identifier: `0.1.0-rc.N` (SemVer pre-release).**

- Gate 2 ships `0.1.0-rc.1` (the `VERSION` file at merge time). The first public
  release flips `VERSION` to `0.1.0` (owner action, Gate 3 / release day).
- SemVer pre-release ordering gives `0.1.0-rc.1 < 0.1.0`, so tooling treats the RC
  correctly as pre-1.0/stable-0.1.0's predecessor. This follows the SemVer
  "version-core with pre-release" form exactly; no custom scheme invented.
- Claude plugin `version` accepts it (SemVer); ZCode requires manifest==marketplace
  version (enforced by build script); Codex manifests carry plain versions — the
  Codex package is script-primary in Gate 2 and its manifest is generated with the
  same string for consistency.

## Consistency enforcement (CI, §14 layer A)

1. `VERSION` is the only place a human edits the version.
2. `scripts/build-packages.sh` writes/refreshes all manifests from `VERSION`.
3. `scripts/check-parity.sh` re-verifies every manifest version == `VERSION`, and
   that behavioral projections are byte-exact to `iaa/`.
4. The RC tag `v0.1.0-rc.1` is created only from a tree where 1–3 pass (§21).

## What this model deliberately does NOT claim

- No implication that public v1/v2 existed.
- No coupling between policy revision and package version (a `0.1.1` could carry
  policy v3; a hypothetical future `0.2.0` would document its policy revision in
  `docs/POLICY-LINEAGE.md`).
- No channel claiming to be "stable" before `1.0.0` exists.
