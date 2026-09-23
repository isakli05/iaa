# 06 — Integrations: Claude Code, Codex, ZCode

All three integrations are identical in *meaning*, different only in *mechanism*. Installed
2026-08-26; verified live 2026-09-22.

| | Claude Code | Codex CLI | ZCode |
|---|---|---|---|
| Instruction surface | `~/.claude/CLAUDE.md` (managed block) | `~/.codex/AGENTS.md` (managed block) | `~/.zcode/AGENTS.md` (managed block) |
| Skill surface | `~/.claude/skills/…` symlink | `~/.agents/skills/…` symlink (official Codex user-skills dir) | `~/.zcode/skills/…` symlink (official Symlink import mode) |
| Invocation | description-matched + `/iaa` (plugin form: `/iaa:orchestrate` explicit entry, `iaa:iaa` skill) | implicit + `$iaa` | per-turn description injection (≤250 chars) + `$iaa` |
| Extra integration | spawn-depth=1 env key (managed) | none (pre-existing `[agents]` config + reviewer.toml untouched) | none |
| Adapter advice (PA) | Explore/Plan/general-purpose; pre-dispatch mode check; restate constraints to Explore/Plan | explorer/worker/default; fork_turns none preferred; steering; nesting policy-only | Explore (restate rules — no AGENTS.md injection) / general-purpose; nesting impossible |

## Facts verified against current official docs (2026-09-22)

- Codex user skills dir **is** `~/.agents/skills` (early docs said `~/.codex/skills`; that
  dir now holds only Codex-managed system skills) — İAA's symlink is correctly placed.
- ZCode: description hard limit 1024 chars, per-turn injection ~250 chars (İAA's
  description is 245–249 chars by design); subagents cannot spawn subagents (matches İAA's
  adapter); since ZCode 3.7.1 subagents inject AGENTS.md (except built-in Explore) — matches
  İAA's adapter text written at install time against 3.7.7.
- Claude Code: non-fork subagents inherit CLAUDE.md (the shim reaches workers); built-in
  Explore/Plan don't (hence the restate-constraints rule); default nesting depth is 3,
  locally capped to 1 by İAA's managed env key.

## Version context

Installed against: Claude 2.1.246, Codex 0.149.1, ZCode 3.7.7. Current at audit: Claude
2.1.274, Codex 0.155.1, ZCode 3.14.3. Integrations still valid per current docs; ZCode
local install is notably old. Codex/ZCode were not behaviorally re-tested after the
2026-08-27 campaigns (Claude-specific demonstrated risk; ZCode needs its desktop UI).
