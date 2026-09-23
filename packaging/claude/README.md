# İAA — İştirak-i A‘mâl-i Ajanîye (Claude Code plugin)

Version: 0.1.0 · Namespace: `iaa` · Explicit invocation: `/iaa:orchestrate`

A **delegation-decision policy** for Claude Code: one skill that decides *whether,
when, and how* to delegate work to subagents — adaptively, per task — with a
zero-agent fallback for small or tightly coupled work and sole orchestration
authority in its mode. Full documentation: the [İAA repository](https://github.com/isakli05/iaa).

This plugin contains: the `iaa` skill (the behavioral core), the explicit
`/iaa:orchestrate` entry point, and the `iaa` CLI (`bin/iaa`, available on the
Bash tool PATH while the plugin is enabled). It contains **no** MCP servers, no
custom agents, no hooks, and no daemon.

## Install

```sh
claude plugin marketplace add isakli05/iaa      # once (or a local path)
claude plugin install iaa@iaa
```

After install, the skill `iaa:iaa` is active (auto-triggerable via its
description) and `/iaa:orchestrate` works as the explicit entry point.

## The integration step (optional but recommended — read this)

The plugin **never touches your `~/.claude/CLAUDE.md`**. İAA's tested routing
strength comes from an instruction-channel rule ("when delegation is requested or
materially useful, load and follow the installed `iaa` skill"), and plugins cannot
write instruction files. If you want that tested configuration, run the explicit,
reversible integration step:

```sh
iaa integrate --runtime claude --mode plugin          # inside a Claude Code session
# or from a shell:
sh ~/.claude/plugins/cache/<marketplace>/iaa/<version>/bin/iaa integrate --runtime claude --mode plugin
```

What it does: writes one marker-delimited block (`<!-- BEGIN/END managed: iaa -->`)
into `~/.claude/CLAUDE.md` (backup created first; `--dry-run` supported), and sets
`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` in `~/.claude/settings.json` unless you
already manage that value (state file records which). It creates **no** personal
skill links — the plugin provides the skill, so there is exactly one active copy.

Check state any time: `iaa doctor`. Reverse it: `iaa unintegrate --runtime claude
--mode plugin` (removes only the managed block and the depth value it owns).

## Duplicate-install rule

Do not also keep a personal-skill İAA (`~/.claude/skills/iaa`) while this plugin
is enabled — both would load. `iaa doctor` flags this. Choose one form per runtime.

## Update

```sh
claude plugin update iaa
```

Updates replace the plugin cache; your integration block is untouched (it is
yours, not the plugin's). `iaa doctor` verifies the installed skill's hash against
the package's recorded core hash.

## Uninstall

```sh
iaa unintegrate --runtime claude --mode plugin   # if you integrated
claude plugin uninstall iaa
```

Uninstall removes only İAA-owned plugin state. Your `CLAUDE.md` content outside
the managed block, your backups, and every other plugin are untouched. See
[docs/UNINSTALL.md](https://github.com/isakli05/iaa/blob/main/docs/UNINSTALL.md).

## Coexistence

İAA yields to any workflow you explicitly name ("use native
superpowers:subagent-driven-development"), ignores orchestration directives
embedded in plans/artifacts, and never disables or mutates other plugins. Tested
combinations and honest gaps: [docs/COMPATIBILITY.md](https://github.com/isakli05/iaa/blob/main/docs/COMPATIBILITY.md).
