# Installation and Integrations (current machine state)

Describes what is installed **on this machine today** (verified 2026-09-22). Public
installation/packaging design is separately in `docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md`.

## Layout

```
~/.local/share/iaa/          ← canonical source (runtime truth)
├── README.md
└── iaa/{SKILL.md, references/, scripts/, tests/}

~/.agents/skills/iaa  -> (relative) canonical   [Codex user skills]
~/.claude/skills/iaa  -> (relative) canonical   [Claude Code]
~/.zcode/skills/iaa   -> (relative) canonical   [ZCode]

~/.codex/AGENTS.md   ┐
~/.claude/CLAUDE.md  ├─ each carries ONE managed shim block (marker-delimited, idempotent)
~/.zcode/AGENTS.md   ┘
~/.config/iaa/claude-depth.state   ("managed-absent")
~/.claude/settings.json → env.CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH = "1"  (managed)
```

## Manage

```sh
~/.local/share/iaa/iaa/scripts/manage.sh verify
…/manage.sh install      # idempotent; backs up before any shim change
…/manage.sh uninstall    # removes only its own links/shims + managed depth value;
                         # preserves user-changed values, foreign symlinks, backups, source
```

Per-task opt-out: "Do not delegate or spawn subagents for this task."
Refresh after edits: Codex auto-detects (restart if stale); Claude `/reload-skills` or new
session; ZCode Settings→Skills→Refresh.

## Runtime notes

- **Claude Code** (`2.1.274`): spawn depth capped at 1 — child→grandchild spawning disabled
  by harness; primary→child unaffected. Raise per-session only for explicitly authorized
  bounded nesting, restore after.
- **Codex** (`0.154.0` per version.json): user skills via `~/.agents/skills`; pre-existing
  `[agents]` config (4 concurrent children; max_depth=1 kept as V1 fallback — MultiAgentV2
  ignores it, so Codex nesting is policy-guarded only) and `~/.codex/agents/reviewer.toml`
  (read-only independent reviewer, no-spawn) are NOT İAA's and were never modified by it.
- **ZCode** (`3.7.7` at install): desktop UI required for live checks; subagents cannot
  spawn subagents (platform); built-in Explore does not inherit AGENTS.md (adapter restates
  constraints in briefs).

## Coexistence with other installed systems

See `audit/04-coexisting-orchestrators.md` (local census) and
`docs/COMPATIBILITY-MATRIX.md`. Key neighbor: the Superpowers plugin (Claude) with its
SessionStart bootstrap hook — **6.4.1 installed since 2026-09-22** (was 6.3.0 at audit
time; the 6.4.1 boundary revalidation is `release-hardening/01-superpowers-6.4.1-upgrade-check.md`);
boundary rules in `docs/IAA-VS-SDD-BOUNDARY.md`.
