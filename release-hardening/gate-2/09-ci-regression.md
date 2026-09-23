# Gate 2 — 09: CI Regression Architecture

Date: 2026-09-23. Three cleanly separated layers, wired from the Gate-1
foundation. Workflows live in `.github/workflows/` (repository is private;
nothing runs until the owner enables Actions).

## Layer A — static / no-model (`static.yml`, every PR + branch push)

| Brief requirement | Implementation |
|---|---|
| manifest validation | `scripts/check-parity.sh` (JSON parse + name/version/identity) + `claude plugin validate --strict` when the CLI exists on the runner |
| frontmatter validation | `scripts/validate-static.py` (name/description, ≤1024 spec limit, ≤250 ZCode budget for the core) |
| package structural validation | `check-parity.sh` projection file-set + PROVENANCE presence |
| one-core parity check | `check-parity.sh` byte-exact compare of all 4 projections vs `iaa/` |
| generated-copy drift detection | `check-parity.sh` determinism step: rebuild must leave a clean tree |
| shell/static lint | `sh -n` over every POSIX script in the run block |
| `iaa doctor` unit tests | `tests/doctor/run-tests.sh` (13 tests, disposable `IAA_HOME` sandboxes) |
| legacy-migration unit tests | T3 (detection ×4) + T13 (transactional migration: markers replaced, links swapped, state adopted, backup kept) |
| secret scan | `validate-static.py` pattern set (keys, tokens, bearers, private keys, credential assignments) |
| docs filename/link validation | `validate-static.py` (relative-link resolution in docs/ + README; ASCII filesystem names) |
| version metadata consistency | `check-parity.sh` (every manifest == `VERSION`) |
| package identity consistency | `check-parity.sh` (every manifest name == `iaa`; `bin/iaa` == `scripts/iaa`) |
| no active former-MAO identity outside legacy/history scopes | `validate-static.py` scope allowlist (audit/historical/comparison/… + LEGACY-labeled code lines) |

Runner needs: sh, jq, python3, git (all stock on ubuntu-latest). No Claude CLI
required (graceful skip with explanation), no secrets, no network beyond the
optional official-ZCode-validator fetch.

## Layer B — model-call evals (`model-evals.yml`)

- Trigger: **manual dispatch** (with a case-glob filter) + a weekly schedule
  (Mondays 04:23 UTC, deliberately off the :00 mark). Never on push — real
  sessions cost real money and add noise to trivial commits.
- Content: the Gate-2 trigger suite (§15) — `release-hardening/evals/gate2/
  run-gate2-trigger-suite.sh` stages the cases into `packaging/claude/evals/`
  and runs `claude plugin eval` with two-arm ablation (plugin vs no-plugin
  control) and JSON output; results uploaded as artifacts.
- Credentials: `CLAUDE_EVAL_CREDENTIALS` secret → disposable
  `$HOME/.claude/.credentials.json` (env-indirected, never inlined into run
  scripts). Model/provider/version recorded in every aggregate (harness
  records the model string; provider profile documented in the trigger doc).
- Dormant boundary cases (J/K/D co-load) remain in the dev plugin at full
  strength, NOT weakened proxies (Gate-1 finding: the sandbox cannot co-load
  Superpowers).

## Layer C — real-machine coexistence companion (`boundary-companion.yml`)

- Trigger: manual dispatch only, on a **self-hosted runner labeled
  `iaa-boundary`** — the tests require the actual machine configuration
  (shim + personal skill + Superpowers + provider auth) and cost ~$3–12 per
  case. No pretense that a hosted runner or the plugin-eval sandbox could run
  these.
- Content: `run-boundary-companion.sh` (j/k/d) — İAA-owns case (J: SDD never
  loads, REQUIRED SUB-SKILL ignored), explicit-SDD yield (K), adversarial
  artifact header (D) — transcript tool-event assertions via
  `tests/tools/analyze_run.py`, non-zero exit on any boundary failure.
- Pre-flight gates: Superpowers registration check + `manage.sh verify` +
  `iaa doctor` before spending anything.

## What deliberately does NOT gate PRs

Model evals, boundary companion, and any behavioral claim — those are release
gates / scheduled regressions. A green PR CI proves packaging/structure/
static-hygiene only; installation success never equals orchestration
compatibility.
