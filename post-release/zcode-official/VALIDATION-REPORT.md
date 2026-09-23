# ZCode Official Validation — VALIDATION REPORT (corrected)

Date: 2026-09-23. Controller: the main Claude Code / GLM-5.3 session (sole
controller per the task brief). GUI leg executed by the owner in ZCode
Desktop; all filesystem/log inspection, restoration, and analysis by the
main session. Nothing here is claimed without recorded evidence.

---

## VERDICT (per owner instruction — validation did NOT pass)

```
ZCODE PLUGIN-FORM BEHAVIORAL VALIDATION:
  NOT COMPLETED / FAILED CONTRACT CHECK
```

- NOT upgraded to TESTED. Not PARTIALLY TESTED either: the intended
  validation condition "exactly one `iaa` skill; `orchestrate` not a second
  auto-triggerable skill" is **UI-visibly false** at the tested version, and
  the `$iaa` model-call leg could not run (ZCode provider connection failure,
  diagnosed below — unrelated to İAA).
- What DID succeed: GUI marketplace add (local path), plugin install +
  enable, component list load — with byte-verified 0.1.0 content.

## Tested runtime version

**ZCode Desktop 3.14.3** (AppImage `X-AppImage-Version=3.14.3.7762`,
`~/.local/state/zcode/version` = `3.14.3`, GUI About = "ZCode Desktop App
3.14.3" — owner-observed).

### Version-contradiction investigation (finding F1)

- Pre-flight (19:52–19:53 local): on-disk AppImage embedded
  `3.11.2.6792`; state file `3.11.2`; Gate-3's 3.11.2 observation thereby
  reproduced — the detector was **correct for the on-disk bytes at that
  moment**, not stale metadata.
- During the test window the AppImage was **replaced on disk**
  (`199,434,223` → `204,042,042` bytes, mtime 20:23 local; embedded version
  now `3.14.3.7762`; state file `3.14.3`). Whether the app self-updated or
  the update launcher (`~/.local/bin/zcode-update`) ran is not determinable
  from available logs; no updater event appears in the app log.
- Consequence: the pre-flight pin (3.11.2) was invalidated by the in-window
  update. **All GUI observations below are 3.14.3 behavior.** Upstream line
  was already 3.14.3 (gate-3/07), so this is the current release.
- Lesson recorded: pin by verifying the version **inside the GUI session
  window**, not only pre-flight, when the runtime has an updater.

## Steps performed

1. §1–2 Evidence/base-state recorded; upstream `zai-org/zcode-plugins`
   cloned fresh (last push 2026-09-17); no `iaa` collision in marketplace
   (26 plugins), open PRs (19), or issues.
2. §3 Version-immutability gate: **FAILED for a 0.1.0 official submission**
   (see FINAL-ZCODE-OFFICIAL-REPORT.md §"version gate").
3. §4–6 Baseline doctor (exit 0); rollback snapshot; ZCode skills-dir
   integration temporarily disabled (zcode-scoped shim removal via
   `iaa unintegrate --mode=plugin --runtime=zcode` + one preserved-symlink
   move — `manage.sh uninstall` is all-runtimes and was not usable).
4. §7 GUI leg (owner): raw-URL marketplace add → FAILED; local-path add →
   SUCCEEDED; install + enable → SUCCEEDED; Skills panel → TWO skills
   exposed; `$iaa` model call → blocked by ZCode provider connection
   failure; plugin disabled/uninstalled + marketplace removed by owner.
5. §8 Post-GUI inspection: residual state captured, hashed, archived, cleaned.
6. §9 Original live state restored and proven restored (below).

## Findings

### F2 — Raw-URL marketplace source is UNSUPPORTED for relative plugin sources

- Adding `https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.json`
  in Discover → **"Unsupported or missing plugin source: ./plugins/iaa"** +
  "Couldn't load the component list. Showing available info only."
- Cause (documented + observed): a URL marketplace delivers only the JSON;
  the relative `./plugins/iaa` source form resolves only when the
  marketplace is a **cloned repo or a local directory** (the machine's
  working `claude-plugins-official` marketplace is a full clone under
  `~/.zcode/cli/plugins/marketplaces/`; the local İAA path resolved the
  same way). Remote marketplaces must use self-contained plugin sources —
  the official CDN uses `{"source":"url","type":"zip","url":…,"sha256":…,
  "path":…}` for **all 26** entries; `docs/distribution.md`: "`sha256` is
  mandatory… `path` identifies the plugin directory inside the archive."
- **The published stable-URL ZCode marketplace channel (0.1.0) is therefore
  defective for its intended remote use** — it installs only via local-path
  or cloned-repo consumption. Public-facing docs must be corrected in 0.1.1
  regardless of the packaging fix.

### F3 — Local-path install SUCCEEDED with byte-exact 0.1.0 content

- Local marketplace `/home/isa/projects/iaa/packaging/zcode` added; `iaa`
  0.1.0 installed and enabled; component list loaded.
- Byte-parity proof: ZCode's own copy
  (`~/.zcode/cli/plugins/marketplaces/iaa/…`, captured before cleanup;
  manifest `evidence/gui-installed-marketplace-copy.SHA256`) — all plugin
  files identical to the repo authoritative tree, incl. the five core-file
  hashes (`73f7b887…`, `23184f0d…`, `849b769c…`, `21964702…`, `5fa9617e…`)
  and `marketplace.json` JSON-identical (whitespace-only difference).

### F4 — CRITICAL: TWO skills exposed (intended contract NOT met)

- Settings → Skills showed **both `iaa` and `orchestrate`** as enabled
  components. The intended condition ("exactly one `iaa` entry;
  `orchestrate` does NOT appear as a second auto-triggerable skill") is
  UI-visibly false at 3.14.3.
- Root cause (documented): `zai-org/zcode-plugins` `docs/PLUGIN_DEVELOPMENT.md`
  — **§2.4 Skill frontmatter documents ONLY `name` + `description`**;
  **§2.3 Command frontmatter is where `disable-model-invocation` is
  documented** ("Prevent automatic invocation when supported"). İAA's
  `skills/orchestrate/SKILL.md` carries `disable-model-invocation: true`
  (verified present in the GUI-installed copy) — a field outside ZCode's
  documented skill contract, and ZCode exposes the skill regardless.
- Adapter correction (evidence-backed, for 0.1.1 — NOT implemented):
  ZCode package becomes **one discoverable Skill** (`skills/iaa/`) **plus
  one explicit Command** (`commands/orchestrate.md`, §2.3 frontmatter;
  manifest gains `"commands": "commands"`), removing
  `skills/orchestrate/SKILL.md` from the ZCode package only. The Claude
  package keeps its own form (Claude's skill contract does document the
  field; its plugin passed `claude plugin validate --strict` + live testing
  in Gate 2). The authoritative core (`iaa/SKILL.md`) is untouched.

### F5 — `$iaa` behavioral leg NOT COMPLETED (ZCode provider connection failure)

- ZCode could not reach its model backend during the window
  ("Reconnecting"; Z.ai login failed; manual API key also failed).
- Independent diagnosis (H) — summarized here, full detail in
  FINAL-ZCODE-OFFICIAL-REPORT.md: both auth modes fail at the TRANSPORT
  layer against `https://api.z.ai/api/anthropic` (74 timeouts in the log;
  `builtin:zai-coding-plan` 40×, `zai-api` 34×; `errorPhase: connect`;
  signing handshake `errorKind: handshake-network`), while the same
  endpoint answers **HTTP 200 in ~1 s over IPv4 from this machine**. The
  machine has **no global IPv6 address and no IPv6 default route**, yet DNS
  returns AAAA — the app's Electron/Node connection stack attempts IPv6
  without effective IPv4 fallback and times out (curl survives via
  Happy-Eyeballs). **Attribution: local broken-IPv6 environment × ZCode
  3.14.3 connection behavior. NOT İAA** (no network involvement; plugin
  lifecycle itself was clean). No public issue tracker exists to match
  (`zai-org/ZCode` has issues disabled; feedback is in-app); the symptom
  class is publicly reported for ZCode ≥3.1.4.
- Owner-side remediation candidates (NOT executed, owner decision):
  IPv4 preference via `/etc/gai.conf` (`precedence ::ffff:0:0/96`),
  disabling IPv6 system-wide, or a `NODE_OPTIONS`/launcher workaround.

## Original-state restoration (proof)

| Item | Before task | After restoration | Evidence |
|---|---|---|---|
| `~/.zcode/skills/iaa` | symlink → `../../.local/share/iaa/iaa` | same symlink object restored (same relative target) | `readlink` output identical |
| `~/.zcode/AGENTS.md` | sha `46da57ab…` | **byte-identical** to snapshot copy | `cmp` clean |
| `installed_plugins.json` | 7 plugins, no `iaa` | 7 plugins, no `iaa` | post-GUI capture (snapshot dir) |
| `known_marketplaces.json` | 2 marketplaces, no İAA | 2 marketplaces, no İAA | post-GUI capture |
| Plugin/marketplace residues | none | none (stale `marketplaces/iaa` + `cache/iaa` removed after archiving) | archived tar in snapshot dir |
| `iaa doctor` | exit 0, 0 actionable | **exit 0, 0 actionable — output identical to baseline** | `doctor-after.json` (9 OK / 5 INFO) |

No duplicate activation exists in the final state (no `iaa` plugin
registered anywhere; single skills-dir form restored).

**Environmental note (not caused by İAA, not rolled back):** during the
owner-driven GUI window the app updated itself and three unrelated plugins
(superpowers 6.2.0→6.4.1, chrome-devtools-mcp 1.7.0→1.9.0,
security-guidance 2.0.6→2.0.8). Rolling these back would itself be a
mutation; recorded as observed app behavior.

Two tool-made backup files remain from the disable/restore cycle
(`~/.zcode/AGENTS.md.iaa-backup-20260923T195421+0300`, `…T205716+0300`) —
consistent with the backup-first lifecycle design; left in place.

## Evidence index (publication-safe)

- `SNAPSHOT-RECORD.md` — rollback snapshot record (paths, hashes, commands)
- `evidence/gui-installed-marketplace-copy.SHA256` — 13-file manifest of
  ZCode's copy of the installed 0.1.0 marketplace/plugin content
- Out-of-repo (private): `~/.local/state/iaa/rollback-zcode-20260923T195347+0300/`
  — raw JSONs, AGENTS.md copy, symlink, doctor before/after,
  `gui-marketplace-iaa-copy.tar`, SHA256SUMS
- Upstream citations: `zai-org/zcode-plugins` @ 2026-09-17 clone —
  AGENTS.md (Versioning Contract), CONTRIBUTING.md (plugin contract),
  scripts/validate.py:167-174 (source must be `./plugins/<name>`),
  scripts/build_dist.py (verbatim zip packaging),
  docs/PLUGIN_DEVELOPMENT.md §2.3/§2.4, docs/distribution.md (zip+sha256
  remote form, immutability)
