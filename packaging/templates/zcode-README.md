# İAA — İştirak-i A‘mâl-i Ajanîye (ZCode plugin)

Version: __VERSION__ · Plugin name: `iaa`

A **delegation-decision policy** for agent CLIs, packaged as a ZCode plugin
(`.zcode-plugin/plugin.json`). Full documentation: the
[İAA repository](https://github.com/isakli05/iaa).

Contents: exactly one Skill (`iaa` — the byte-identical behavioral core) and
one explicit Command (`/orchestrate`). No hooks, no MCP, no custom agents, no
daemon. Plugin-level documentation: `plugins/iaa/README.md` (+ `README_CN.md`).

## The two marketplace documents (do not confuse them)

- **`marketplace.json` — local/clone form.** The plugin entry's `source` is the
  relative `./plugins/iaa`. This resolves when this directory (or a clone of
  the repository) is added in ZCode as a local marketplace path, and it is the
  form required for an official `zai-org/zcode-plugins` contribution. It does
  **not** work as a standalone remote URL: a URL marketplace delivers only the
  JSON, and relative plugin sources cannot be resolved from it (the published
  0.1.0 stable-URL channel had exactly this limitation; fixed in 0.1.1 by the
  remote document below).
- **`marketplace.remote.json` — public remote form.** The single entry uses the
  official verified-archive source `{"source":"url","type":"zip","url":…,
  "sha256":…,"path":"iaa"}` pointing at the versioned, immutable
  `iaa-__VERSION__-plugin.zip` GitHub release asset. Its `sha256` is generated
  by the deterministic zip builder (`scripts/build-plugin-zip.py`) and enforced
  by `scripts/check-parity.sh`. This is the document to add in
  ZCode → Discover when installing remotely.

## Install (remote marketplace — GUI)

1. In ZCode: **Settings → Plugin management → Discover → +**.
2. Add the stable remote marketplace URL:
   `https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.remote.json`
3. Install **iaa** from that marketplace and enable it.

## Install (local testing — GUI)

Add this directory (`…/packaging/zcode`) as a **local path** marketplace in
**Discover → +**, then install **iaa** and enable it. (A clone of the
repository works the same way; a bare URL of `marketplace.json` does not — see
above.)

## New session

- `$iaa` — explicit skill invocation of the delegation policy.
- `/orchestrate` — the explicit Command entry point; ZCode resolves plugin
  commands to a flat `/name` (no plugin prefix), and it delegates to the same
  `iaa` skill — not a second implementation.
- After **Settings → Skills → Refresh**: exactly **one** İAA skill (`iaa`).
  `orchestrate` appears as a Command, not a Skill.

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

Disable/remove the plugin in **Settings → Plugin management** (disabling alone
already removes the skill and the command from discovery); run `unintegrate`
above if you integrated. Nothing else on your machine is modified.

## Duplicate rule

Use ONE form: either the plugin or the skills-dir install
(`~/.zcode/skills/iaa`) — not both. `iaa doctor` flags duplicates.

## Manual validation checklist (for maintainers)

- [ ] `marketplace.json` and `marketplace.remote.json` entries match the plugin
      manifest (name/version/description)
- [ ] `marketplace.remote.json` `sha256` == sha256 of the built/released
      `iaa-__VERSION__-plugin.zip` (enforced by `scripts/check-parity.sh`)
- [ ] Install via the remote marketplace (url/zip source) succeeds in the GUI
- [ ] Install via a local-path marketplace succeeds in the GUI
- [ ] New session: exactly one İAA skill; `/orchestrate` exposed as a Command
- [ ] `$iaa` triggers the skill; description injects ≤250 chars
- [ ] Plugin disable removes the skill and the command from discovery
