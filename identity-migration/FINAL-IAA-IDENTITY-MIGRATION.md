# FINAL — İAA Identity Migration Report (2026-09-23)

Branch `identity/iaa-rename` (base `122dcf1`, Gate 1). Controller: main Claude Code /
GLM-5.3 session, no orchestration framework, no subagents. Repository remained PRIVATE
throughout; nothing was published.

## 1–3. Final identity

- **Human-readable name:** `İAA — İştirak-i A‘mâl-i Ajanîye` (byte-exact; capital dotted
  İ, em dash, U+2018 in `A‘mâl`, `Ajanîye`). Short name: `İAA`.
- **Technical identifier:** `iaa` (repo slug, skill name, plugin namespace, filesystem
  identifiers, machine IDs).
- **Public invocation reserved for Gate 2:** `/iaa:orchestrate`. Not faked today: the
  current standalone invocation is the skill `iaa` (Claude `/iaa`, Codex/ZCode implicit +
  `$iaa`); the plugin command name arrives with Gate-2 packaging. Recorded in
  docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md and comparison/08-D5.

## 4–6. Final locations

- Maintained repo: `/home/isa/projects/iaa` (plain `mv`; same `.git`, verified).
- Live canonical source: `~/.local/share/iaa/` = `README.md` + `iaa/` skill tree,
  byte-identical to repo `iaa/` + `CANONICAL-README.md` (hash/diff verified).
- GitHub: `https://github.com/isakli05/iaa`.

## 7–8. GitHub operation

**Renamed** (never deleted/recreated): `gh repo rename iaa --repo
isakli05/multi-agent-orchestration`. Chosen because rename preserves all history,
branches, and repo state and leaves redirects from the old URL; verified prerequisites
(authenticated as `isakli05`; `isakli05/iaa` did not exist; old repo private with
expected branches). Post-checks: private ✓, default branch `main` ✓, fetch ✓,
push dry-run ✓, old URL redirects ✓, description updated to the İAA form ✓.

## 9. Active runtime paths (before → after)

| Before | After |
|---|---|
| `~/.local/share/ai-agent-orchestration/multi-agent-orchestration/` | `~/.local/share/iaa/iaa/` |
| `~/.local/share/ai-agent-orchestration/README.md` | `~/.local/share/iaa/README.md` |
| `~/{.claude,.agents,.zcode}/skills/multi-agent-orchestration` (3 symlinks) | `…/skills/iaa` → `../../.local/share/iaa/iaa` |
| `~/.config/ai-agent-orchestration/` | `~/.config/iaa/` |

Skill frontmatter `name: multi-agent-orchestration` → `name: iaa`; H1 → full display
name; `MAO mode` → `İAA mode` (SKILL.md + platform-adapters.md). Migration executed
transactionally by the new `manage.sh install` (rollback backups first): legacy state
migrated, links relinked, dangling legacy links unlinked, legacy shims stripped with
backup, new shims written, spawn-depth untouched, `verify` green. Rollback snapshot:
`~/iaa-identity-migration-rollback-20260923T014102+0300/` (live tree, state dir, all
three managed files, pre-migration hashes).

## 10. Managed markers / state

Markers `<!-- BEGIN/END managed: multi-agent-orchestration -->` → `<!-- BEGIN/END
managed: iaa -->`; block heading → `## İAA orchestration`; body references the `iaa`
skill; wording otherwise identical. Exactly one marker pair per file
(~/.claude/CLAUDE.md, ~/.codex/AGENTS.md, ~/.zcode/AGENTS.md); zero legacy markers
remain. State file `claude-depth.state` moved to `~/.config/iaa/` (content preserved).
Future backups: `<file>.iaa-backup-<stamp>`; historical `*-backup-*` files untouched.

## 11. Development plugin / evals

`release-hardening/evals/mao-dev-plugin/` → `release-hardening/evals/iaa-dev-plugin/`;
plugin.json `mao-dev` → `iaa-dev`; skill copy `skills/iaa` (byte-identical to canonical,
re-verified); graders `mao-*.md` → `iaa-*.md`; grader regex matches `(?:[\w-]+:)?iaa`;
companion script vars `mao/expect_mao` → `iaa/expect_iaa` with labeled LEGACY transcript
matching. Static validation: `claude plugin validate` passes (one pre-existing author
warning); Codex `quick_validate.py` → "Skill is valid!". No eval semantics, graders,
prompts, or expected behavior changed beyond product-name substitution.

## 12. Current documentation updated

