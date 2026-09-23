# İAA 0.1.1 — Static Validation Record (pre-GUI)

Date: 2026-09-23. Branch `release/0.1.1-zcode-packaging` (from main
`793124da363a2b597be33e5de2cce47f09470705`). Candidate commits at this record:
`b65e671` (packaging adapter + build system + version flip), `1f9bd78` (docs).
Controller: main Claude Code / GLM-5.3 session (sole controller per the task
brief). Upstream reference: `zai-org/zcode-plugins` @ `cf739288` (2026-09-17 —
re-cloned fresh; upstream unchanged since the September-23 evidence).

## Baseline / semantic freeze (before any change)

Authoritative behavioral core (identical to the Gate-3 freeze table quoted in
`post-release/zcode-official/`):

| File | SHA256 |
|---|---|
| `iaa/SKILL.md` | `73f7b8870a578cba5bf702c38353112c66e6c410504d89d23fb96b14930b9eba` |
| `iaa/references/delegation-contract.md` | `23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632` |
| `iaa/references/platform-adapters.md` | `849b769cf4846fede9bf624b4c36a86ee921c586c3030c0589c06c61abec82d2` |
| `iaa/tests/scenarios.md` | `5fa9617ed9eabef69ffc348d03f210fab9a2099def08c7d2ca5d9de724c705cf` |
| `iaa/scripts/manage.sh` | `21964702e3c581c721657dd6b2581aec57cbe3c853da5c86be112531dd0ccf8e` |
| `scripts/iaa` (management CLI) | `4d78fd579aa98a472e49ee148515ef967cfb0f599b3cedb63a9802bfe311fb00` |

**Semantic result: D = NONE.** No core file was touched by the patch (verified
again post-change; see `02-gui-validation.md` / final report). Tags `v0.1.0`
(→ `130c543`, annotated) and `v0.1.0-rc.1` (→ `0d4c563`) intact and untouched.

## What the patch changed (ZCode channel only + version stamps)

1. `skills/orchestrate/SKILL.md` → **`commands/orchestrate.md`** in the ZCode
   package (ZCode documents `disable-model-invocation` for Command frontmatter
   §2.3 only; Skill frontmatter §2.4 documents `name`+`description` — F4 root
   cause). Manifest gains `"commands": "commands"`. Claude package unchanged.
2. **`README_CN.md`** added to the ZCode plugin (mandatory upstream contract;
   16-topic semantic-parity check vs the extended English README — all OK,
   12 bullets each).
3. **`marketplace.remote.json`** — public remote marketplace document using the
   official verified-archive source (`url`/`zip`/`sha256`/`path`, distribution.md
   schema). Relative-source `marketplace.json` retained unchanged in meaning
   (local-path / cloned-repo / upstream-contribution form).
4. **Deterministic `plugin.zip`** via new `scripts/build-plugin-zip.py`
   (official `build_dist.py` discipline: sorted entries, fixed 2026-01-01
   timestamp, uniform 0644, deflate, symlink-refusing, single top-level `iaa/`).
5. Version `0.1.0 → 0.1.1` across all surfaces (same 16-file class as the 0.1.0
   flip). Claude/Codex packages: version stamps only.

## Command-name resolution evidence (exact invocation syntax)

From the ZCode 3.14.3 client (`app.asar`, `resources/glm/zcode.cjs`):

- `resolvePluginCommandRoots`: manifest `"commands": "commands"` resolves the
  command root to `<plugin>/commands` (auto-discovery only when the manifest
  field is absent).
- `getCommandName`: `/` + path relative to that root, `.md` stripped, segments
  joined with `namespaceSeparator: "/"` (zcode plugin descriptor `Ad`) →
  `commands/orchestrate.md` surfaces as **`/orchestrate`** (flat; no plugin
  prefix). User commands shadow same-named plugin commands (dedupe keeps the
  user scope entry first).
- Official shipped examples of the same mechanism: `android-emulator` →
  `/android-dev`, `ios-simulator` → `/ios-dev`, `restore-legacy-sessions` →
  `/restore-legacy-sessions` (all from `plugins/*/commands/*.md`).
- No `/orchestrate` collision: none of the 40 official-marketplace plugins
  exposes it; no `~/.zcode/commands` exists on this machine.
- Command file follows the official `android-dev.md` pattern: `description` +
  `argument-hint` + `skills: iaa` + `disable-model-invocation: true`
  (documented §2.3 field) and a body delegating to the bundled `iaa` skill with
  `$ARGUMENTS` passthrough.
- `$iaa` skill syntax confirmed current: `$` is a live skill-trigger character
  in the ZCode input (`[/@$#…]` autocomplete regex; skills listed by name).
  Same-name skill dedupe precedence: workspace > plugin > user scope.

## Remote zip installer contract (client-code evidence)

From `zcode.cjs` (`KGr`/`Yun`/`Qun`):

- `sha256` is mandatory for `url`+`zip` sources and verified byte-exact
  (`Plugin zip sha256 mismatch` on failure).
