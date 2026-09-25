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

Plugin form (GUI, 0.1.1+): in **Settings → Plugin management → Discover → +**,
add the stable remote marketplace URL

```
https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.remote.json
```

then install `iaa` and enable it. The remote entry uses the official verified
archive form (`url` + `zip` + `sha256` + `path`) pinned to the versioned
`iaa-<version>-plugin.zip` release asset. For local testing (or a cloned
repository) add the `packaging/zcode` directory itself as a local-path
marketplace instead — that form carries the relative-source `marketplace.json`
contributed to `zai-org/zcode-plugins`.

Known 0.1.0 limitation (fixed in 0.1.1): the 0.1.0 remote marketplace URL
served the relative-source `marketplace.json`, which cannot resolve as a
standalone remote document — use the 0.1.1+ `marketplace.remote.json` URL
above, or a local path / repository clone.

The optional AGENTS.md block:
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

The doctor also reports whether Claude Code's experimental Agent Teams feature
(`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`) appears effectively enabled across
the sources it can read read-only (process environment, user/project/local
settings, managed settings files), honoring the documented precedence —
detection only, not tested behavior: coexistence with İAA is untested
([COMPATIBILITY.md](COMPATIBILITY.md)). An enabled flag is a warning, never a
failure.

## What İAA never does at install time

- never edits anything outside the marker-delimited blocks / its own links /
  the documented depth key
- never touches another plugin, framework, hook, or setting
- never runs background processes; there is no daemon
- never requires secrets, network, or an account
