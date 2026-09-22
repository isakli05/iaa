# Public Distribution Architecture (design constraints — NOT implemented)

Goal: İAA as a publicly installable project that coexists politely with installed
frameworks. Grounded in research/01 (2026-09-22 official mechanisms). No semantics change:
runtime adapters adapt *mechanisms*, never fork İAA's meaning.

## Recommended target architecture

```
repository (this repo)
│
├── iaa-core/  ← the current iaa/ skill directory, verbatim
│     (SKILL.md, references/, tests/scenarios.md — 100% runtime-agnostic)
│
├── adapters/
│   ├── claude/     plugin packaging + manage.sh install logic for Claude Code
│   ├── codex/      packaging for Codex (+ optional agents/openai.yaml)
│   └── zcode/      packaging for ZCode
│
├── tests/ (fixtures, tools, scenario execution records)
├── docs/ research/ audit/ historical-notes/ (this baseline)
```

One behavioral core; per-runtime adapters carry only install/discovery mechanics. The
canonical SKILL.md/references stay byte-identical across all distribution forms — a user
must not get different İAA semantics from different channels.

## Per-runtime packaging evaluation

### Claude Code — first-class plugin (recommended primary form)
- Feasible today: `.claude-plugin/plugin.json` (`name` kebab-case = namespace, `version`
  semver), plugin command exposed as `/iaa:orchestrate` — the **final decided public
  invocation** (command naming arrives with Gate-2 packaging; until then the standalone
  skill remains `iaa`); marketplace distribution (`/plugin install
  iaa@<marketplace>`); `claude plugin validate --strict`; update pinned by version; clean
  uninstall; **namespacing eliminates Class-2 collisions with any same-named local skill**.
- Coexistence with personal installs: plugin and personal skills both load (no override) —
  must be handled by docs ("don't install both forms") + `iaa doctor` duplicate detection.
- Open design point: the **global CLAUDE.md shim** (the load-time routing rule all evidence
  rests on) is NOT reproducible by a plugin automatically — plugins don't write user
  instruction files, and shipping a hook that edits CLAUDE.md would be exactly the
  invasive behavior İAA forbids itself. Candidates: (a) plugin README instructs running
  `manage.sh install` for the shim (plugin = distribution, script = integration); (b) rely
  on plugin skill description alone (weaker: loses the instruction-channel precedence that
  beat SDD); (c) a SessionStart hook that only *appends context* (like Superpowers') —
  rejected for baseline as a semantics change. → **UNRESOLVED DECISION for the design
  phase**; evidence (ADR-0001/0002) says the instruction channel is load-bearing.
- Also available: skills-dir plugin (`@skills-dir`) — a folder with plugin.json inside a
  skills dir; lowest-friction hybrid for power users.

### Codex — plugin (official system exists) + skills dir
- Skills channel stays valid: `~/.agents/skills` (official user dir) — current install
  model remains correct. Plugin channel: universal ChatGPT+Codex plugin directory
  (submission/review; bundles skills). Optional `agents/openai.yaml` (display metadata;
  implicit-invocation policy). AGENTS.md shim still requires an install step (plugins
  don't own the user's global AGENTS.md) → same pattern as Claude: plugin distributes,
  script integrates.

### ZCode — plugin via preloaded Claude marketplace path
- ZCode accepts **`.claude-plugin/plugin.json`** manifests and preloads the "Claude Code
  marketplace" as a personal source — the same published plugin artifact can serve both
  runtimes. Skills-only distribution has no marketplace; plugins are the channel.
- Constraints already honored by core: description ≤250 injected chars (packaging
  invariant), flat `skills/<name>/` layout, symlink import supported for manual installs.
- AGENTS.md shim again requires the install script.

## Cross-cutting decisions to make in the design phase (not now)

1. **Identity/namespace: DECIDED (2026-09-23)** — public plugin name `iaa`; short name
   `İAA`; full display name `İAA — İştirak-i A‘mâl-i Ajanîye`; primary invocation
   `/iaa:orchestrate` (see `identity-migration/` and comparison/08-D5). Still must not
   collide with existing marketplace entries; verify with a name search before claiming.
   All public identifiers namespaced; no generic command names.
2. **Shim distribution ethics:** İAA's value depends on an instruction-channel rule, but
   auto-editing users' global instruction files is acceptable only if: marker-delimited,
   backed up, idempotent, reversible via uninstall, and loudly disclosed — which is exactly
   what manage.sh already does. Keep install explicit (never post-install-hook writes).
3. **Versioning:** add version metadata at packaging layer (plugin.json), keep the core
   hash-pinned (docs/SOURCE-OF-TRUTH procedure); consider a version field in SKILL.md
   metadata in the design phase (currently absent — limitation #10).
4. **Doctor:** ship `iaa doctor` (design/COMPATIBILITY-DIAGNOSTIC-PROPOSAL.md) with the
   installer — public users need the duplicate/collision report.
5. **Claim discipline:** public README may claim only what the matrix shows tested
   (Superpowers/SDD on Claude, glm-5.3); GSD/Agent Teams/other models = explicitly
   "not tested together".

## What must NOT happen (derived from the ownership contract)

- No installer that overwrites foreign skills, settings, hooks, or plugin files.
- No auto-load of a second orchestration authority; no wrapper-of-SDD mode.
- No per-runtime forks of SKILL.md meaning (adapters adapt mechanisms only).
- No public claim of compatibility that a campaign-style test hasn't produced.
