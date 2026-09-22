# Gate 2 — 03: Package Architecture (one authoritative behavioral core)

Date: 2026-09-23. Target picture from the Gate brief:

```
                     İAA behavioral core  (repo iaa/ — authoritative)
                             |
             +---------------+---------------+
             |               |               |
          Claude           Codex           ZCode
          package          package          package
        (packaging/claude) (packaging/codex) (packaging/zcode)
```

## 1. Authoritative source layout

The **repository `iaa/` directory stays the single authoritative behavioral core**,
exactly as versioned since the baseline (shape unchanged; hashes frozen in
`00-semantic-freeze.md`):

```
iaa/                                  ← THE behavioral core (authoritative)
├── SKILL.md                          policy: modes, boundary, decision core
├── references/delegation-contract.md brief/handoff/acceptance contract
├── references/platform-adapters.md   Claude/Codex/ZCode mechanism facts
├── scripts/manage.sh                 install/verify/uninstall (script mode)
└── tests/scenarios.md                behavioral contract A–K

VERSION                               public package version (0.1.0-rc.1)
scripts/iaa                           management CLI: doctor/integrate/unintegrate/deploy
scripts/build-packages.sh             deterministic projection generator
scripts/check-parity.sh               one-core parity + version + identity enforcement
scripts/build-release.sh              private RC assembly (§21)
packaging/claude/  packaging/codex/  packaging/zcode/   GENERATED packages
docs/ …                               public documentation
```

Rule: **nothing under `packaging/` is ever edited by hand.** Every file there is a
generated projection of an authoritative source (`iaa/`, `VERSION`, or a
packaging-owned template that itself lives in `packaging/templates/` and is the
single place packaging metadata is authored). `scripts/check-parity.sh` (CI layer A,
§14) fails on drift.

## 2. What is "the core" vs "adapter facts" vs "packaging metadata"

| Class | Files | Change discipline |
|---|---|---|
| Behavioral core | `iaa/SKILL.md`, `iaa/references/delegation-contract.md`, `iaa/references/platform-adapters.md`, `iaa/tests/scenarios.md` | frozen (§2 freeze); change = owner design decision + §23 category-D proof burden |
| Installer (core-tree, but installer mechanics) | `iaa/scripts/manage.sh` | Gate-2 changeable as category A; this Gate keeps it byte-identical |
| Packaging metadata | `VERSION`, plugin manifests, marketplace entries, `packaging/templates/**` | free to change; parity-checked against `VERSION` |
| New integration tooling | `scripts/iaa` | category A; unit-tested; shim text byte-parity with `manage.sh` enforced by CI |
| Diagnostics | `scripts/iaa doctor` | read-only by construction (§12) |

## 3. Generated packages (projections)

### 3.1 `packaging/claude/` — Claude Code plugin `iaa`

```
packaging/claude/
├── .claude-plugin/plugin.json        name: iaa, version from VERSION
├── skills/iaa/…                      byte-exact copy of repo iaa/ (+ PROVENANCE)
├── skills/orchestrate/SKILL.md       thin EXPLICIT-ONLY entry point (see §4)
├── bin/iaa                           copy of scripts/iaa (on PATH in-session)
├── README.md                         generated from template: install/update/uninstall
└── PROVENANCE                        version + source marker
```

