# Uninstall

Uninstall removes **only İAA-owned active state**. Everything else — your
prose in instruction files, other plugins, settings, history — is untouched.

## What İAA owns (complete list)

| Class | Artifacts |
|---|---|
| Plugin directories (plugin installs) | the runtime's plugin cache entry for `iaa` + its registration |
| Skill links (script installs) | `~/.claude/skills/iaa`, `~/.agents/skills/iaa`, `~/.zcode/skills/iaa` — only links resolving to the İAA source |
| Managed instruction blocks | the marker-delimited `<!-- BEGIN/END managed: iaa -->` block, nothing else in those files |
| Depth key (Claude) | `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` in `~/.claude/settings.json` — only when the state file says İAA managed it (`managed-absent`); user-set values are preserved |
| İAA state files | `~/.config/iaa/` (depth state, provenance) |
| İAA-created backups | `*.iaa-backup-*` files — kept by default (see below) |
| Deployed runtime source | `~/.local/share/iaa/` (only if you ask) |

## Procedure (plugin form)

```sh
iaa unintegrate --runtime claude --mode plugin    # removes the managed block + owned depth value (backups first)
claude plugin uninstall iaa
```

Codex plugin: `codex plugin remove iaa@<marketplace>`. ZCode: remove the
plugin in Settings.

## Procedure (script form)

```sh
sh <repo>/iaa/scripts/manage.sh uninstall
```

Removes the three links (only those resolving to the İAA source), the managed
blocks (marker-validated before mutation; **aborts rather than guesses** if a
marker pair is malformed or duplicated), restores the depth key per its state
file, and strips any LEGACY pre-rename markers it owns. The source tree is
retained (printed). Remove `~/.local/share/iaa` and `~/.config/iaa` manually
if you want them gone; they are inert without the links.

## Backups

İAA-created backups (`*.iaa-backup-*`) are **kept** on uninstall by default —
they are your rollback history. To remove them explicitly:

```sh
rm -f "$HOME/.claude/CLAUDE.md".iaa-backup-* "$HOME/.codex/AGENTS.md".iaa-backup-* \
      "$HOME/.zcode/AGENTS.md".iaa-backup-* "$HOME/.claude/settings.json".iaa-backup-*
```

LEGACY historical `*.multi-agent-orchestration-backup-*` files predate İAA's current
identity; remove them only if you no longer want the history.

## Safety invariants (enforced by the tools)

- Marker-pair integrity is validated before any mutation; a malformed pair
  aborts the operation (unit-tested).
- Foreign symlinks, other plugins, hooks, MCP servers, and unrelated settings
  are never touched (P7 non-invasiveness).
- No uninstall path deletes historical evidence, transcripts, or old backups
  automatically.
