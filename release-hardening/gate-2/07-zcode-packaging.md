# Gate 2 — 07: ZCode Packaging

Date: 2026-09-23. Deliverable: `packaging/zcode/` — a thin `.zcode-plugin`
runtime adapter (option B of the Gate brief) around the same behavioral core.

## 1. A vs B decision: B — thin `.zcode-plugin` adapter

- Current official ZCode docs (zai-org/zcode-plugins `docs/PLUGIN_DEVELOPMENT.md`,
  fetched 2026-09-23) specify **`.zcode-plugin/plugin.json` as the manifest
  entry point** (client lookup order: `.zcode-plugin` → `.claude-plugin`),
  a marketplace format with `owner`/`description_i18n` (en + zh-CN)/`category`
  fields, and `source: "./plugins/<name>"` layout rules.
- Reusing the Claude manifest verbatim (option A) is *accepted* by ZCode but
  cannot satisfy the official marketplace schema (i18n descriptions, category
  vocabulary, strict layout) without overloading the Claude manifest with
  ZCode-only fields. A thin adapter whose only runtime-specific files are the
  manifest + plugin README is the smaller, honest divergence.
- **Not a semantic fork**: the adapter contains zero behavioral text; the
  skill tree is the same byte-exact projection (parity-checked).

## 2. Package layout (official marketplace-repo convention)

```
packaging/zcode/
├── marketplace.json                ZCode marketplace catalog (name/owner/i18n/entry)
├── plugins/iaa/
│   ├── .zcode-plugin/plugin.json   manifest: name iaa, version from VERSION, skills
│   ├── skills/iaa/…                byte-exact core (+ PROVENANCE)
│   ├── skills/orchestrate/SKILL.md explicit entry (same template as Claude)
│   └── README.md                   purpose/dependencies/permissions/network/side-effects
└── README.md                       packaging-level install + manual validation checklist
```

## 3. Static validation (executed, not assumed)

Run of the **official validator** (`scripts/validate.py` from
zai-org/zcode-plugins, Apache-2.0, fetched 2026-09-23) against this layout:

```
OK: 1 plugin(s) validated
```

Checks it thereby passed: marketplace required fields incl.
`description_i18n.{en,zh-CN}`; entry name kebab + unique; `source` exactly
`./plugins/iaa`; manifest found at `.zcode-plugin/plugin.json`; manifest
name/version == marketplace entry (`0.1.0-rc.1` semver); category in the
allowed vocabulary (`productivity`); no symlinks; size caps. Additional
constraints honored from the docs: skill description ≤250 chars for per-turn
injection (the core's 249-char description — an İAA packaging invariant since
the baseline), flat `skills/<name>/` layout.

## 4. Invocation surface

- `$iaa` explicit or description-based per-turn injection (primary trigger
  surface — unchanged semantics).
- `skills/orchestrate` is the explicit analog of `/iaa:orchestrate`; ZCode
  has no documented plugin-namespaced slash-command surface, and skill
  frontmatter `disable-model-invocation: true` is kept from the shared
  template. Honest note: whether ZCode honors that field is not documented;
  if ignored, the narrow description ("Explicit İAA orchestration entry
  point…") keeps it out of description-matching contests. The manual GUI
  checklist includes verifying no double-triggering.
- AGENTS.md routing block: `iaa integrate --runtime zcode --mode plugin`
  (explicit, reversible; same marker discipline).

## 5. Install / update / uninstall lifecycle

Per the official docs:

- **Install**: local marketplace — create a marketplace whose
  `plugins[].source` points at the plugin dir; Settings → Plugin management →
  Discover → **+** → add the local marketplace path; install + enable.
- **Marketplace/local-source behavior**: hooks run only for official-marketplace
  or local-directory installs — irrelevant here (no hooks shipped).
- **Update**: every packaged file requires a version bump in **both** manifest
  and marketplace entry (validator-enforced; our build script stamps both from
  `VERSION`, and check-parity fails on mismatch).
- **Uninstall**: disable/remove in Settings → Plugin management; run
  `iaa unintegrate --runtime zcode --mode plugin` if integrated.
- **Compatibility fallback / version detection**: manifest-first lookup
  (`.zcode-plugin`) means older ZCode builds that only scan
  `.claude-plugin`… would not see the plugin — accepted for the RC (ZCode
  3.7.1+ is the documented baseline for current plugin support; the machine's
  3.11.2 is within it). `iaa doctor` reports ZCode skill/plugin presence.

## 6. Manual validation checklist (NOT executed in Gate 2 — GUI required)

The installed ZCode desktop (3.11.2) requires GUI interaction for plugin
install; per the Gate brief this is documented, not faked:

- [ ] `python3 scripts/validate.py` equivalent passes (done statically — see §3)
- [ ] Add `packaging/zcode` as a local marketplace in Settings → Discover
- [ ] Install + enable `iaa`; new session; `$iaa` resolves
- [ ] Settings → Skills → Refresh shows the skill with ≤250-char description
- [ ] `$orchestrate` resolves and routes to the iaa skill
- [ ] Disable plugin → skill disappears from discovery after refresh
- [ ] `iaa integrate --runtime zcode --mode plugin` then verify marker block
- [ ] No duplicate activation with any pre-existing `~/.zcode/skills/iaa`

Owner action item for Gate 3 / release day: execute this checklist on the
desktop app (and ideally re-anchor the adapter text against the installed
version, per the KNOWN-LIMITATIONS 3.7.7-anchor note).

## 7. Local machine observations feeding the doctor

`~/.zcode` exists with skills (incl. the `iaa` symlink — script-form install)
and an (empty) `plugin-workspace/`; the doctor reports ZCode skill presence,
plugin-workspace contents, and duplicate combinations. The ZCode docs' note
that `~/.agents/skills` is also read as a fallback root is covered by the
duplicate-detection logic (both surfaces checked).
