# İAA — İştirak-i A‘mâl-i Ajanîye (Codex package)

Version: 0.1.0 · Namespace: `iaa`

A **delegation-decision policy** for agent CLIs, packaged for OpenAI Codex CLI.
Full documentation: the [İAA repository](https://github.com/isakli05/iaa).

## Primary install (skills-dir + script — the tested form)

The Codex form that matches İAA's behavioral evidence installs the skill into the
official user skills directory and the routing rule into `~/.codex/AGENTS.md`:

```sh
git clone https://github.com/isakli05/iaa "$HOME/.local/share/iaa-src"   # or your copy
sh "$HOME/.local/share/iaa-src/iaa/scripts/manage.sh install
```

This creates `~/.agents/skills/iaa` (symlink), one marker-delimited block in
`~/.codex/AGENTS.md` (backup first, reversible via `uninstall`), and touches
nothing else. Invoke with `$iaa` or implicitly; check state with `iaa doctor`.

## Optional: plugin form (local marketplace)

A Codex plugin (`plugin/` + a local marketplace catalog in `.agents/plugins/`) is
assembled for evaluation; it bundles the same byte-identical skill:

```sh
codex plugin marketplace add <path-to>/packaging/codex
codex plugin add iaa@iaa
codex plugin list          # verify
codex plugin remove iaa    # uninstall
```

Note: the plugin channel distributes the skill only. The AGENTS.md routing block
still requires the explicit `manage.sh install` step above (plugins do not own
your global AGENTS.md).

## Update / uninstall

```sh
sh "$HOME/.local/share/iaa-src/iaa/scripts/manage.sh verify     # check integrity
sh "$HOME/.local/share/iaa-src/iaa/scripts/manage.sh uninstall  # removes only İAA links/shims
```

See [docs/UPDATE.md](https://github.com/isakli05/iaa/blob/main/docs/UPDATE.md) and
[docs/UNINSTALL.md](https://github.com/isakli05/iaa/blob/main/docs/UNINSTALL.md).

## Duplicate rule

Use ONE form: either the skills-dir install or the plugin — not both.
`iaa doctor` flags duplicates.