README.md, CANONICAL-README.md (root + live + web copy, with provenance note), docs/
(16 files incl. IAA-VS-SDD-BOUNDARY.md rename), comparison/ (16), research/ (3),
design/, release-hardening current-state docs (04, 05, FINAL-GATE-1-REPORT), web pack
(18 files incl. 2 renames + MANIFEST), scripts/help text, GitHub description. First
introductions carry the full display name; prose uses `İAA`; technical IDs `iaa`.
Generic lowercase "multi-agent" prose, third-party product names, and Codex
"multi-agent" feature terms were deliberately left alone.

## 13. Historical evidence intentionally unchanged

`audit/` (7), `historical-notes/` (8), `release-hardening/01–03`, `tests/fixtures/`,
eval `results/` (gitignored), `~/mao-sdd-archfix-20260827/`,
`~/mao-sdd-artifact-boundary-20260827/`, `~/mao-sp641-upgrade-check-20260922/`, the 10
old-named config backups, all session transcripts (~/.claude/projects etc.), LCO
foreign-repo filename `01-BASELINE-AND-MAO-TOPOLOGY.md`.

## 14. Remaining old-name occurrences

Fully enumerated and justified in `OLD-NAME-REMAINING-REGISTER.md` (repo) and
`04-post-migration-name-audit.md` (machine + services). Zero MISSED RENAME findings.

## 15. Semantic immutability

`03-semantic-immutability.md`: SKILL.md, delegation-contract.md, platform-adapters.md,
scenarios.md, and dev-plugin copies are **IDENTICAL** after normalizing only the §16
identity tokens — materiality test, zero-agent fallback, seat-by-seat justification,
adaptive topology, dependency handling, ownership, integration responsibility, reviewer
policy, root-to-child rule, artifact trust boundary, foreign-controller yield, and SDD
boundary are provably unchanged. manage.sh/companion residuals are identity tokens plus
explicitly-labeled LEGACY migration code only.

## 16. Runtime validation

`manage.sh verify`: all green (3 links, 3 shims, spawn depth 1, description length 249).
No stale old-name symlinks; no double-load path (single active skill dir per consumer);
live/repo/dev-plugin copies hash-identical; running Claude session re-resolved the skill
as `iaa`. Codex/ZCode statically verified (marker pairs, AGENTS.md blocks, link
targets). No model campaigns re-run (not needed — discovery verified statically and by
the live session).

## 17. Git / GitHub validation

Branch based exactly on `122dcf1`; commits: `5930649` (identity migration) + this
report commit. `git diff --check` clean apart from one pre-existing trailing space
(verified pre-existing). Secret scan clean; no raw transcripts added; no unrelated
modifications (whole-repo normalized residual review). Pushed `identity/iaa-rename` to
the renamed private repo; Gate-1 commit remains in ancestry; no force push; branches
`main` and `release-hardening/gate-1` untouched.

## 18. Unresolved / noted (none blocking)

- `web-project-sources/sources/` pre-existing pre-Gate-1 content drift: `SKILL.md`
  (`fee98091…`), `references-platform-adapters.md`, `tests-scenarios.md` remain the
  pack's original snapshots (identity tokens updated only). `scripts-manage.sh`,
  `references-delegation-contract.md`, and `CANONICAL-README.md` are byte-identical to
  the canonical tree (the installer copy was synced to include the LEGACY migration
  guards after a post-commit security review flagged the missing-gate parity — all four
  manage.sh copies hash `21964702…`). MANIFEST carries an explicit parity-status note.
- Companion harness `REPO_ROOT` off-by-one vs its comment (pre-existing, identical
  behavior pre/post rename) — for Gate-2 wiring.
- `~/.codex/config.toml` stale `/tmp` project entries (legacy residue, left untouched).
- This Claude session's in-memory skill list refreshed to `iaa`; any other
  long-running agent sessions predating the rename will pick up `iaa` on restart.
- Claude Code project-scoped data (memory/transcripts) still lives under the old
  project-path key `-home-isa-projects-multi-agent-orchestration`; harness-owned, not
  product identity — new sessions under `/home/isa/projects/iaa` use the new key.

## 19. Gate-2 readiness statement

The identity migration is complete and validated: one unambiguous CURRENT identity —
**İAA — İştirak-i A‘mâl-i Ajanîye / `iaa`** — across local development
(`/home/isa/projects/iaa`), live runtime integration (`~/.local/share/iaa`, three
consumers), documentation, GitHub (`isakli05/iaa`, private), tests/evals
(`iaa-dev-plugin`), and forward-looking release material (`/iaa:orchestrate` recorded as
the final public invocation). Historical evidence preserves the former MAO name only
where rewriting would falsify provenance. **Gate 2 may begin** (plugin packaging on the
`iaa` namespace, `iaa doctor`, eval/CI wiring, Codex/ZCode live legs) upon owner review
of this migration.
