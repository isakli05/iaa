# Gate 3 — 06: Submission-Time Name / Namespace Re-check

Date: 2026-09-23 (afternoon re-check; all queries live this date). Branding
is FINAL and was not reopened — this is only the technical collision check
for the identifier `iaa` (skill/plugin/package namespace) at publication
time, repeating Gate-2/02's check.

## Results

| Namespace | Verdict | Evidence |
|---|---|---|
| GitHub repository | **CLEAR** | exact-name repos named `iaa` exist only as tiny academic projects (top: `darkpromise98/IAA`, 30 stars, TMM-2022 metric-learning paper code; plus 3–5-star course/IAA-metric repos); keyword search dominated by unrelated IaaS hits; no namespace pressure |
| Claude plugin (official marketplace) | **CLEAR** | `anthropics/claude-plugins-official` `.claude-plugin/marketplace.json` (185,952 B fetched): **zero** `iaa` matches (any casing); `plugins/` (39) + `external_plugins/` (14) + `anthropics/skills` (19): no `iaa`; GitHub-wide code search `"name": "iaa"` → 0 results; community marketplaces scanned (only hit: a description fragment about inter-annotator agreement) |
| Codex plugin | **CLEAR** | `openai/plugins` `plugins/` (60 entries): no `iaa`; no curated-directory or web hit for a Codex plugin named iaa |
| ZCode plugin | **CLEAR** | `zai-org/zcode-plugins` `marketplace.json` (30,364 B fetched): zero `iaa` matches; `plugins/` (27): no `iaa` |
| npm registry | **EXACT COLLISION (new fact)** | package `iaa` exists: `iaa@1.0.3` (only version), MIT, 6.5 kB, dormant (~76 downloads/yr, last publish >1 year ago), "Find unused npm names" utility by a third party |
| Software trademark/brand | near-collision only | IAA, Inc. (Insurance Auto Auctions / RB Global), Intel IAA accelerator, IAA Transportation fair, inter-annotator-agreement acronym; **no developer-tool product named `iaa`** found |

## Interpretation (controller judgment, evidence-based)

1. **All four TARGETED publication channels are clear.** İAA does not
   distribute via npm (packages are GitHub-sourced plugin/skill trees for
   Claude/Codex/ZCode), so the npm collision does not block or dilute any
   planned submission. No rename, no runtime-specific slug divergence
   needed — `iaa` remains the namespace everywhere it will actually be
   published.
2. The npm fact is recorded so a future npm-distribution idea starts from
   truth: the unscoped name is taken; a scoped `@isakli05/iaa` would be
   required (owner decision, out of scope, not needed for 0.1.0).
3. This re-check contradicts nothing in Gate-2/02: npm was not among the
   registries that doc examined; the newly checked surface is the only
   collision found.
4. Brand crowding (IAA Inc., Intel IAA) is acronym-level only; the full
   display name `İAA — İştirak-i A‘mâl-i Ajanîye` and the
   delegation-policy domain separate the project in practice. No action.

## Final submission-time recommendation

Publish as `iaa` on all four channels as planned. Re-run this check
once more immediately before each actual submission (marketplace content
changes daily); any exact collision found then would be handled by the
runtime-specific slug rule already established in Gate-2/02 (product name
unchanged; per-runtime package slug may differ if a registry forces it).
