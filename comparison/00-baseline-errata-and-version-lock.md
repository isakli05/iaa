# Comparison 00 — Baseline Errata and Version Lock

Date: 2026-09-22 (second-stage comparison phase). Controller: main session (no orchestration
framework invoked as controller). This document locks the exact versions every later
comparison document is judged against, and records corrections to the baseline audit where
current evidence contradicts it. Historical audit evidence is never rewritten — corrections
are recorded here as errata only.

## 1. Version lock table (authoritative for all comparison documents)

| System | Local (this machine, verified 2026-09-22) | Upstream current (verified from primary source 2026-09-22) | Evidence quality |
|---|---|---|---|
| İAA | v3, canonical `~/.local/share/iaa/`, SKILL.md sha256 `fee98091…87329532b` (re-verified this session; repo copy byte-identical) | n/a (frozen since 2026-08-27) | PROVEN (hash) |
| Claude Code | **2.1.274** (`claude --version`, this session) | see §4 | PROVEN (local); upstream per §4 |
| Codex CLI | **0.154.0** (`codex --version`, this session) | see §4 | PROVEN (local); upstream per §4 |
| ZCode | **3.11.2** (see §2 — NOT 3.7.7) | see §4 | PROVEN (app's own auto-update log); upstream per §4 |
| Superpowers | **6.3.0** (installed_plugins.json: version 6.3.0, commit 44c9b2d6, lastUpdated 2026-08-16) | see §4 | PROVEN (local); upstream per §4 |
| GSD Core | **NOT INSTALLED** (re-confirmed: no gsd markers; audit/04) | see §4 | PROVEN (absence) |
| BMAD | **NOT INSTALLED** | see §4 | PROVEN (absence; audit/04) |
| Codex native agents | `[agents] enabled`, `max_concurrent_threads_per_session=4`, `max_depth=1` (V1 fallback), `~/.codex/agents/reviewer.toml` present (re-verified this session) | n/a | PROVEN (config read) |
| ZCode cached Superpowers | **6.2.0** under `~/.zcode/cli/plugins/cache/claude-plugins-official/superpowers/` (re-verified this session) + a `zcode-plugins-official` marketplace cache dir | n/a | PROVEN (directory listing) |

## 2. ERRATUM E-1 — local ZCode version is 3.11.2, not 3.7.7

**Baseline statement corrected:** the final baseline report / web-project-sources/06
("Installed against … ZCode 3.7.7 … ZCode local install is notably old") and
docs/COMPATIBILITY-MATRIX.md machine-context line ("ZCode 3.7.7") report the local ZCode
installation as 3.7.7.

**What the audit actually established (audit/00):** the ZCode CLI version probe hung and was
killed; **no static version was recorded** at audit time. The 3.7.7 figure originates from
install-time evidence (2026-08-26, CANONICAL-README's "Installed versions" table) and was
carried forward as if still current.

**Current evidence (2026-09-22 22:21, this session):**

- `zcode --version` launches the Electron desktop app (this itself is documented in the
  canonical README: "zcode --version is not a diagnostic—it launches the app"). The probe was
  terminated by timeout after the app's startup log streamed.
- The app's own startup log, captured verbatim:
  - `[main] [arms] electron initialized env=prod version=3.11.2`
  - `[main] [auto-update] initializing, current version: 3.11.2`
- `~/Applications/ZCode.AppImage` file mtime **2026-09-06 00:50** — the currently installed
  AppImage was placed on Sep 6, consistent with an auto-update from 3.7.7 (install era,
  Aug 26; download page advertised 3.9.2 on that date per CANONICAL-README) to 3.11.2.

**Verdict:** local ZCode = **3.11.2** (PROVEN by the application's own version report).
The baseline's "local ZCode 3.7.7" is install-time data presented as current — recorded here
as **Erratum E-1**. Consequences:

1. The claim "ZCode local install is notably old" (vs current 3.14.x) remains directionally
   true but the gap is 3.11.2→current, not 3.7.7→current.
2. İAA's ZCode adapter text was written against 3.7.7 behavior (AGENTS.md injection for
   ordinary subagents since 3.7.1; Explore never injects; no subagent nesting). The local
   runtime is now 3.11.2 and current is 3.14.x — adapter statements about the *installed*
   runtime's behavior are evidence-anchored to a version two-plus minors behind the local
   install. No adapter invalidation is established by this erratum alone (rules verified
   against official docs on 2026-09-22 per web-project-sources/06), but any ZCode behavioral
   claim in comparison documents must be labeled with this skew.
3. No historical audit evidence is modified by this erratum; audit/00's own "version not
   statically recorded" note was accurate — the error is only in the downstream final report.

## 3. Superpowers baseline question (B)

Local = **6.3.0** (re-verified from `installed_plugins.json` this session: version 6.3.0,
commit `44c9b2d6e889982ac18c27d05a19fefe335194e1`, installed 2026-08-01, lastUpdated
2026-08-16). Baseline pack's own note ("6.3.0 locally; 6.4.1 upstream") — the upstream figure
is re-verified in §4 and the post-6.3.0 delta analysis is in
`01-claim-evidence-matrix.md` §SDD and `FINAL-COMPARISON-REPORT.md` §7.

## 4. Upstream current-version verification (filled as research streams complete)

| System | Upstream current (2026-09-22) | Source & evidence type |
|---|---|---|
| Superpowers | **v6.4.1** (RELEASE-NOTES header 2026-09-18; GitHub releases page displays 19 Sep; commit `5bf4e78`; plugin.json on main = 6.4.1). **No release after 6.4.1 exists** (10 releases listed; v6.4.0 never shipped — 6.4.1 is the only release after local 6.3.0 of 2026-08-12). | github.com/obra/superpowers/releases + RELEASE-NOTES.md + plugin.json [RELEASE-NOTED + IMPLEMENTED] |
| GSD Core | **@opengsd/gsd-core 1.14.0** (published 2026-09-14; ~weekly-to-fortnightly cadence: 8 releases since Jul 22). Original gsd-build/get-shit-done archived 2026-06-26 (banner verbatim), last push 2026-05-31. | registry.npmjs.org time map + GitHub API + CHANGELOG [REGISTRY + RELEASE-NOTED] |
| Claude Code | **2.1.280 (Sep 22, 2026)** — six releases after local 2.1.274 (Sep 17): 2.1.275/276/277/278, 2.1.280 (no 2.1.279 listed). | code.claude.com/docs/en/changelog [DOCUMENTED] |
| Codex CLI | **0.155.1 (2026-09-18)** — still latest stable today (0.156 stalled at alpha.17; 0.157 alphas flowing; no stable). Local 0.154.0 = two stable releases behind. | api.github.com/repos/openai/codex/releases/latest + npm dist-tags + learn.chatgpt.com/codex/changelog [IMPLEMENTED] |
| ZCode | **3.14.3 (Sep 22, 2026)** — changelog heading + install page "Latest" + download URLs. Public changelog starts at 3.10.1 (Aug 28); no 3.13.x/3.14.2 entries exist. OSS repo zai-org/zcode (Apache-2.0) at 3.14.0. | zcode.z.ai/en/changelog + /en/docs/install + github.com/zai-org/zcode package.json [DOCUMENTED + IMPLEMENTED] |
| BMAD | **v6.12.0 (2026-09-04)** (npm bmad-method@6.12.0; dist-tags next 6.12.1-next.0, rollback 4.39.0). v7 in public preview. Repo now bmad-code-org/BMAD-METHOD. | GitHub releases atom + CHANGELOG + registry.npmjs.org/bmad-method [RELEASE-NOTED + REGISTRY] |

### 4B. Superpowers post-6.3.0 delta — does anything after 6.3.0 affect prior İAA-vs-SDD conclusions?

Verified against the v6.4.1 tag/main files and release notes (evidence above; local
comparisons anchored to the installed 6.3.0 files, re-verified this session):

1. **SDD core contract unchanged** — all load-bearing elements verbatim-identical between
   6.3.0 (local) and 6.4.1 (main): fresh implementer per task (+ small same-shape batch
   exception), "Never dispatch multiple implementation subagents in parallel (conflicts)."
   (6.3.0 SKILL.md:282 = main), "Never skip the task review", 5-round fix loop, scoped
   re-review, final whole-branch review on most capable model, `.superpowers/sdd/<plan>/`
   ledger workspace. → **No prior İAA-vs-SDD topology conclusion is invalidated.**
2. **`writing-plans` REQUIRED SUB-SKILL header unchanged verbatim** → İAA's artifact-trust
   fixture (tests/fixtures/generated-PLAN.md) and ADR-0003 remain valid against 6.4.1.
3. **`executing-plans` changed materially.** In 6.3.0 it is a ~64-line stub whose only
   substantive routing content is "If subagents are available, use
   superpowers:subagent-driven-development instead of this skill." In 6.4.1 it is a full
   **"Native (inline) execution"** mode (#2318): self-execution, no per-task seats, one
   mandatory final fresh-context review, shared SDD workspace/ledger ("a plan can change
   executors mid-flight"), and only a *conditional preference* for SDD ("Prefer
   superpowers:subagent-driven-development when your human partner wants a review gate on
   every task…"). **Effect on İAA:** the boundary rule still holds (no redirect exists to
   follow; the preference language is weaker than the old redirect), but İAA's adapter
   sentence "executing-plans … its redirect to SDD selects native mode and is not followed"
   now references a mechanism that **no longer exists upstream** — a documentation-drift
   finding (SKILL.md/PA wording anchored to 6.3.0), not a boundary failure. Logged for
   gap analysis; no change made in this phase.
4. **`diagnosing-superpowers` added** — read-only session post-mortem skill ("Every finding
   cites path:line. No citation, no finding."; explicitly forbids diagnosing superpowers
   itself). Not an orchestration authority; no trigger conflict with İAA expected.
   Relevant as a design precedent for İAA's proposed `iaa doctor` (evidence-first
   diagnostics).
5. **SDD gains an opt-in nested-controller subagent mode** (#2320: mid-tier model, ~half
   cost) — RELEASE-NOTED but its documentation location in the current SKILL.md is
   UNVERIFIED. If real, Superpowers now ships a nested-topology option before İAA ever
   exercises its own (İAA's authorized-nesting path remains DOCUMENTED-only). Flagged for
   the claim matrix (H-nesting) and experiment plan.
6. **Plan handoff now asks the user to choose Subagent-driven vs Native with cost guidance,
   and users review the saved plan before execution** (#2258, #2318) — upstream movement
   toward explicit user selection between execution modes (at workflow level), which is
   directionally aligned with İAA's explicit-selection doctrine; does not change in-mode
   fixed cadence.
7. **Bootstrap unchanged:** SessionStart hook (matcher `startup|clear|compact`, async:false)
   still injects the full `using-superpowers` text; the concession "User instructions
   (CLAUDE.md, AGENTS.md …) take precedence over skills" is verbatim-present at 6.4.1 →
   the doctrinal basis of İAA's instruction-channel routing is intact.
8. **Per-skill disable:** still not documented upstream (plugin-level enable/disable only;
   no skillOverrides mention found in README/files read — medium-confidence absence). →
   İAA's whitelist approach remains the only granularity available to a policy that must
   coexist with Superpowers at skill level.
9. **Eval infrastructure exists upstream** (in-repo `tests/` incl. transcript analyzers;
   behavioral eval lab in separate repo prime-radiant-inc/superpowers-evals — "Quorum"
   harness driving real CLI sessions with LLM actor+verifier). Relevant to İAA's
   regression strategy (experiment plan).

## 5. Other baseline corrections found during comparison

### ERRATUM E-2 — `fork_turns` "suffix" semantics are asserted but never evidenced; upstream today documents no such value

**Baseline statements corrected:** ADR-0000 ("fork_turns isolation semantics (none/all/suffix)")
and, downstream of it, İAA's platform adapter text ("inherit only the smallest useful
recent-turn suffix with a positive `fork_turns` value") and docs/CURRENT-ARCHITECTURE.md §8
("minimal inherited suffix only if needed").

**What the raw evidence actually shows:** the original diagnostics file
(`~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md`, 78 lines, re-read this
session) live-tested only `fork_turns=none` and `fork_turns=all` (spawn log lines 38–40;
isolation section lines 64–66). The string "suffix" (and any numeric-value semantics)
appears **nowhere** in the raw diagnostics. The "suffix" element of ADR-0000's triplet is an
unwarranted generalization over its own cited evidence.

**Current upstream state (Codex stream, 2026-09-22):** `fork_turns: "suffix"` is "found
nowhere (docs, issues, or SDK) — treat as nonexistent" [DOCUMENTED-absent + ISSUE-ONLY].
Only `none`/`all` are issue-observed for the CLI; a "partial fork" mode is referenced in
issue #32031; omitted fork_turns defaults to full history. The Responses-API multi-agent
beta documents only `"all"` in examples.

**Verdict:** İAA's adapter recommendation of "the smallest useful recent-turn suffix with a
positive fork_turns value" describes a mechanism that is unevidenced locally and
undocumented upstream — at minimum stale, possibly fictitious. This does not affect İAA's
core boundary semantics (fresh-context-first remains correct and documented), but the
adapter line is factually unsafe advice on current Codex. Recorded as **Erratum E-2**;
logged in 06-gap-analysis.md as an adapter-accuracy defect; no change made in this phase.

### ERRATUM E-3 — web-pack 06's "Current at audit" line mixes local and upstream figures

web-project-sources/06 "Current at audit: Claude 2.1.274, Codex 0.155.1, ZCode 3.14.3"
reads as upstream-current for all three, but 2.1.274 was the **locally installed** Claude
version (audit/00 `claude --version`); upstream Claude Code was already at 2.1.278 (Sep 19)
before the audit date and is 2.1.280 (Sep 22) today. Codex 0.155.1 and ZCode 3.14.3 were
genuinely upstream-current. Minor labeling error only; the version-lock table above is
authoritative now.

### Note N-1 — "ZCode embeds a Codex-derived engine" remains an unverified local observation

audit/00 flagged `~/.zcode/cli` as "Codex-derived engine?" — a question mark, not a claim.
The ZCode stream found the OSS repo (zai-org/zcode) officially attributes copied components
(shadcn/ui, Vercel ai-elements, VS Code IPC portions, Superpowers skill descriptions, etc.)
and declares **no** openai/codex and no anthropics/claude-code code copying. The local
layout similarity stays an observation; official sources neither confirm nor (for the
closed desktop app) fully refute it. Reclassified to UNKNOWN; harmless to all İAA
conclusions (İAA's ZCode integration uses documented public surfaces only).

### Note N-2 — upstream ZCode facts that were UNVERIFIED in the baseline are now confirmed

research/01 flagged two items UNVERIFIED: (a) skillOverrides applicability to plugin skills
— now officially DOCUMENTED for Claude Code ("Plugin skills are not affected by
skillOverrides. Manage those through /plugin instead."); (b) ZCode `.claude-plugin/
plugin.json` compatibility — now DOCUMENTED in ZCode's plugin docs with explicit priority
order (`.zcode-plugin/plugin.json` recommended → `.claude-plugin/plugin.json` accepted) and
an officially preloaded Claude Code marketplace. Both strengthen the packaging analysis in
04-public-packaging-implications.md.
