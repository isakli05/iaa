# Audit 01 — Exhaustive MAO Footprint Inventory

Discovery date: 2026-09-22. Methods: targeted `find` (name patterns, pruned cache/dependency
trees), full symlink census of config trees + home depth-2, content search
(`rg -i 'multi-agent-orchestration|ai-agent-orchestration'`, max-filesize 2M) over curated
targets, git-repo census (depth 3), zsh history + Claude prompt history grep.
**No subagents were used for Phase 1** — all sweeps run by the main session (results were
compact enough; recorded per the methodology policy in audit/00).

Search concepts covered: multi-agent-orchestration, ai-agent-orchestration, MAO, SDD,
archfix, artifact-boundary, collision, orchestrat*, orchestrator, gsd, bmad, superpowers.
Generic terms (delegation, topology, primary agent, seat-by-seat, adaptive) were used only
inside MAO-specific trees (Phase 2), not as home-wide filters (noise).

## A. Evidence table (core objects)

| Path | Type | Active? | Git? | Symlink/target | Relation to canonical candidate | Evidence |
|---|---|---|---|---|---|---|
| `/home/isa/.local/share/ai-agent-orchestration/` | canonical candidate (container) | YES (consumed by 3 runtimes) | NO (.git absent) | — | IS the canonical candidate | 3 symlinks resolve here; managed blocks reference `multi-agent-orchestration` skill |
| `…/ai-agent-orchestration/README.md` (16,075 B, 2026-08-27 10:33) | canonical doc | yes (doc) | no | — | part of canonical | content read in Phase 2 |
| `…/multi-agent-orchestration/SKILL.md` (7,913 B, 08-27 16:22) | canonical source | YES (loaded by runtimes) | no | — | THE skill definition | hash chain vs evidence trees (Phase 2) |
| `…/references/delegation-contract.md` (2,606 B, 08-26 17:43) | canonical source | yes | no | — | original install-era file (mtime never changed since install) | metadata |
| `…/references/platform-adapters.md` (3,615 B, 08-27 16:22) | canonical source | yes | no | — | updated by archfix + artifact-boundary campaigns | hash chain (Phase 2) |
| `…/scripts/manage.sh` (14,945 B, 08-27 10:27) | canonical source (installer/manager) | yes | no | — | updated during archfix (before=14,810 B) | archfix before-after |
| `…/tests/scenarios.md` (4,183 B, 08-27 10:27) | canonical test spec | yes | no | — | updated during archfix (diff exists) | archfix before-after |
| `~/.claude/skills/multi-agent-orchestration` | live integration symlink | YES | — | `→ ../../.local/share/ai-agent-orchestration/multi-agent-orchestration` (resolves OK) | points to canonical | symlink census; created 2026-08-26 17:43 |
| `~/.zcode/skills/multi-agent-orchestration` | live integration symlink | YES | — | same relative target (resolves OK) | points to canonical | symlink census; created 2026-08-26 17:43 |
| `~/.agents/skills/multi-agent-orchestration` | live integration symlink | UNKNOWN consumer | — | same relative target (resolves OK) | points to canonical | created 2026-08-26 17:43; which runtime reads `~/.agents/` UNRESOLVED |
| `~/.claude/CLAUDE.md` | live integration (managed block) | YES | no | — | references canonical skill by name | managed markers `BEGIN/END managed: multi-agent-orchestration` |
| `~/.codex/AGENTS.md` | live integration (managed block) | YES | no | — | same block; Codex has NO skills symlink | content |
| `~/.zcode/AGENTS.md` | live integration (managed block) | YES | no | — | same block + skills symlink | content |
| `~/.config/ai-agent-orchestration/claude-depth.state` (15 B, 08-26 17:43) | runtime state file | yes | no | — | created by manage.sh; content `managed-absent` | direct read |
| `~/.claude/settings.json` (env `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1`) | possibly MAO-managed setting | YES (in effect) | no | — | attribution UNRESOLVED (state file says `managed-absent`) | diff vs MAO-era backup; Phase 2 resolves via manage.sh logic |
| `~/.claude/CLAUDE.md.multi-agent-orchestration-backup-*` ×3 | historical backup | no | no | — | pre-install snapshots by manage.sh | filenames/timestamps 08-26 17:39→08-27 10:27 |
| `~/.codex/AGENTS.md.multi-agent-orchestration-backup-*` ×3, `~/.zcode/AGENTS.md…` ×3 | historical backup | no | no | — | same | same |
| `~/.claude/settings.json.multi-agent-orchestration-backup-20260826T173941+0300` | historical backup | no | no | — | pre-install settings snapshot | diff in audit/00 |
| `/home/isa/mao-sdd-archfix-20260827/` | historical evidence tree (campaign 2) | no | NO (.git absent) | — | contains before/after + diffs of canonical files | tree map below |
| `/home/isa/mao-sdd-artifact-boundary-20260827/` | historical evidence tree (campaign 3) | no | NO | — | same + malicious-artifact fixture (`generated-PLAN.md`) | tree map below |
| `/home/isa/collision-smoke-test-evidence/` | historical evidence tree (campaign 1) — **not named in task brief, discovered** | no | repo/ has .git (local only, no remote) | — | SKILL.md policy iterations v0→v1 | tree map below |
| `/home/isa/collision-smoke-test-report.md` (16,080 B, 08-27 06:27) + `.zip` (906 KB) | historical report/archive | no | no | — | campaign-1 report | content |
| `~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md` | historical research (pre-install) | no | no | — | Codex MultiAgentV2 capability audit that informed MAO design | content (sanitized; audit time 2026-08-26, Codex 0.149.1) |
| `~/.claude/projects/-home-isa/7fed7c03-6f96-4544-a846-ea40a534092b.jsonl` (1.19 MB, 08-26→08-27 16:12) | session transcript — the install/fix-era session | no (historical) | no | — | primary provenance source for install + campaigns 1-2 | only -home-isa session in Aug 26–28 window |
| `~/.claude/projects/-tmp-multi-agent-orchestration-smoke-kHHQnF/` (08-26 17:45) | session metadata (smoke test 2 min after install) | no | no | — | install-time smoke test | dir listing |
| `~/.claude/projects/-tmp-mao-sdd-collision-*` ×5 | session metadata (campaign 1 + 4 post-fix attempts) | no | no | — | collision runs at /tmp (workdirs since wiped) | dir listings; /tmp dirs confirmed gone |
| `~/.claude/projects/-home-isa-mao-sdd-archfix-…-repos-test-{a1,a2,b,c}/` ×5 (+1 worktree dir) | session metadata (campaign 2 runs) | no | no | — | archfix test-run sessions | dir listings |
| `~/.claude/projects/-home-isa-mao-sdd-artifact-boundary-…-repos-{notectl-base,test-b,c,d}/` ×5 (+1 worktree) | session metadata (campaign 3 runs) | no | no | — | artifact-boundary test-run sessions | dir listings |
| `/home/isa/projects/llm_council_orchestrator/**` (git repo, remote `git@github.com:isakli05/llm_council_orchestrator.git`) + 14 `lco-reaudit-wt-*` worktrees | PRODUCTION USAGE evidence | active project | YES | — | documents MAO adaptive-mode topology in real audits (2026-09-06) | `audit-output/**/01-BASELINE-AND-MAO-TOPOLOGY.md`, `plans/2026-09-06-…md` |
| `~/docs/freelance-project-assessment/**` (2 files) | reference (session-rescue notes mentioning MAO) | no | no | — | mentions only | rg hits |
| `~/audits/aucdev-010-c2-*/**` (3 files) | reference (host-runtime manifests listing MAO presence) | no | no | — | mentions only (audit-council campaign inventories) | rg hits |
| `~/.claude/skills/audit-council*`, `~/audit-council-dev/`, `~/.local/share/audit-council/` | SEPARATE project (not MAO) | active | audit-council-dev has .git | — | unrelated multi-model system; coexistence-relevant only | content mentions MAO as host inventory item |

