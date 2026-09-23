# İAA — İştirak-i A‘mâl-i Ajanîye (ZCode plugin)

Version: 0.1.0 · Namespace: `iaa`

A **delegation-decision policy** for agent CLIs, packaged as a ZCode plugin
(`.zcode-plugin/plugin.json`). Full documentation: the
[İAA repository](https://github.com/isakli05/iaa).

Contents: the `iaa` skill (byte-identical behavioral core) and the thin explicit
`orchestrate` entry skill. No hooks, no MCP, no custom agents.

## Install (personal marketplace — GUI)

1. Keep this package's `marketplace/` directory somewhere local (or publish the
   repository and use its URL).
2. In ZCode: **Settings → Plugin management → Discover → +** → add the local
   marketplace path (`…/packaging/zcode/marketplace`).
3. Install **iaa** from that marketplace and enable it.
4. New session → `$iaa` invokes the skill; confirm it appears under
   Settings → Skills after **Settings → Skills → Refresh**.

## The integration step (AGENTS.md)

The plugin does not touch `~/.zcode/AGENTS.md`. For the tested routing
configuration, run the explicit, reversible integration from a checkout of the
repository:

```sh
sh /path/to/iaa-repo/scripts/iaa integrate --runtime zcode --mode plugin   # --dry-run supported
sh /path/to/iaa-repo/scripts/iaa unintegrate --runtime zcode --mode plugin # reverse
```

It writes one marker-delimited block (backup first). No skill links are created —
the plugin provides the skill.

## Uninstall

Disable/remove the plugin in **Settings → Plugin management**; run `unintegrate`
above if you integrated. Nothing else on your machine is modified.

## Duplicate rule

Use ONE form: either the plugin or the skills-dir install
(`~/.zcode/skills/iaa`) — not both. `iaa doctor` flags duplicates.

## Manual validation checklist (for maintainers)

- [ ] `marketplace/marketplace.json` entry name/version == plugin manifest
- [ ] Install via local marketplace succeeds in the GUI
- [ ] New session: skill listed after Settings → Skills → Refresh
- [ ] `$iaa` triggers the skill; description injects ≤250 chars
- [ ] Plugin disable removes the skill from discovery
