# Gate 2 — 08: `iaa doctor`

Date: 2026-09-23. Implementation: `scripts/iaa` (POSIX sh, dependency-free
core; `--json` uses jq; hash comparison uses python3 when available). Shipped
identically at the repo root (`scripts/iaa`) and in the Claude plugin
(`bin/iaa` → on the Bash tool PATH while the plugin is enabled; parity-checked
byte-exact). ZCode/Codex packages document running it from a checkout.

## Invocation and contract

```
iaa doctor          # human-readable
iaa doctor --json   # machine-readable (single JSON object)
```

Exit codes (documented in output):
- `0` — healthy / informational findings only
- `1` — actionable **İAA installation** problem(s) found
- `2` — usage error

Non-zero is never used merely because an untested third-party framework exists
(framework detection is INFO). Severities: `OK`, `INFO`, `PROBLEM` (only
PROBLEM drives exit 1).

## Hard non-goals (enforced by construction + tests)

The doctor never: uninstalls anything, disables another framework, rewrites
settings, auto-fixes markers, alters another plugin, modifies hooks, logs
secrets, uploads telemetry, or creates a daemon. Read-only-ness is proven by
unit test T2 (whole-tree hash before/after unchanged).

## What it reports (checklist → implementation)

| Required item | Code(s) | How |
|---|---|---|
| İAA package version | header + `source-of-truth` | from `VERSION` (repo mode) or `PROVENANCE` (packaged mode) |
| behavioral/policy revision | header | `policy_revision: v3` (docs/POLICY-LINEAGE.md) |
| repository/source revision | header | `git rev-parse --short HEAD` when run from a checkout |
| runtime adapters detected | `skill:*`, `codex`, `zcode` | per-runtime paths under `$IAA_HOME` |
| active İAA installations | `skill:claude/codex/zcode`, `claude-plugin`, `codex-plugin`, `zcode-plugin` | link/dir scan + `installed_plugins.json` + `config.toml` |
| duplicate İAA installations | `duplicate:claude`, `duplicate:codex` | plugin + skills-dir both active; plus `backup-link:*` (see below) |
| legacy former-MAO installations | `legacy:share-dir`, `legacy:state-dir`, `legacy-shim:*`, `legacy-skill:*` | LEGACY paths/markers/names (labeled LEGACY in code) |
| stale symlinks | `stale-link:*` | dangling or SKILL.md-less targets |
| stale managed blocks | `legacy-shim:*` | pre-rename markers still present |
| marker duplication | `marker-malformed:*` | begin/end counts ≠ 1/1 or reversed — reported, never auto-repaired |
| hash drift core↔projections | `hash:live-tree`, `hash:claude-plugin`, `hash-drift:*` | sha256 vs `~/.config/iaa/provenance.json` (deploy-written) or vs the repo checkout |
| Superpowers version | `framework` (TESTED tag) | `installed_plugins.json` |
| GSD detected | `framework` (UNVERIFIED tag) | plugin name scan (`gsd*`, `bmad*`) |
| other known frameworks | `framework:*` | warp-codex plugin, agent-teams flag |
| tested coexistence status | inline on each framework line | static table: TESTED = Superpowers; others UNVERIFIED (mirrors docs/COMPATIBILITY.md) |
| unverified combinations | same lines | explicit "coexistence UNVERIFIED" |
| Claude plugin status | `claude-plugin` (+hash) | registration + cached core parity |
| Codex package/skill status | `codex-plugin`, `codex-multiagent` | config.toml registration; `[agents]` config reported read-only |
| ZCode package/plugin status | `zcode-plugin`, `skill:zcode` | plugin-workspace + skills dir |
| MultiAgent configuration | `codex-multiagent` | `[agents]` keys only, labeled not-İAA-owned |
| source-of-truth status | `source-of-truth`, `hash:live-tree` | repo/packaged/standalone + drift |

JSON output: `{"iaa_version", "policy_revision", "source_revision", "home",
"findings":[{"severity","code","detail"}…]}` — validated by unit test T11.

## The `backup-link` check (a live-observed hazard)

During Gate-2 development, an accidental real-home `manage.sh install` from a
second source moved skill links aside **inside the skills dirs** as
`iaa.iaa-backup-*` symlinks — and Claude Code promptly listed the backup as a
second loadable skill (duplicate activation, observed in the developing
session's own skill list). The doctor therefore reports any
`iaa*iaa-backup*` **symlink inside a skills dir** as a PROBLEM with the exact
removal hint. (Deeper hardening — moving link backups outside skills dirs —
is a manage.sh change, deliberately deferred as a Gate-3 candidate to keep
manage.sh byte-frozen in this Gate.)

## Tests

`tests/doctor/run-tests.sh` — 12 unit tests, all passing (2026-09-23):
empty-env health; read-only proof; legacy ×4; malformed-marker refusal (doctor
flags, integrate refuses, file untouched); plugin-mode integration (dry-run
zero-mutation; shim + depth; **no** links); **byte-parity of the managed block
between manage.sh and scripts/iaa across all three runtimes**; unintegrate
reversibility; duplicate detection; stale link; script-mode refusal from a
packaged copy; JSON validity; provenance hash-drift detection.

## Real-machine run (2026-09-23)

`scripts/iaa doctor` on this machine: exit 0, all OK/INFO — correct live-tree
parity, three healthy links, three well-formed shims, Superpowers 6.4.1
detected (TESTED), warp-codex detected (UNVERIFIED), `[agents]` config
reported read-only, spawn depth 1. No mutation.