## B. Things checked and NOT found

- **No GSD / GSD Core / Open GSD / BMAD** anywhere (name + content search). Not installed.
- No MAO references in shell rc files (`~/.zshrc`, `.zshenv`, `.profile`, `.bashrc`).
- No `~/.claude/{commands,agents,hooks,rules}` directories exist at all.
- No MAO material in `~/.hermes` (content search, 2M cap).
- No MAO commands in `~/.zsh_history` (grep for mao/multi-agent/archfix → 0 hits) and
  0 hits in `~/.claude/history.jsonl` → all install/fix work happened inside agent sessions,
  not interactive shell.
- No `.git` in canonical tree or either task-named evidence tree.
- No other MAO copies: content search found no SKILL.md duplicates outside canonical +
  evidence-tree policy snapshots.
- No MAO references under `~/sites`.

## C. Broken / stale links found (MAO-adjacent)

- `~/.zcode/cli/plugins/cache/claude-plugins-official/superpowers/6.2.0/AGENTS.md →
  /tmp/zcode-plugin-src-l9PoZx/CLAUDE.md` — **BROKEN** (target wiped). ZCode keeps its own
  plugin cache with superpowers **6.2.0** vs Claude Code's **6.3.0** — version skew between
  runtimes of the same plugin (coexistence-relevant, Phase 4.5).