- No MCP, no agents, no hooks, no daemon, no secrets (Gate §7 constraints).
- Validated by `claude plugin validate --strict`.
- The current official docs mark `commands/` as legacy ("use skills/ for new
  plugins"), so `/iaa:orchestrate` is realized as a skill, not a command file.

### 3.2 `packaging/codex/` — Codex (script-primary; plugin form prepared)

```
packaging/codex/
├── plugin/.codex-plugin/plugin.json  Codex plugin manifest (name: iaa)
├── plugin/skills/iaa/…               byte-exact copy of repo iaa/ (+ PROVENANCE)
├── marketplace/.agents/plugins/marketplace.json   local-marketplace catalog entry
└── README.md                         generated: skills-dir install (primary) + plugin (optional)
```

- Primary Codex form in Gate 2 remains **skills-dir + script** (`~/.agents/skills` +
  `manage.sh`), per comparison/08-D6 — the plugin form is assembled and statically
  validated but not submitted anywhere.
- Marketplace format follows the official `openai/plugins` layout (verified against
  the official repo and the working local `codex-warp` marketplace).

### 3.3 `packaging/zcode/` — ZCode plugin (thin `.zcode-plugin` adapter → option B)

```
packaging/zcode/
├── plugin/.zcode-plugin/plugin.json  ZCode manifest (name: iaa) — decision B below
├── plugin/skills/iaa/…               byte-exact copy of repo iaa/ (+ PROVENANCE)
├── plugin/skills/orchestrate/SKILL.md thin explicit entry (mirrors Claude's)
├── marketplace/marketplace.json      personal-marketplace catalog entry (ZCode format)
└── README.md                         generated: GUI install + manual validation steps
```

**A vs B decision (Gate brief §10): B — a thin `.zcode-plugin` runtime adapter.**
- Current official ZCode docs (zai-org/zcode-plugins `docs/PLUGIN_DEVELOPMENT.md`,
  fetched 2026-09-23) specify `.zcode-plugin/plugin.json` as the manifest entry
  point and a marketplace format with name+version equality rules. Reusing the
  Claude manifest (option A) is *accepted* by ZCode, but the official form is
  `.zcode-plugin`, ZCode marketplace entries need `category`/`description` fields
  Claude does not define, and ZCode has no `bin/` concept. A thin adapter whose
  only differing file is the manifest + README is smaller divergence than forcing
  one manifest to satisfy both validators.
- This is NOT a semantic fork: the adapter contains **zero** behavioral text; the
  skill tree is the same byte-exact projection.

### 3.4 `release-hardening/evals/iaa-dev-plugin/skills/iaa/`

The Gate-1 dev plugin's skill copy joins the parity umbrella (fifth projection),
refreshed by the same build script.

## 4. `/iaa:orchestrate` — thin entry skill (no second implementation)

Plugin skills are addressed `plugin-name:skill-name`. The core skill keeps
`name: iaa` (identity-frozen), giving `iaa:iaa` as its namespaced address. The
public invocation `/iaa:orchestrate` is therefore realized as a **second, thin,
explicit-only skill** `skills/orchestrate/SKILL.md`:

- frontmatter: `name: orchestrate`, one-line description, **`disable-model-invocation: true`**
  (it is an entry point, not a trigger surface — this preserves the single
  description-trigger surface, avoiding a second auto-triggerable İAA listing).
- body (≈5 lines): "Explicit İAA orchestration entry point. Load and follow the
  `iaa` skill bundled in this plugin for the current task…" — it adds **no policy**,
  delegates entirely to the core, and is counted as invocation mechanics (§23
  category C), not semantics.

## 5. Parity enforcement (automatic, fails on drift)

`scripts/check-parity.sh` verifies, for EVERY projection (claude, codex, zcode,
dev-plugin):

1. `skills/iaa/` file set ⊇ core file set and each core file byte-exact
   (`cmp` against repo `iaa/`; extra files allowed only `PROVENANCE`).
2. `PROVENANCE` exists, carries the `VERSION` string and the "generated — do not
   edit" marker.
3. Every manifest `version` == `VERSION`; every manifest `name` == `iaa`.
4. The shim text embedded in `scripts/iaa` is byte-identical to the two routing
   paragraphs embedded in `iaa/scripts/manage.sh` (extract-and-compare).
5. Re-running `scripts/build-packages.sh` produces a clean tree (`git status`
   unchanged) — deterministic generation.

CI (§14 layer A) runs this on every PR; the Gate-2 branch must pass before merge.

## 6. Why the core is not restructured (iaa-core/ move rejected)

`docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md` sketched an `iaa-core/` +
`adapters/{claude,codex,zcode}` layout. Gate 2 keeps `iaa/` as-is because (a) the
live runtime tree, three consumer symlinks, and all recorded evidence hashes point
at the current shape — moving it buys nothing and rewrites provenance; (b) the
brief's requirement is ONE authoritative core with generated projections, which the
`iaa/` + `packaging/` split already satisfies; (c) §6 normalization makes the repo
authoritative without renaming anything. A future restructure is a cosmetic
owner decision, not needed for public packaging.

## 7. Source markers

Every generated directory carries `PROVENANCE`:

```
İAA generated projection — DO NOT EDIT BY HAND
source-of-truth: iaa/ (repository root)
version: <VERSION>
generated-by: scripts/build-packages.sh
```

and each generated `skills/iaa` keeps the core's own files untouched (no injected
headers into SKILL.md — byte-exactness outranks in-file markers).
