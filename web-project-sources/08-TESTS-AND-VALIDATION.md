# 08 — Validation and Release Principles

Authoritative docs on GitHub: `docs/TESTING-AND-VALIDATION.md`,
`docs/COMPATIBILITY.md`, `docs/GOVERNANCE.md` §5–6. This file condenses both
the validation stack and the release discipline the repository holds itself to.

## The validation stack (built across campaigns + Gates 1–3)

1. **Static CI (layer A)** — `scripts/validate-static.py`: SKILL/command
   frontmatter (incl. the 250-byte ZCode description budget), docs link
   checks, ASCII paths, secret scan, former-name scope check; plus
   `scripts/check-parity.sh` (byte-parity of every core projection and the
   remote marketplace sha pin) and unit/matrix tests (`tests/doctor/`,
   `tests/install-matrix/`).
2. **Model evals (layer B)** — `claude plugin eval` suites: trigger-positive,
   anti-overdelegation, ambiguous-delegation, explicit-entry zero-agent,
   SDD-yield cases (`release-hardening/evals/`).
3. **Behavioral companion (layer C)** — scenario contract A–K
   (`iaa/tests/scenarios.md`) executed in disposable repos with
   transcript-based verification (`tests/tools/analyze_run.py`); boundary
   regression (scenario J: SDD never loads in İAA mode) re-run after every
   Superpowers upgrade.
4. **GUI acceptance (ZCode)** — owner-executed desktop checklist with
   filesystem byte corroboration (`release-hardening/0.1.1/`).
5. **`iaa doctor`** — read-only environment diagnostic; never mutates, never
   fails merely because an untested framework exists.

## Scenario execution record (summary)

- A–E (trivial/exploration/overlapping-write/explicit/implicit): executed at
  install (Codex), passed after one policy tightening.
- J (mode separation) / K (native opt-in): executed across campaigns, eras,
  and Gate re-runs — J additionally with the adversarial plan fixture; K with
  full 11–15-agent SDD cadences.
- F/H/I: never run as controlled scenarios — DOCUMENTED-only gaps
  (backlog IAA-BL-003); F's rejection side incidentally proven everywhere.
- G: superseded — the real SDD collision was tested far harder.

## Release principles (binding)

- **Version-pinned claims.** Every compatibility claim names exact tested
  versions; "latest" is a different claim. Upstream movement invalidates
  affected TESTED rows until regression re-runs (standing item IAA-BL-011).
- **Behavioral vs structural evidence.** Installs/validators prove structure;
  only transcripts/evals prove behavior. Structurally compatible is never
  reported as tested.
- **Semantic parity, category D = NONE.** Non-semantic work proves the core
  unchanged by hash (six core files, sha256-pinned; `git diff` between tags
  over `iaa/` + `scripts/iaa` empty for 0.1.0→0.1.1). Any D ≠ NONE requires
  the policy-revision bump + invariant justification first.
- **Deterministic packaging.** Release artifacts are content-deterministic
  builds; two-run byte-identical proofs and the ZCode `plugin.zip`'s byte
  parity with the upstream official builder's output hold within one zlib
  implementation (both evidence runs were same-environment). Compressed
  archive bytes are zlib-implementation-dependent; CI verifies
  archive-content parity against the published-artifact record (IAA-BL-016).
- **Publication safety.** Irreversible actions (tag, release, upstream PR,
  public posts) require explicit owner authorization; release assets are
  re-downloaded and sha-verified after upload; immutable tags are never
  touched.
- **Evidence before assertion.** No invented test evidence; gaps stay labeled
  until closed.

**Stable file** — current validation statuses are read live from GitHub
(`docs/COMPATIBILITY.md`, `docs/TESTING-AND-VALIDATION.md`).
