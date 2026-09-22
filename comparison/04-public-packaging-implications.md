# Comparison 04 — Public Packaging Implications

Date: 2026-09-22. Research-based implications for İAA distribution. **Nothing here is
implemented.** The historical İAA/SDD boundary rests on the managed-shim routing sentence;
per the task mandate, its removal is not recommended merely because plugin systems exist —
any replacement must reproduce and test the same routing guarantee.

## 1. The candidate architecture, re-evaluated against current platform facts

```
one runtime-agnostic İAA behavioral core  (iaa-core/ = current skill, byte-identical)
              |
      runtime packaging/adapters
        /        |         \
     Claude     Codex      ZCode
```

Current-source verdict: **architecture remains sound, and the platforms have moved toward
it** since the baseline pack was written. New facts (all DOCUMENTED/IMPLEMENTED in
evidence streams):

- **Cross-manifest acceptance is now ecosystem-native.** ZCode officially accepts
  `.claude-plugin/plugin.json` (priority: `.zcode-plugin/` → `.claude-plugin/`) and
  **preloads the Claude Code marketplace** as a personal source; Codex's enterprise
  marketplace import accepts `.agents/plugins/marketplace.json` **and Claude formats**
  (`.claude-plugin/marketplace.json` / `plugin.json`); the Codex portable plugin format is
  a root `plugin.json` (with `.codex-plugin/plugin.json` as the generated compatibility
  manifest). One repository hosting `.claude-plugin/plugin.json` + `.codex-plugin/
  plugin.json` (or root `plugin.json`) + a ZCode marketplace entry pointing at the same
  tree is feasible **today** with no semantic forks in the skill itself.
- The core stays verbatim: SKILL.md + references are pure prose with no runtime-specific
  syntax. ZCode constraints already honored (description 245–249 chars; flat
  `skills/<name>/` layout). Codex skills dir `~/.agents/skills` and symlink support are
  official; Claude user skills + symlink official.

## 2. Claude Code — first-class plugin packaging

Favorable current facts: plugin manifests need only `name`; skills bundle under
`skills/<name>/SKILL.md`; marketplaces from GitHub repos; `claude plugin validate
--strict`; `claude plugin eval` (v2.1.269+) runs **behavioral evals with trigger-rate
graders (`tool_used: Skill`) in isolated sandboxed sessions, with a no-plugin control
arm** — i.e., the platform now ships exactly the harness İAA's scenario J needs (see §6);
`/skill-doctor` surfaces per-skill cost/usage for users.

Costs/risks (documented):
- **Namespacing changes the invocation name.** Plugin skills are `/plugin-name:skill-name`;
  a same-named personal skill and plugin skill **both load** (documented) → duplicate-İAA
  hazard (two routing sentences in one listing) unless the doctor flags it. The **shim
  text names the skill** ("load and follow the installed `iaa`
  skill") — under a plugin, the stable reference is the description/trigger wording, not
  the bare name; the shim sentence and SKILL cross-references must be validated against
  the namespaced form (behavioral test, not just wording).
- **skillOverrides does not reach plugin skills** (official) → users cannot mute a plugin
  İAA the way they can mute a personal skill; the explicit-only fallback (research/03
  model A) would work via `disable-model-invocation` in the skill's own frontmatter, not
  via user override.
- Plugin auto-update is per-marketplace; a plugin İAA can drift versions without the
  owner's upgrade-check discipline → the shim/skill version pin must be checkable by
  `iaa doctor` (hash comparison, as manage.sh verify already does against canonical).
- Marketplace trust review (community: SHA-pin + screening) does not fit an installer that
  writes managed blocks into user instruction files — see §4; distribution channel and
  integration step must remain separable.

## 3. ZCode — one artifact with Claude

- `.zcode-plugin/plugin.json` recommended, `.claude-plugin/plugin.json` accepted → the
  **same published Claude artifact can serve ZCode**; per-workspace plugin install exists
  (3.11.2+); public catalog is curated (GitHub-fed); personal marketplaces from any GitHub
  repo — a public İAA can ship one repo usable in both stores without forking semantics.
- Constraints unchanged from baseline (description ≤1024 hard drop / ~250 injection;
  skills-only-flat layout; hooks limited to 7 events). No implicit-invocation disable
  flag — trigger discipline stays description-based on ZCode regardless of packaging.
- Note: ZCode also reads `~/.agents/skills` as a *fallback* root (source-verified) —
  İAA's existing Codex symlink is visible to ZCode only when no same-named `.zcode/skills`
  skill exists; İAA's own `.zcode/skills` symlink wins. No conflict, but worth a doctor
  check (two discovery paths to one canonical).

## 4. The shim question — why it survives plugin distribution (load-bearing analysis)

All current evidence says **plugins cannot replace the shim**:

1. A Claude plugin has **no instruction-file component**: bundleable parts are
   skills/commands/agents/hooks/mcp/monitors/workflows/settings(limited)/bin; a root
   CLAUDE.md in a plugin is not loaded; install is file-copy with no post-install write
   step (nothing in current plugin docs lets a plugin edit `~/.claude/CLAUDE.md`). Codex
   plugins similarly own no `~/.codex/AGENTS.md`. ZCode plugins hook SessionStart (a
   possible injection channel — see below) but do not manage AGENTS.md.
2. The routing guarantee the evidence rests on is **instruction-channel**: models in 3+
   samples quoted the *shim sentence* while rejecting redirects (C8 PROVEN); Superpowers'
  own bootstrap defers to user instructions. A description-only İAA loses the layer that
   made selection-time exclusion win (ADR-0002's enforcement surfaces list the shim
   explicitly).
3. The alternative channels are worse or semantics-changing: a SessionStart hook injecting
   İAA text every session is Superpowers' channel (context cost; pressure-not-authority;
   and on Claude it would run in *every* session including native-mode ones — a behavior
   change the frozen baseline explicitly rejected); relying on plugin skill description
   alone is the "weaker" option the baseline already ranked below the shim.

