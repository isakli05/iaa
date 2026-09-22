# Gate 2 — 02: Identity Technical Validation

Date: 2026-09-23. Scope: NOT branding (decided: İAA — İştirak-i A‘mâl-i Ajanîye /
`iaa` / `/iaa:orchestrate`; not reopened). This document verifies only that `iaa` is
**technically usable** as the namespace/package identifier on the targeted current
public surfaces, checked 2026-09-23.

## 1. Syntax validity per runtime packaging rules

| Runtime | Rule (current official source) | `iaa` valid? |
|---|---|---|
| Claude Code plugin | `name` required, kebab-case, no spaces/control/bidi chars (code.claude.com/docs/en/plugins-reference) | ✅ matches |
| ZCode plugin | `^[a-z0-9][a-z0-9._-]{0,127}$`, 1–128 chars (zai-org/zcode-plugins docs/PLUGIN_DEVELOPMENT.md §1.6/2.2) | ✅ matches |
| Codex plugin | kebab-case convention; examples `notion`, `linear`, `build-ios-apps` (github.com/openai/plugins) | ✅ matches |
| Skill names (all) | short, stable, lowercase; `iaa` = the frozen SKILL.md frontmatter name since the identity migration | ✅ unchanged |

## 2. Collision checks (executed, not assumed)

| Surface | Method (2026-09-23) | Result |
|---|---|---|
| GitHub repositories | `gh api search/repositories?q=iaa+in:name` (7397 results scanned top-20) | No prominent `owner/iaa`; top hits are `IAA`-capitalized small repos (≤30 stars) and IaaS-unrelated names. Our private `isakli05/iaa` exists and is unaffected. No blocker. |
| Claude official marketplace (`claude-plugins-official`, 310 plugins) | parsed local marketplace clone `.claude-plugin/marketplace.json` | **0** plugins containing "iaa". Clear. |
| Other locally configured Claude marketplaces (claude-code-warp, impeccable, zai-coding-plugins) | parsed local marketplace files | 0 hits. Clear. |
| Codex official curated marketplace (`openai/plugins` `.agents/plugins/marketplace.json`) | fetched from GitHub API | 0 hits. Clear. |
| Codex remote catalog visible to local CLI (`codex plugin list`, 0.156.0) | grep over full listing | 0 hits. Clear. |
| ZCode official marketplace (`zai-org/zcode-plugins` root `marketplace.json`, 26 plugins) | fetched from GitHub API | 0 hits. Clear. |
| Superpowers skills (6.4.1 local cache) | name scan | no `iaa` skill. Clear. |
| Web search (Claude/Codex plugin indexes, general) | "iaa" plugin marketplace searches | no known public `iaa` agent-plugin/skill found; "IAA" hits are unrelated (Inter-Annotator Agreement, Israel Antiquities Authority, IaaS cloud). |

## 3. Findings

1. **No exact unavoidable collision exists on any targeted runtime.** No
   runtime-specific package slug divergence is needed: the public namespace stays
   `iaa` everywhere.
2. Residual, unavoidable observations (not blockers):
   - GitHub name-matching is case-insensitive at access time; several tiny `IAA`
     repos exist (personal projects, ML course material). None is an agent-CLI
     orchestration project; confusion risk is negligible and renaming would not
     remove it.
   - "iaa" is a short string that substring-matches unrelated words in broad web
     search (IaaS, IAARhub). This affects discoverability, not technical validity.
     Mitigation is repository description/topic metadata at public-release time
     (Gate 3+), not a rename.
   - Marketplaces are living registries: the pre-submission name search must be
     re-run immediately before any actual marketplace submission (recorded as a
   Gate-3/publication-day checklist item, consistent with comparison/08-D5).
3. The **plugin's bundled skill** keeps frontmatter `name: iaa`, so under the
   Claude plugin namespace the skill address is `iaa:iaa` and the explicit entry
   point is `/iaa:orchestrate` (a second, thin, explicit-only skill named
   `orchestrate` — see 03-package-architecture.md §4). No naming rule prohibits a
   plugin and its skill sharing a name (superpowers@6.4.1 bundles no same-named
   skill, but `claude plugin init` scaffolds exactly this shape: "plugin name
   becomes the skill namespace").

## 4. Verdict

`iaa` is **technically valid and unclaimed** on every targeted current packaging
surface (GitHub, Claude marketplace rules + official catalog, Codex official
marketplace rules + curated catalog, ZCode official marketplace rules + catalog).
Proceed with `iaa` as the single public namespace; re-check marketplaces at
submission time.

Sources: local marketplace clones & plugin caches (checked directly);
[Plugins reference — Claude Code Docs](https://code.claude.com/docs/en/plugins-reference);
[zai-org/zcode-plugins PLUGIN_DEVELOPMENT.md](https://github.com/zai-org/zcode-plugins/blob/main/docs/PLUGIN_DEVELOPMENT.md);
[openai/plugins](https://github.com/openai/plugins);
`gh api search/repositories`, `codex plugin list`.
