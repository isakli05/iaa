# Installation

İAA installs per runtime. Choose **one form per runtime** (plugin or
personal-skill); installing both creates a duplicate the doctor will flag.

## What you get

- one skill (`iaa`) — the delegation-decision policy (single behavioral core,
  byte-identical in every channel)
- an explicit entry point on Claude Code: `/iaa:orchestrate`
- an optional **integration step** (instruction-channel routing block +
  root-to-child spawn-depth cap on Claude) — explicit, reversible, backed up
- a read-only diagnostic: `iaa doctor`

## Claude Code — plugin form

```sh
claude plugin marketplace add isakli05/iaa     # or a local path to the repo
claude plugin install iaa@iaa
```

The plugin never modifies `~/.claude/CLAUDE.md`. For the tested instruction-
channel routing, run the explicit integration (from inside a session: `iaa
integrate --runtime claude --mode plugin`; it supports `--dry-run`):

```sh
sh "$HOME/.claude/plugins/cache/<marketplace>/iaa/<version>/bin/iaa" \
   integrate --runtime claude --mode plugin
```

What it writes: one marker-delimited block in `~/.claude/CLAUDE.md`
(backup first), and `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH="1"` in
`~/.claude/settings.json` **only if** you had no value there (a state file
records which). No skill links — the plugin provides the skill.

## Claude Code — personal-skill form (historically tested form)

```sh
git clone https://github.com/isakli05/iaa "$HOME/.local/share/iaa-src"
sh "$HOME/.local/share/iaa-src/iaa/scripts/manage.sh install
```

Creates (with backups before any change): `~/.claude/skills/iaa`,
`~/.agents/skills/iaa`, `~/.zcode/skills/iaa` symlinks; one managed block each
in `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.zcode/AGENTS.md`; the
spawn-depth value under the same ownership rule as above. Run from the repo it
links the three runtimes to that checkout's `iaa/` tree — prefer deploying to
`~/.local/share/iaa` first (`scripts/iaa deploy` from the repo) if you want the
runtime source decoupled from your checkout.

## Codex

The skills-dir form is primary and matches the behavioral evidence:

```sh
sh "$HOME/.local/share/iaa-src/iaa/scripts/manage.sh" install   # ~/.agents/skills/iaa + AGENTS.md block
```

Optional plugin form (local marketplace): see `packaging/codex/README.md`.
The plugin carries the skill only — the AGENTS.md routing block still comes
from the explicit script step.

## ZCode

Plugin form (GUI): add the marketplace (local path or repo), install `iaa`,
enable it, then Settings → Skills → Refresh. The optional AGENTS.md block:
`sh /path/to/iaa-repo/scripts/iaa integrate --runtime zcode --mode plugin`.
Personal-skill form: the same `manage.sh install` (creates
`~/.zcode/skills/iaa`).

## Verify

```sh
iaa doctor          # inside a session (plugin bin) or: sh <repo>/scripts/iaa doctor
```

Healthy = exit 0. LEGACY former-MAO state, duplicates, stale links, malformed
markers, and hash drift are all reported with exact fix commands
([LEGACY-MIGRATION.md](LEGACY-MIGRATION.md)).

## What İAA never does at install time

- never edits anything outside the marker-delimited blocks / its own links /
  the documented depth key
- never touches another plugin, framework, hook, or setting
- never runs background processes; there is no daemon
- never requires secrets, network, or an account