**Implication (design input, not implemented):** the "plugin distributes, script
integrates" pattern from docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md is *confirmed* by
current platform facts: plugin/marketplace forms carry discovery, versioning, and
namespacing; `manage.sh` (or a thin equivalent) remains the only component that writes the
marker-delimited shim + symlinks, exactly as today, explicitly user-run, loudly disclosed,
reversible. Any future replacement must (a) reproduce the instruction-channel routing
guarantee, (b) pass scenario-J-style behavioral proof (now cheap via plugin eval, §6), and
(c) not violate C11/P7 non-invasiveness.

## 5. Codex — packaging reality check

- Official universal plugin system is public and shipping (ChatGPT+Codex shared
  directory; `/plugins` browser; root `plugin.json` + skills/; submission portal with
  identity verification, domain checks, automated scanning, human review, **5 positive +
  3 negative test cases required** — note for planning: İAA would need a maintained test
  suite to submit, which it currently lacks in automatable form).
- Enterprise GitHub-marketplace path accepts Claude manifests — good for org-internal
  distribution without portal review.
- Consumer path friction: portal review timelines "may vary"; the plain `~/.agents/skills`
  symlink + AGENTS.md shim (current install) remains fully supported and lighter. For a
  policy skill whose value is the shim, **skills-dir + script likely remains the primary
  Codex form; plugin form is optional reach** (submitting İAA to the universal directory
  would distribute a skill *without* its integration step — users would still need
  manage.sh for the shim; the listing must say so).

## 6. Testing upgrade unlocked by packaging: `claude plugin eval`

`claude plugin eval` (2.1.269+) evaluates a plugin in isolated sessions with graders —
`tool_used: Skill` (trigger rate), `tool_order`, `llm` judge, `file_exists`, `regex` —
each case 3× by default **plus a no-plugin control arm** (Δ = plugin contribution), with
JSON/HTML reports and CI exit codes. This converts İAA's highest-value manual scenarios
into repeatable artifacts: J (delegation prompt → assert `superpowers:subagent-driven-
development` skill NOT used, İAA skill used), K (explicit SDD request → SDD used, İAA
not), A (trivial task → no Skill/spawn), artifact-boundary B/D (fixture plan in context).
Caveats for the experiment plan: eval sessions load *only the evaluated plugin* — the
Superpowers co-presence arm needs Superpowers also installed in the eval environment
(possible: cache pre-seeding or a marketplace dependency; untested — 07-E7); sandbox
throwaway-home means the shim is absent unless the eval setup installs it (the shim arm
must be constructed deliberately).

## 7. Identity, versioning, and claim discipline for the public artifact

- **Name/namespace**: un-namespaced `iaa` at user scope is the
  known shadowing risk (limitation #9); plugin forms namespace it. Public identity must
  be chosen once (plugin name, marketplace entries, Codex/ZCode listings all reference
  it) and pre-checked against existing marketplace entries (Superpowers' author
  marketplace alone lists 10 plugins; claude-plugins-official is huge). Owner decision —
  08-D5.
- **Version metadata**: plugin.json `version` (semver, drives update pinning in Claude;
  ZCode marketplace requires manifest==entry version match — dual-release discipline
  needed). SKILL.md itself has no version field (limitation #10) — packaging layer can
  carry it, with manage.sh verify comparing installed skill hash against the packaged
  hash to prevent silent divergence between channels.
- **Claims**: public README may claim only matrix-tested facts (Superpowers/SDD on
  Claude+glm-5.3; GSD/BMAD/Agent-Teams/other models explicitly "not tested together").
  The version-lock discipline of 00 must ship with the product (coexistence claims pinned
  to versions).

## 8. Bottom line

The tri-store plugin architecture is *more* feasible today than at baseline (native
cross-manifest acceptance; native eval harness; namespaced distribution solving the #9
shadowing class). The distribution/integration split is *confirmed as necessary* (no
plugin system writes the user instruction channel; the shim is the proven routing layer).
The public build's hardest new requirements are behavioral: namespaced-invocation
validation, duplicate-install detection (doctor), plugin-eval-ized trigger regression,
and per-store version-sync discipline.
