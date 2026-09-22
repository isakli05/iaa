# Design — `iaa doctor` Compatibility Diagnostic (PROPOSAL, not implemented)

Status: proposal only. An equivalent diagnostic does **not** exist today — the closest are
`manage.sh verify` (self-integrity only: 3 links, 3 shims, depth, description length) and
`quick_validate.py` (skill format). This document defines scope for a future read-only
diagnostic; per the task's freeze mandate, nothing is implemented in the baseline.

## Purpose

REPORT, never mutate: one command that answers "is this İAA installation healthy, and what
else on this machine can claim orchestration authority?"

## Proposed checks (output contract: findings + severity + evidence, exit code nonzero only
on İAA-self problems)

**Self (extends `manage.sh verify`):**
- canonical tree present; hashes of SKILL.md/references vs recorded baseline
- each expected symlink resolves to canonical (report stale/broken/foreign-target links)
- shim marker health per runtime file (exactly one well-ordered pair)
- depth-key ownership state (managed-absent / preserve-existing / user-changed drift)
- description length vs the strictest documented injection limit (fixing the known
  1024-vs-~250 gap flagged in CURRENT-ARCHITECTURE §13)

**Environment (read-only discovery):**
- duplicate İAA installations (any other dir whose SKILL.md carries the İAA name/frontmatter;
  report path + hash relationship: identical/ancestor/divergent)
- known orchestration frameworks present: Superpowers (+version per cache), SDD skill
  presence, GSD markers, BMAD markers, agent-teams/daemon rosters, other skills whose
  descriptions match the delegation trigger surface (Class-3 scan)
- per detected framework: install scope, namespace, hook presence (SessionStart etc.),
  trigger-description overlap rating
- Claude/Codex/ZCode config surfaces: which global instruction files exist, which carry
  managed blocks (any manager's), env keys affecting nesting (spawn depth)

**Coexistence status table:** for each detected pair (İAA × framework): tested-together?
(documented evidence link) / documented-only / unknown — mirroring docs/COMPATIBILITY-MATRIX.
Unknown ⇒ explicit "compatibility NOT proven" line, never a silent pass.

**Explicit non-goals (hard constraints):** never uninstall/disable/rewrite another plugin or
framework; never modify user settings; never "repair" a foreign symlink; never auto-fix
anything — diagnostics and exit codes only, with the exact manual command for each finding.

## Design notes

- Belongs in `scripts/` of the public repo (POSIX sh, same style as manage.sh) or as a skill
  subcommand; keep it dependency-free (jq already required by manage.sh).
- The Class-3 trigger-overlap scan is necessarily heuristic (description substring/rule
  table); label results HEURISTIC, never CONFIRMED, unless backed by a behavioral test
  artifact.
- Versioned known-framework table (name → detection signature → tested status) so the doctor
  itself doesn't go stale silently.