- All 3 MAO skill symlinks resolve correctly (verified).

## D. Coexisting orchestration-relevant systems (detail in audit/04)

- Superpowers plugin 6.3.0 (Claude Code, official marketplace) — includes
  subagent-driven-development; `.superpowers/sdd` artifacts exist in
  `~/projects/llm_council_orchestrator` and `~/projects/ninova_signage_teklif` (real usage).
- Superpowers 6.2.0 cached inside ZCode's own plugin engine (`~/.zcode/cli/plugins/…`).
- graphify skill — globally integrated into all three runtimes (same managed-block +
  backup pattern as MAO: `*.graphify-backup-20260826`).
- LLM Council Orchestrator (LCO) — user's own separate orchestration-adjacent project.
- audit-council — user's own multi-model audit system (skills + dev repo).
- Claude Agent Teams: not configured (no teams/ files found in ~/.claude).
- Codex native MultiAgentV2 — researched pre-MAO (diagnostics doc), no MAO coupling.

## E. Session-transcript provenance map

| Claude project dir (under `~/.claude/projects/`) | When | What it evidences |
|---|---|---|
| `-home-isa/7fed7c03-…` | 08-26 → 08-27 16:12 | install, collision smoke test, post-fix, archfix (campaigns 0–2) |
| `-tmp-multi-agent-orchestration-smoke-kHHQnF` | 08-26 17:45 | immediate post-install smoke test |
| `-tmp-mao-sdd-collision-20260827` | 08-27 01:59 | collision run 1 |
| `-tmp-mao-sdd-collision-postfix{,2,3,4}-*-repo` | 08-27 07:33–08:39 | post-fix attempts 1–4 |
| `-home-isa-mao-sdd-archfix-…-repos-test-{a1,a2,b,c}` | 08-27 10:31–11:50 | archfix validation runs |
| `-home-isa-mao-sdd-artifact-boundary-…-repos-*` | 08-27 16:35–21:11 | artifact-boundary validation runs |

The artifact-boundary *driving* session is not under `-home-isa` (its last transcript there
predates the campaign); its captured transcript lives inside the evidence tree itself
(`transcripts/session-a/`). Phase 2 reads both.

## F. Open questions carried to Phase 2

1. Exact hash lineage SKILL.md v0 (5,736 B) → v1 post-collision (7,326 B) → archfix-after
   (7,446 B?) → current (7,913 B) — verify.
2. Which copy of `manage.sh` wrote the managed blocks; confirm `claude-depth.state`
   semantics (`managed-absent`) vs the live `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1`.
3. What runtime consumes `~/.agents/skills/`.
4. Whether anything in either evidence tree never landed in canonical (gap analysis).
