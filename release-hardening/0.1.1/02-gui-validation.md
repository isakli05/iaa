# İAA 0.1.1 — GUI Acceptance Validation Record (ZCode plugin form)

Date: 2026-09-23 (evening window). ZCode Desktop **3.14.3** (AppImage
`3.14.3.7762` — same 204 042 042-byte file, mtime 20:23, previously
fingerprinted; state file `3.14.3`; embedded Node **24.14.0**). GUI leg
executed by the **owner** (the designated evidence channel for this gate);
filesystem/log inspection, byte verification, restoration, and analysis by the
main session. Candidate under test: branch
`release/0.1.1-zcode-packaging` @ `1ff1f7d`,
`iaa-0.1.1-plugin.zip` sha256
`621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`.

## Remote-source contract test setup (§6)

- The **exact candidate plugin.zip bytes** were served from a temporary local
  HTTP server (`python3 -m http.server`, bound `127.0.0.1:8397`, directory
  `/tmp/iaa-011-remote-test`, outside the repo).
- The TEST marketplace was generated from the production
  `packaging/zcode/marketplace.remote.json` with **only** `source.url`
  changed to `http://127.0.0.1:8397/iaa-0.1.1-plugin.zip`; identical
  `sha256`, `path: "iaa"`, plugin metadata, and version (0.1.1). Plain http
  to 127.0.0.0/8 is an explicit client allowance in the ZCode installer
  (`Qun` URL validator), so this exercised the genuine remote-archive path.
- The marketplace itself was added as a local path (already-proven channel);
  the object under test was the remote `url + zip + sha256 + path` plugin
  source resolution.
- The production document's GitHub-release URL did not and could not exist
  during this test (no tag was created); it is **not** claimed tested. The
  later release task must smoke-test the final URL (checklist in
  `03-release-material.md`).

## Owner-reported GUI results (all PASS)

| # | Criterion (task §11) | Result |
|---|---|---|
| A | Remote marketplace (url/zip/sha256/path) resolves; no "Unsupported or missing plugin source" | **PASS** — test marketplace loaded; `iaa` 0.1.1 listed |
| B | Install `iaa` 0.1.1 | **PASS** — installed + enabled |
| C | Component inventory: 1 Skill / 1 Command / 0 Agents / 0 Hooks / 0 MCP | **PASS** — exactly that |
| D | Skills panel shows exactly one `iaa` skill; `orchestrate` NOT a second skill | **PASS** |
| E | Explicit orchestrate entry discoverable as a **Command** | **PASS** — `/orchestrate` |
| F | `$iaa what is 2 + 2?` → İAA policy resolves, direct answer, zero delegated agents | **PASS** |
| G | `/orchestrate what is 2 + 2?` → same policy, trivial task stays zero-agent, no duplicate skill activation | **PASS** |
| H | Disable removes plugin-provided skill + command from discovery | **PASS** |
| I | Uninstall clean; test marketplace removed | **PASS** (owner uninstalled + removed marketplace in-GUI) |

## Filesystem corroboration (captured before cleanup)

- ZCode's own downloaded copy survived at
  `~/.zcode/cli/plugins/marketplaces/iaa/iaa-0.1.1-plugin.zip`:
  sha256 **== the pinned value** (`621bdd1f…`, `evidence/gui-downloaded-zip.SHA256`)
  — the remote download path fetched our exact candidate bytes and passed the
  client's mandatory sha256 gate.
- ZCode's copy of the test marketplace JSON was identical to the served one
  (`jq -S` diff clean; `evidence/gui-downloaded-test-marketplace.json`).
- Registries after the owner's uninstall: 7 plugins (no `iaa`), 2 marketplaces
  (no test entry). Residue (empty `cache/iaa` tree + the marketplace copy
  above) was archived-listed to the rollback dir and removed.
- App main log (`~/.zcode/v2/logs/2026-09-23.log`): **zero**
  `model.request.failed` / `model.network.failed` / `handshake_failed`
  entries all day (contrast: 74 during the pre-workaround 0.1.0 window);
  clean app quit at 23:08. The log carries no model-request telemetry itself,
  so behavioral outcomes rest on the owner-executed acceptance above.

## Test-window environment (§8–§9, all restored — see below)

- ZCode skills-dir İAA integration temporarily disabled for the window
  (snapshot + one-symlink move + `unintegrate --mode=plugin --runtime=zcode`);
  Claude and Codex untouched throughout.
- Temporary network workaround (unrelated ZCode 3.14.x provider issue,
  zai-org/feedback#699): fresh A-record resolution (`8.217.100.151`,
  `8.217.233.95` — both TLS-verified, CN `*.z.ai`, hostname verification on),
  `/etc/hosts` backed up (`/etc/hosts.iaa-011-backup-20260923T222507+0300`,
  pre-change hash `44a76ff1…`), one entry `8.217.100.151 api.z.ai` added,
  `resolvectl flush-caches` run, effective lookup verified (single IPv4,
  synthetic/hosts source).
- **Embedded-runtime proof before opening ZCode** (ZCode's own Node 24.14.0,
  default flags only — no `--no-network-family-autoselection`, no
  dns-result-order override): `fetch("https://api.z.ai/api/anthropic")` →
  **HTTP 200 ×3** (1 319–2 806 ms). The identical test was ETIMEDOUT ×3
  before the override (post-release/zcode-official/NETWORK-DIAGNOSTIC.md).

## Restoration (§14, proven)

| Item | Before task | After restoration | Proof |
|---|---|---|---|
| `~/.zcode/skills/iaa` | symlink → `../../.local/share/iaa/iaa` | same object restored | `readlink` identical |
| `~/.zcode/AGENTS.md` | sha `46da57ab…` | **byte-identical** to snapshot | `cmp` clean |
| Plugin/marketplace registries | 7 plugins / 2 marketplaces, no İAA | same | post-capture listing |
| Plugin residues | none | none (archived then removed) | rollback-dir listing |
| `/etc/hosts` | no `api.z.ai` entry (hash `44a76ff1…`) | restored from backup; 0 `api.z.ai` entries; caches flushed; real DNS back (both A records, CNAME resolution) | `grep` + `getent` + HTTP 200 via normal DNS |
| Test server / test dir | — | stopped (`127.0.0.1:8397` down), `/tmp/iaa-011-remote-test` removed | task stop + `rm` |
| `iaa doctor` | exit 0, 0 actionable | **exit 0, 0 actionable, output identical to baseline**; `--json`: 14 findings, 0 problems, version 0.1.1 | doctor-before/after diff clean |
| Claude / Codex | integrated + healthy | unchanged (all doctor checks OK throughout) | doctor output |

Rollback snapshot (private, outside the repo):
`/home/isa/.local/state/iaa/rollback-zcode-011-20260923T222432+0300/`
(registries, AGENTS.md, preserved symlink + tar, doctor outputs, residue
listing, SHA256SUMS).

## Verdict

All §11 acceptance criteria passed; one-skill contract met; remote marketplace
distribution path proven with byte-exact download verification; environment
functionally equivalent to the initial state.
