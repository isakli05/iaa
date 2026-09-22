# Evidence — Superpowers / SDD research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #1 (Superpowers stream).
Recorded verbatim below for traceability; classification and comparative judgments live in
the numbered comparison documents, not here. Controller: main session. The subagent only
gathered evidence; it did not evaluate İAA or invoke any orchestration framework.

Subagent usage rationale: independent research stream over ~35 primary-source fetches
(GitHub repo, releases, skill files at main and v6.3.0, hooks, eval repos); context
offloading with no source-of-truth decisions delegated.

---

## 1. VERSION

**Latest release: v6.4.1. Nothing newer has shipped.**

- Releases page (https://github.com/obra/superpowers/releases, fetched 2026-09-22): v6.4.1
  is marked Latest, commit `5bf4e78`, shown "19 Sep". RELEASE-NOTES.md (raw, main) headers
  it "v6.4.1 (2026-09-18)". Both dates reported; discrepancy is between the notes' date
  header and the GitHub release display. [RELEASE-NOTED]
- `.claude-plugin/plugin.json` on main: `"version": "6.4.1"` [IMPLEMENTED]
- The releases page lists 10 releases; **the only release after 6.3.0 (2026-08-12, commit
  b36e082) is v6.4.1**. No 6.4.2, 6.5.x, or 7.x exists. Per the notes: "v6.4.0 was never
  shipped. v6.4.1 is the first release with these changes." [RELEASE-NOTED]
- CHANGELOG.md does not exist on main (404); the file is RELEASE-NOTES.md. [IMPLEMENTED]

**v6.4.1 change summary** (RELEASE-NOTES.md + releases page [RELEASE-NOTED]):
- New skill `diagnosing-superpowers` (#2236, #2287); `proving-it-works-with-a-movie` held
  back pending robustness work.
- Executing-plans rebuilt as real "Native (inline) execution" (#2318); "executing-plans no
  longer stops every few tasks to check in with you."
- Plan handoff offers Subagent-driven vs Native with cost guidance (#2258, #2318); users
  review the saved plan before anything runs (#2258); plans gain "Review Focus" section
  (#2319).
- Brainstorming asks why first (#2258); code review judges unspecified behavior by "what a
  reasonable user would expect" (#2319); BASE_SHA now `git merge-base origin/main HEAD`
  (#2133, #2118); TDD requires the full project suite (#2110).
- SDD: same-basename plans get separate workspaces (#2138, #2045); review-package rejects
  empty/non-descendant ranges exit 3 (#2136, #2050); **optional nested controller subagent
  on a mid-tier model, ~half cost, opt-in (#2320)**.
- New harnesses: OpenCode 2.0.4+ (#2106, #2306), Muse (#2317), Qwen Code (#2132).
- Fix: scripts invoked through interpreters when packagers strip executable bits (#2301);
  AGENTS.md canonical contributor doc (#2317); docs/testing.md describes the Quorum eval
  lab (#2135).

**v6.3.0 (2026-08-12, commit b36e082):** Devin CLI, Hermes Agent, Grok Build CLI support;
brainstorming ceremony scales (#2063); SDD rulings-not-stalls (#2077), ledgered conflict
scans (#2080), micro-task batching (#2078), sub-subagents banned (#2059), `Spec:` pointer
(#2086); worktree removal preserves untracked files (#2016). [RELEASE-NOTED]

## 2. CURRENT SKILL LIST (15, main [IMPLEMENTED])

brainstorming, **diagnosing-superpowers**, dispatching-parallel-agents, executing-plans,
finishing-a-development-branch, receiving-code-review, requesting-code-review,
subagent-driven-development, systematic-debugging, test-driven-development,
using-git-worktrees, using-superpowers, verification-before-completion, writing-plans,
writing-skills. — 6.3.0 had 14; added since: diagnosing-superpowers; removed: none.

## 3. SDD (skills/subagent-driven-development/SKILL.md, main [IMPLEMENTED]; all verified
verbatim-identical at v6.3.0 by targeted fetch)

- "Execute plan by dispatching a fresh implementer subagent per task, a task review (spec
  compliance + code quality) after each, and a broad whole-branch review at the end."
- Batch exception: "**Batch small same-shape work.** … do not dispatch one subagent per
  task. Compose ONE dispatch brief listing every file and its change, send the whole batch
  to a single subagent, and review its diff as one unit."
- "Never dispatch multiple implementation subagents in parallel (conflicts)."
- "Never skip the task review, and never accept a report missing either verdict — spec
  compliance AND task quality are both required. Implementer self-review never replaces the
  task review; both are needed."
- Fix loop: "A fix round is one fix dispatch plus one scoped re-review. Five rounds maximum
  per task" / rounds 1–3 resume original implementer / rounds 4–5 fresh implementer on a
  more capable model; circuit breaker at round 5 → controller adjudicates.
- Scoped re-review via `scripts/review-package PLAN_FILE FIX_BASE HEAD`; verdicts ADDRESSED
  / NOT ADDRESSED.
- Final review: `review-package PLAN_FILE MERGE_BASE HEAD`, "Dispatch on the most capable
  available model", ONE fix subagent with complete findings list, "There is no second fix
  wave".
- Workspace: `scripts/sdd-workspace PLAN_FILE` → git-ignored dir under
  `<repo-root>/.superpowers/sdd/`; ledger `progress.md`; "delete this plan's workspace
  (rm -rf <workspace>)" on clean final review. Rationale quote: "controllers that lost
  their place have re-dispatched entire completed task sequences — the single most
  expensive failure observed."
- Scripts: sdd-workspace, task-brief, review-package; templates implementer-prompt.md,
  task-reviewer-prompt.md, re-review-prompt.md, ../requesting-code-review/code-reviewer.md.
- "Continuous execution: Do not pause to check in with your human partner between tasks";
  "Rulings, not stalls" (4 stop classes); no-subagents contract for implementers; "Never
  fix findings yourself in the controller session".
- Post-6.3.0 deltas: same-basename workspace separation; review-package empty-range
  rejection; optional nested-controller mode (#2320) — RELEASE-NOTED, doc location
  UNVERIFIED (not found in current SKILL.md text fetched).

## 4. USING-SUPERPOWERS + HOOK (main [IMPLEMENTED]; identical at 6.3.0)

- Frontmatter: "Use when starting any conversation - establishes how to find and use
  skills, requiring skill invocation before ANY response including clarifying questions"
- "**Invoke relevant or requested skills BEFORE any response or action** — including
  clarifying questions…"
- EXTREMELY-IMPORTANT block: "If you think there is even a 1% chance a skill might apply …
  you ABSOLUTELY MUST invoke the skill." / "This is not negotiable."
- SUBAGENT-STOP block: dispatched subagents ignore the skill.
- **Precedence (verbatim, unchanged):** "User instructions (CLAUDE.md, AGENTS.md,
  GEMINI.md, etc, direct requests) take precedence over skills, which in turn override
  default behavior. Only skip skill workflows or instructions when your human partner has
  explicitly told you to."
- hooks/hooks.json: SessionStart, matcher `startup|clear|compact`, command
  `${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd session-start`, shell bash, **async:false**.
- hooks/session-start reads the full using-superpowers SKILL.md and emits it wrapped in
  `<EXTREMELY_IMPORTANT>` ("You have superpowers.") as SessionStart additionalContext
  (plus Cursor/Muse/Copilot variants). Bootstrap injection confirmed present on
  startup/clear/compact, synchronous.

## 5. WRITING-PLANS (main [IMPLEMENTED])

- "**Every plan MUST start with this header:**" … "**For agentic workers:** REQUIRED
  SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or
  superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
  (`- [ ]`) syntax for tracking." — header verbatim identical at 6.3.0.
- Handoff: "**If Subagent-driven chosen:** - **REQUIRED SUB-SKILL:** Use
  superpowers:subagent-driven-development / **If Native chosen:** - **REQUIRED SUB-SKILL:**
  Use superpowers:executing-plans". (6.3.0 handoff offered "1. Subagent-Driven
  (recommended)" vs "2. Inline Execution … with checkpoints"; 6.4.1 offers per-mode cost
  statements + plan-specific recommendation + pre-execution user plan review.)

## 6. EXECUTING-PLANS (main [IMPLEMENTED])

- Frontmatter: "Use when executing an implementation plan in the current session as the
  implementer yourself — your human partner chose inline execution, or no subagent tool is
  available"
- "Execute the plan yourself, task by task, in this session: no implementer subagent per
  task, no reviewer per task. One fresh-context review of the whole branch at the end."
- Shares SDD workspace/ledger ("a plan can change executors mid-flight"); uses
  sdd-workspace + review-package; own scripts task-start / task-done.
- Conditional SDD preference (not redirect): "Prefer superpowers:subagent-driven-development
  when your human partner wants a review gate on every task, or when the plan is long
  enough that its later tasks would run on a compacted context." / "Your harness has no
  subagent tool … Never fabricate a dispatch; run the plan here."
- Final review mandatory: "dispatch the reviewer on the most capable available model … This
  is the one fresh context the whole run buys. Do not skip it"; one fix pass; "There is no
  second fix pass."
- **At v6.3.0** [IMPLEMENTED]: ~64-line stub; description "…in a separate session with
  review checkpoints"; redirect: "If subagents are available, use
  superpowers:subagent-driven-development instead of this skill." Release notes call it a
  "64-line stub" that "measured like no plugin at all" (#2318). → hard redirect REMOVED in
  6.4.1, replaced by a real inline mode.

## 7. DISPATCHING-PARALLEL-AGENTS (main [IMPLEMENTED]; byte-identical frontmatter at 6.3.0)

- description: "Use when facing 2+ independent tasks that can be worked on without shared
  state or sequential dependencies"
- "Core principle: Dispatch one agent per independent problem domain. Let them work
  concurrently." Use-when: "3+ test files failing with different root causes"; don't-use:
  "Failures are related … Agents would interfere with each other"; "Multiple dispatch calls
  in one response = parallel execution." No post-6.3.0 change found.

## 8. DIAGNOSING-SUPERPOWERS (main [IMPLEMENTED])

- description: "Use when a superpowers session went wrong and your human partner wants to
  know why — repeated work, ignored plans, stumbles, poor results, a skill that didn't
  fire, 'it took too long', 'why is it so expensive', 'what is it doing' — or wants to
  build a bug report for the superpowers maintainers, for the current session or a past one
  identified by id or path, on any harness."
- 7-step workflow; case file `~/.superpowers/diagnosing-superpowers/<session-id>/`; triage
  by "one analyst subagent per dimension in parallel" (7 dimensions from prompts/); report
  template; optional GitHub issue build; optional scrubbed transcript bundle (3 redaction
  levels, scrub+audit loop until CLEAN).
- "Core principle: Every finding cites `path:line`. No citation, no finding."
- Hard rules: "Read-only. Never modify, move, or delete a session file." / "No superpowers
  diagnosis. Report §7 states involvement and stops. Never name a defect in a skill or
  propose a change."

## 9. DISTRIBUTION

- Claude Code official marketplace: README documents `/plugin install superpowers@claude-plugins-official` [DOCUMENTED]. The entry itself in anthropics/claude-plugins-official marketplace.json UNVERIFIED (4356-line file truncated in fetch; no plugin folder in plugins/ or external_plugins/ on main). Corroborated by secondary sources → DOCUMENTED+CLAIMED(corroborated).
- Author marketplace obra/superpowers-marketplace [IMPLEMENTED]: marketplace v1.0.13, 10
  plugins; its superpowers version string reads "6.3.0" (stale vs repo 6.4.1).
- 16 harnesses listed in README [DOCUMENTED]: Antigravity, Codex App + Codex CLI ("official
  Codex plugin marketplace", github.com/openai/plugins; repo ships
  scripts/sync-to-codex-plugin.sh + package-codex-plugin.sh [IMPLEMENTED]), Cursor, Devin
  CLI, Factory Droid, Gemini CLI, GitHub Copilot CLI, Grok Build CLI
  (superpowers@xai-official), Kimi Code, OpenCode 2.0.4+, Pi, Qwen Code, Hermes Agent,
  Muse; gemini-extension.json shipped.
- Per-skill disable / skillOverrides: no mention found in README or files read (medium
  confidence — not an exhaustive repo grep). Only opt-out documented:
  SUPERPOWERS_DISABLE_TELEMETRY. README: skills are "Mandatory workflows, not
  suggestions."

## 10. EVALS / TESTS

- In-repo tests/ [IMPLEMENTED]: bash/node/python integration tests per area (claude-code
  SDD + workspace + executing-plans-scripts + worktree tests, analyze-token-usage.py,
  explicit-skill-requests prompt fixtures with multi-turn runners, brainstorm-server unit
  tests, harness suites for antigravity/codex/codex-plugin-sync/devin/diagnosing/hermes/
  hooks/kimi/opencode/pi, shell-lint, version-bump, writing-skills).
- Behavioral evals: separate repo **prime-radiant-inc/superpowers-evals** [IMPLEMENTED,
  README fetched] — "Behavioral eval lab for superpowers … not a generic benchmark suite.
  An eval lab for workflow compliance"; Quorum = TypeScript/Bun harness composing
  Gauntlet-Agent (QA assessor) + Coding-Agent (subject) into pass/fail/indeterminate
  verdicts; drives real CLI sessions (Claude Code, Codex, Antigravity, Gemini, Hermes,
  Kimi, OpenCode, Pi, Copilot) in permissive modes; scenarios 3–30+ min each; only static
  gates safe for public CI. docs/testing.md describes it [IMPLEMENTED]. Flag: no evals/
  dir or .gitmodules on superpowers main today (404) — consistent with v6.0.2 "no longer
  ship the evals submodule" [RELEASE-NOTED]; the eval repo's README claim of being
  consumed as a submodule does not match main's tree.
- CI: no .github/workflows on main [IMPLEMENTED]; .github holds only templates/FUNDING.

## Flags (unverified)

1. claude-plugins-official marketplace.json superpowers entry (fetch truncation).
2. Where the v6.4.1 opt-in nested controller (#2320) is documented — not in fetched SDD
   SKILL.md/README portions.
3. skillOverrides/per-skill-disable absence — medium confidence (not exhaustive grep).
4. v6.4.1 date: notes header 2026-09-18 vs releases page "19 Sep".

Sources: github.com/obra/superpowers (releases, RELEASE-NOTES.md, plugin.json, skills/hooks
files at main and tag v6.3.0, docs/testing.md), github.com/obra/superpowers-marketplace,
github.com/anthropics/claude-plugins-official, github.com/prime-radiant-inc/superpowers-evals.