- URL scheme must be HTTPS **except** `localhost` / `::1` / `127.0.0.0/8`
  (explicit local-testing allowance) → the §6 remote-source contract test over
  `http://127.0.0.1:<port>/` is a sanctioned client path, not a hack.
- Extraction safety: entry-name validation, absolute/traversal blocked,
  encrypted entries rejected, **symlink entries rejected**, size/count limits
  (50 MB/file, 20k entries), `path` subdirectory must exist, single-top-level
  root detection, manifest lookup `.zcode-plugin` → `.claude-plugin` →
  `.codex-plugin`. Our archive satisfies all (12 entries, 18 217 bytes, one
  top-level `iaa/`, no symlinks, no directories, all modes 0644).

## Checks run (all PASS)

| Check | Result |
|---|---|
| `python3 scripts/validate-static.py` | OK (frontmatter incl. new Command checks, links, ASCII paths, secrets, identity scopes) |
| `sh scripts/check-parity.sh` | ALL PARITY CHECKS PASSED — core byte-exact in all 4 projections; command/README_CN template parity; one-skill rule (`skills/` = exactly `iaa`); no `skills/orchestrate`; remote marketplace sha pin == freshly built zip; manifests name/version = `iaa`/`0.1.1`; shim parity; **deterministic regeneration** (committed inputs) |
| Official `python3 scripts/validate.py` (staged contribution tree) | `OK: 1 plugin(s) validated` |
| Official `python3 scripts/build_dist.py` (staged contribution tree) | builds `plugins/iaa/0.1.1/plugin.zip` — **byte-identical** to our `dist/iaa-0.1.1-plugin.zip` (`cmp` clean; sha256 `621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`) |
| Deterministic plugin.zip | two consecutive builds byte-identical; `scripts/build-release.sh HEAD` run twice → `diff -r dist` clean (all 5 artifacts byte-reproducible); release-build cross-check `marketplace.remote.json` sha pin == built zip passed |
| Archive safety | `testzip` clean; no absolute/traversal paths; no directory entries; all entries under `iaa/`; fixed date 2026-01-01; modes 0644; deflate |
| `sh tests/doctor/run-tests.sh` | ALL 13 DOCTOR TESTS PASSED |
| `sh tests/install-matrix/run-matrix.sh` | 14 passed, 0 failed, 2 skipped (documented env limits: authenticated Codex session, ZCode GUI) |
| `git diff --check` | clean |
| README/README_CN semantic equivalence | 16/16 topics present in both; 12 bullets each; no marketing superlatives; no universal-compatibility claims |
| Version consistency | only intentional historical `0.1.0` mentions remain (README lineage, COMPATIBILITY history, INSTALLATION limitation note, packaging READMEs) |
| 0.1.0 immutability | `v0.1.0`/`v0.1.0-rc.1` tags unchanged; no release asset touched (no mutation API called); `git diff v0.1.0 HEAD` = this patch only |

## Deterministic plugin.zip (candidate)

- Path: `dist/iaa-0.1.1-plugin.zip` — 18 217 bytes, 12 entries.
- SHA256: `621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`
  (pinned in `packaging/zcode/marketplace.remote.json`; identical to the
  official `build_dist.py` output over the same plugin tree).
- Entries (sorted, fixed mtime 2026-01-01 00:00:00, 0644, deflate):
  `iaa/.zcode-plugin/plugin.json`, `iaa/LICENSE`, `iaa/NOTICE`, `iaa/README.md`,
  `iaa/README_CN.md`, `iaa/commands/orchestrate.md`, `iaa/skills/iaa/PROVENANCE`,
  `iaa/skills/iaa/SKILL.md`, `iaa/skills/iaa/references/delegation-contract.md`,
  `iaa/skills/iaa/references/platform-adapters.md`,
  `iaa/skills/iaa/scripts/manage.sh`, `iaa/skills/iaa/tests/scenarios.md`.

## Remote-source contract test design (§6)

Two documents, deliberately separated:

1. **TEST marketplace** (this task): the production
   `packaging/zcode/marketplace.remote.json` with **only** `source.url`
   swapped to `http://127.0.0.1:8397/iaa-0.1.1-plugin.zip`, served from a
   temporary directory alongside the **exact candidate zip bytes**. Same
   `sha256`, same `path: "iaa"`, same plugin metadata/version. Proves ZCode's
   remote url/zip/sha256 installation path (the client explicitly allows http
   for 127.0.0.0/8). The marketplace itself is added as a **local path**
   (already-proven channel) — the object under test is the remote archive
   source resolution.
2. **PRODUCTION document** (committed): points at the future immutable
   `https://github.com/isakli05/iaa/releases/download/v0.1.1/iaa-0.1.1-plugin.zip`.
   That URL cannot exist before tagging; it is **not** claimed tested. The
   post-publication smoke (final URL) is a mandatory step of the later release
   task; checklist prepared in `03-release-material.md`.

Staged contribution tree used for the official tooling: `/tmp/iaa-zcode-contribution/`
(`marketplace.json` + `plugins/iaa/**` from this branch + upstream `scripts/`).
