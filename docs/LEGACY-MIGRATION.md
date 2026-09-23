# Legacy Migration (former product names)

İAA was formerly named **MAO / Multi-Agent Orchestration** (technical ids
`multi-agent-orchestration`, `ai-agent-orchestration`). Public İAA never creates
those identifiers; they appear below and in detection code only as **LEGACY**
markers so old installations can be found, reported, and — only on explicit user
action — migrated. Historical evidence that mentions the old name is never
rewritten.

## What legacy state looks like

| LEGACY artifact | Location |
|---|---|
| Source tree | `~/.local/share/ai-agent-orchestration/` |
| State dir | `~/.config/ai-agent-orchestration/` |
| Skill links | `~/.claude/skills/multi-agent-orchestration`, `~/.agents/skills/multi-agent-orchestration`, `~/.zcode/skills/multi-agent-orchestration` |
| Managed shims | `<!-- BEGIN/END managed: multi-agent-orchestration -->` in `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.zcode/AGENTS.md` |
| Old backups | `*.multi-agent-orchestration-backup-*` files (kept forever; they are user history) |

## Required behavior (implemented)

1. **Detect.** `iaa doctor` reports every class above (exit 1, codes
   `legacy:*`), read-only.
2. **Report exactly.** Paths and marker status, nothing guessed.
3. **Explain.** This document; the doctor output names the migration command.
4. **No auto-delete.** Nothing is ever removed without the explicit command
   below; doctor itself never mutates anything.
5. **No silent duplicate.** A fresh İAA install will not activate beside a
   legacy install: the tested installer (`manage.sh install`) migrates the
   legacy state in the same transaction (strips the legacy shim with backup,
   relinks, adopts the state dir); the plugin package refuses to integrate in
   a way that would double-activate, and `iaa doctor` flags any residual
   duplicate/legacy combination.
6. **Preserve rollback.** Every mutation backs up first (`.iaa-backup-<stamp>`
   files); the pre-migration tree is kept.
7. **Migrate only on explicit action.** The command is:
   ```sh
   sh <repo-or-release>/iaa/scripts/manage.sh install
   ```
8. **Verify after migration.** `manage.sh verify` then `iaa doctor` — both must
   be clean (exactly one marker pair per file, links resolve, no legacy
   markers/links left).

## Migration semantics (what `manage.sh install` does to legacy state)

- `~/.config/ai-agent-orchestration/claude-depth.state` is **adopted** (moved
  into `~/.config/iaa/`) so uninstall-ownership semantics survive the rename;
  an existing current state file wins and the legacy dir is only removed if
  empty.
- LEGACY skill links are unlinked **only** when they resolve to (or literally
  target) the İAA source tree; unrelated symlinks are preserved verbatim.
- LEGACY managed blocks are stripped (after backup) and replaced by the current
  marker block in the same run — there is never a moment with two active
  routing blocks.
- The LEGACY source tree (`~/.local/share/ai-agent-orchestration/`) is **left
  in place** (immutable historical evidence; remove it manually if you want).

## Dry-run / read-only distinction

- `iaa doctor` — always read-only detection.
- `iaa integrate --mode plugin --dry-run` — prints planned shim changes.
- `manage.sh install` — the actual migration (explicit, backup-first).
  There is no automatic or scheduled migration path, by design.

## Historical evidence is never deleted

Old-named campaign trees (`~/mao-*`), backup files, transcripts, and repo
history are out of scope for migration and are retained per
`docs/HISTORICAL-EVIDENCE-DISPOSITION.md`. Migration touches only *active
installation state* listed in the table above.
