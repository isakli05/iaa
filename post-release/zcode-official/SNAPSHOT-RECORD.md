# ZCode Official Validation — Transactional Rollback Snapshot Record

Date: 2026-09-23. This file records the rollback snapshot taken BEFORE any
live ZCode state was modified (task §5). Raw runtime state is intentionally
NOT committed to the repository; it lives outside the repo at the path below.

## Snapshot location (outside the repo, private)

`/home/isa/.local/state/iaa/rollback-zcode-20260923T195347+0300/`

Contents (SHA256 in that directory's `SHA256SUMS`):

| Preserved item | Form | SHA256 (prefix) |
|---|---|---|
| `~/.zcode/cli/plugins/installed_plugins.json` | copy | `6e94e8ca…` |
| `~/.zcode/cli/plugins/known_marketplaces.json` | copy | `3a0fbc01…` |
| `~/.zcode/AGENTS.md` (pre-change, incl. İAA managed block) | copy | `46da57ab…` |
| `~/.zcode/skills/iaa` symlink object | tar + preserved symlink (`skills-iaa-symlink-preserved`) | tar `1032a1d6…` |
| doctor before (text + JSON, exit 0, 0 actionable) | output files | — |

Symlink target recorded: `~/.zcode/skills/iaa -> ../../.local/share/iaa/iaa`
(i.e. `/home/isa/.local/share/iaa/iaa`).

## Baseline live state (before this task's changes)

- ZCode **3.11.2** (AppImage `X-AppImage-Version=3.11.2.6792`;
  `/home/isa/.local/state/zcode/version` = `3.11.2`) — unchanged from Gate 3.
- İAA ZCode integration: **skills-dir form** active
  (`skill:zcode` OK + `shim:zcode` OK in doctor).
- Plugin registrations: 7 plugins, all from `claude-plugins-official`; **no
  `iaa` plugin**.
- Known marketplaces: `zcode-plugins-official` (CDN url) +
  `claude-plugins-official` (github); **no İAA marketplace**.
- `iaa doctor`: exit 0, 0 actionable problems (14 findings, all OK/INFO).

## Changes made for the plugin-form test window (all reversible)

1. `sh scripts/iaa unintegrate --mode=plugin --runtime=zcode`
   → removed the İAA managed block from `~/.zcode/AGENTS.md`
   (tool backup: `~/.zcode/AGENTS.md.iaa-backup-20260923T195421+0300`).
2. Moved the `~/.zcode/skills/iaa` symlink (object itself, target intact) to
   the snapshot directory as `skills-iaa-symlink-preserved`.
   Rationale: `manage.sh uninstall` is all-runtimes (would touch Claude/Codex —
   forbidden by task §6) and no supported runtime-scoped command removes a
   single runtime's skill link; a one-symlink move is the minimal reversible
   action, preserving rather than deleting state.

Claude and Codex integrations were NOT touched (verified post-change:
`skill:claude`/`skill:codex`/`shim:claude`/`shim:codex` all OK).

## Rollback commands (restore original live state)

```sh
rb=/home/isa/.local/state/iaa/rollback-zcode-20260923T195347+0300
mv "$rb/skills-iaa-symlink-preserved" "$HOME/.zcode/skills/iaa"
sh /home/isa/projects/iaa/scripts/iaa integrate --mode=plugin --runtime=zcode
# (recreates the managed AGENTS.md block; the tool's own backup above is a
#  second restoration path: cp the backup over ~/.zcode/AGENTS.md)
sh /home/isa/projects/iaa/scripts/iaa doctor   # expect exit 0
```

If the GUI test added plugin/marketplace state that must be reverted, restore:

```sh
cp "$rb/installed_plugins.json" "$HOME/.zcode/cli/plugins/installed_plugins.json"
cp "$rb/known_marketplaces.json" "$HOME/.zcode/cli/plugins/known_marketplaces.json"
```

(after removing any test-installed plugin cache dirs under
`~/.zcode/cli/plugins/cache/` and `~/.zcode/cli/plugins/marketplaces/` if present).
