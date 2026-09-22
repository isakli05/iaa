# Audit 06 — Post-Migration Validation (2026-09-22)

Migration performed: **in-place history capture** (live canonical untouched; byte-exact copy
into this repo — see audit/03 §Migration decision). Nothing was repointed, so this phase
proves the null-migration: every consumer still resolves to the one canonical source.

## Runtime integrations

| Consumer | Integration path | Resolves to | Exists | Points at authoritative source |
|---|---|---|---|---|
| Claude Code | `~/.claude/skills/multi-agent-orchestration` → `../../.local/share/ai-agent-orchestration/multi-agent-orchestration` | canonical dir | YES (`readlink -f`) | YES |
| ZCode | `~/.zcode/skills/multi-agent-orchestration` → same relative | canonical dir | YES | YES |
| Codex | `~/.agents/skills/multi-agent-orchestration` → same relative | canonical dir | YES | YES |
| Claude CLAUDE.md shim | managed block | 1 well-ordered marker pair | YES | text = manage.sh embedded shim |
| Codex AGENTS.md shim | managed block | 1 pair | YES | same |
| ZCode AGENTS.md shim | managed block | 1 pair | YES | same |
| Claude depth key | settings.json env | `1` with state `managed-absent` | YES | managed value intact |

## Checks run (all 2026-09-22, output captured in audit transcript)

- `manage.sh verify` → **7/7 ok, exit 0** (3 links, 3 shims, spawn depth, description
  length 249 ≤ 1024).
- `quick_validate.py` (Codex system validator) → "Skill is valid!".
- Live tree vs repo copy hash sweep → **byte-identical** (all 5 files; re-run after push).
- Evidence trees (`mao-sdd-archfix-20260827`, `mao-sdd-artifact-boundary-20260827`,
  `collision-smoke-test-evidence`) → zero files modified today (read-only treatment held).
- GitHub: `main` pushed non-force to fresh private repo; local `git status` clean.

## Not run, and why

- Behavioral runs (scenarios J/K, live-model smoke): out of scope for a freeze/migration
  audit — no runtime inputs changed; the last behavioral evidence (campaigns, production
  LCO) remains valid for the unchanged v3 source. Re-running belongs to the comparison
  phase.
- ZCode desktop live check: requires UI (no headless CLI; documented limitation).
- Codex live multi-agent exercise: not needed for null-migration; would only re-test
  unchanged behavior.
