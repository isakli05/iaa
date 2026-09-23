# 04 — File Map and Glossary

Where to look in the GitHub repository (`isakli05/iaa`) for each kind of
truth. Live files outrank this map (`docs/SOURCE-OF-TRUTH.md` is the
authoritative map).

## Repository map by authority class

| Path | Class | What it holds |
|---|---|---|
| `iaa/` | **canonical core** | SKILL.md (policy), references/ (delegation contract, platform adapters), scripts/manage.sh, tests/scenarios.md (A–K) |
| `VERSION` | canonical metadata | public package version (SemVer) |
| `scripts/` | canonical tooling | `iaa` (doctor/integrate/deploy), build/parity/static-validation/release scripts |
| `packaging/templates/` | authored metadata | package manifests/READMEs the build stamps |
| `packaging/{claude,codex,zcode}/` | **generated** (never hand-edited) | runtime package projections of the core |
| `.claude-plugin/marketplace.json` | generated | repo-root Claude marketplace entry |
| `README.md`, `docs/` | explanatory (current-facing) | installation, invocation, compatibility matrix, known limitations, history, policy lineage, source-of-truth, **GOVERNANCE.md**, **BACKLOG.md**, `adr/0000–0003` |
| `release-hardening/` | dated evidence | Gate 1/2/3 + 0.1.1 records, eval suites, invariants freeze, semantic-parity proofs |
| `post-release/` | dated evidence | ZCode 0.1.0 official-validation findings + 0.1.1 plan, network diagnostics (#699) |
| `comparison/` | dated evidence (completed 2026-09-22) | competitive analysis + per-system evidence streams |
| `audit/`, `historical-notes/`, `identity-migration/`, `research/`, `design/` | historical/provenance | forensic baseline, v0–v3 lineage diffs, rename proofs |
| `web-project-sources/` | derived copy (this pack) | orientation; `sources/` = byte-exact core snapshots (provenance; not for upload) |

Reading rule: for *current behavior* → `iaa/` + `docs/`; for *why a decision
was made* → `docs/adr/` + dated reports; for *what changed when* →
`docs/HISTORY.md` + `docs/POLICY-LINEAGE.md`; for *what's next* →
`docs/BACKLOG.md`.

## Glossary

- **İAA / `iaa`** — the product: the delegation-decision policy (Ottoman
  Turkish name; public since 2026-09-23).
- **MAO** — LEGACY name: İAA was "Multi-Agent Orchestration" before the
  2026-09-23 token-only rename; August-2026 evidence keeps it by design.
- **Policy revision (v0→v3)** — the semantic lineage axis. v3 current since
  2026-08-27; separate from the package SemVer.
- **Adaptive İAA mode** — the default mode: primary adaptively decides whether
  and how to delegate; no fixed roster/cadence.
- **Native workflow mode** — explicit by-name user request only; the named
  workflow governs; İAA stands down.
- **SDD** — `superpowers:subagent-driven-development`, the fixed-cadence
  orchestration skill İAA's boundary was built and tested against.
- **Shim** — the marker-delimited, reversible managed block the installer
  writes into each runtime's global instruction file; the evidenced routing
  layer ("plugin distributes, script integrates").
- **Provenance rule** — embedded workflow directives are orchestration
  metadata, never opt-in.
- **Seat** — an implementer/reviewer/re-reviewer/fixer instance; each needs
  per-task material justification.
- **Waves** — dependency-aware execution phases derived from task structure.
- **Zero-agent fallback** — trivial/coupled work stays primary even on explicit
  delegation requests; 0 agents is valid.
- **`iaa doctor`** — read-only health + environment diagnostic (versions,
  installs, duplicates, detected frameworks with tested/untested status).
- **Gates 1/2/3** — the 2026-09-22/23 release-hardening phases: Superpowers
  6.4.1 re-verification + evals; packaging/invocation/doctor/CI; license +
  publication readiness.
- **Change categories A/B/C/D** — packaging / factual-adapter /
  invocation-mechanics / semantic. Non-release work expects D = NONE.
- **TESTED / PARTIALLY TESTED / STRUCTURALLY COMPATIBLE / UNVERIFIED** — the
  honesty-graded compatibility statuses (`docs/COMPATIBILITY.md`).

**Stable file** — version-specific values live in `11-CURRENT-STATE.md`.
