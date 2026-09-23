# Gate 3 — 05: ZCode Final Validation

Date: 2026-09-23. The Gate-2 residual (gate-2/07 §6, matrix m6): the GUI
plugin-install leg in the ZCode desktop app, documented as a manual
checklist and explicitly not claimed executed. This Gate mapped the
CURRENT available validation surface and executed every safely
automatable step.

Environment on this machine: ZCode desktop 3.11.2 (AppImage,
`~/.local/bin/zcode` wrapper). Upstream product line is now 3.14.3
(2026-09-22 release; see 07-version-recheck.md) — claims stay pinned to
the installed/tested versions.

## 1. Validation surface found (2026-09-23)

- **No headless plugin-install CLI exists**: the `zcode` launcher execs the
  Electron desktop AppImage; `--help`/subcommand probes launch the GUI
  (deep-link registration logs), and the official docs put marketplace
  discovery + install in Settings → Plugin management (GUI).
- **Plugin state is file-based** under `~/.zcode/cli/plugins/`
  (`installed_plugins.json`, `known_marketplaces.json`,
  `marketplaces/<id>/`, per-plugin `cache/`), which gives strong STATIC
  verifiability of what a GUI install would produce.
- **Machine-context finding (new datum)**: this machine's ZCode has BOTH
  the official ZCode marketplace and `claude-plugins-official` registered,
  with seven plugins installed from the latter — i.e. ZCode's plugin
  system demonstrably consumes Claude-marketplace-shaped entries and
  url/git sources in production use. It also carries the skills-dir
  `iaa` install (`~/.zcode/skills/iaa`) — İAA's historically used ZCode
  integration.

## 2. Why the GUI leg was not executed in this session (deliberate, not skipped silently)

Performing the real GUI install here would mutate the owner's live ZCode
state AND — because the skills-dir `iaa` form is active in `~/.zcode/skills`
— it would deliberately create the exact duplicate-activation condition
İAA's own doctor flags and docs forbid. Sandboxing the AppImage under a
fake `$HOME` is not a documented/supported ZCode operation and would amount
to state fabrication, not validation. Per the Gate brief this session does
not fake the result; the leg stays with the owner, exactly as Gate 2
scoped, with the checklist tightened below.

## 3. Automatable validation executed this Gate

| Step | Result |
|---|---|
| Official zai-org/zcode-plugins validator (fetched fresh 2026-09-23, Apache-2.0, not vendored), staged marketplace-layout run | **`OK: 1 plugin(s) validated`** (exit 0) |
| Manifest version == marketplace version == `VERSION` (`0.1.0-rc.1`) | PASS (check-parity.sh, CI layer A) |
| Projection byte-parity of `plugins/iaa/skills/iaa` vs repo core | PASS (check-parity.sh) |
| Layout conformance (`.zcode-plugin/plugin.json`, `source: ./plugins/iaa`, i18n, category, no symlinks, ≤250-char description) | PASS (validator + static checks) |
| `iaa doctor` ZCode surfaces | reports skills-dir presence + plugin-workspace; read-only |

## 4. What static evidence exists vs what ONLY the GUI leg adds

Static evidence establishes: marketplace/manifest schema conformance,
byte-exact core distribution, version pinning, description budget, and —
from the machine datum — that ZCode's registry consumes this class of
marketplace entries in practice.

The GUI leg alone would add, in-app and behavioral: (1) Discover listing
of the local marketplace, (2) install/enable lifecycle semantics,
(3) per-turn skill injection with the ≤250-char description actually
loading the skill, (4) `$iaa` resolution, (5) the no-double-trigger check
against `disable-model-invocation`, (6) disable → skill disappears.

## 5. Publication-safe status determination

- ZCode **skills-dir form** (`manage.sh install`): **TESTED** — historical
  production usage + 2026-08 campaign-era integration + doctor coverage.
- ZCode **plugin form**: **STRUCTURALLY COMPATIBLE** — official validator
  PASS (re-run this Gate), schema/layout/version/description conformance,
  byte-identical core, plus the machine-context datum; no in-app behavioral
  evidence exists, so it is NOT claimed as TESTED or PARTIALLY TESTED.
  PREVIEW is unnecessary given the validator-backed structural claim.

## 6. Manual checklist for the owner (release-day, ~5 minutes)

Precondition: to avoid the duplicate-activation hazard, run the GUI leg on
a machine/profile WITHOUT `~/.zcode/skills/iaa`, or `manage.sh uninstall`
first (ZCode-runtime scope), or accept a temporary duplicate and remove
the skills-dir link after the check.

- [ ] Settings → Plugin management → Discover → **+** → add local
      marketplace path `<repo>/packaging/zcode`
- [ ] Install + enable `iaa`; open a NEW session
- [ ] `$iaa` resolves and answers per the core policy (materiality rule +
      zero-agent default)
- [ ] Settings → Skills (Refresh) shows `iaa` with the 249-char description
      — and `orchestrate` does NOT appear as a second auto-triggerable
      skill (double-trigger check)
- [ ] Disable the plugin → after refresh the skill is gone from discovery
- [ ] Optional: `sh <repo>/scripts/iaa integrate --runtime zcode --mode
      plugin` → verify the marker block; `iaa doctor` clean
- [ ] Record outcomes here (or in the release notes) and upgrade the
      matrix row to TESTED if all pass

Upgrade rule: with the checklist green at the installed version, the
plugin-form row may be re-labeled TESTED **at that ZCode version only**;
version movement re-triggers the re-verification discipline.
