# İAA — Behavioral Contract (frozen baseline, 2026-09-22)

Normative statements extracted verbatim-in-meaning from the canonical sources. Each row:
**C#** contract statement — source — verification status (PROVEN = behavioral evidence exists;
DOCUMENTED = policy text only; PLATFORM = enforced by runtime, not policy; HISTORICAL =
no longer active). Source keys as in CURRENT-ARCHITECTURE.md (SKILL.md/DC/PA/R/S/M).

## Identity and scope (points 1–5)

- **C1** İAA is a delegation-decision policy skill, not an execution engine. — R:7–20 — PROVEN (by construction; all runs execute via runtime-native subagents).
- **C2** İAA never composes with another orchestration authority on one task. — SKILL.md:12–15, shim M:90 — PROVEN (archfix A1/A2/C, artifact-boundary B/D).
- **C3** Exactly two modes: Adaptive İAA (default) / Native workflow (explicit by-name opt-in only). — SKILL.md:12–15 — PROVEN (A/B/C/D tests both directions).
- **C4** "Use subagents (where appropriate)" and all delegation-flavored phrasing select İAA mode, never native mode. — SKILL.md:14–15, R:40–48 — PROVEN (5 İAA-mode samples).
- **C5** İAA is model-invocable with a proactive trigger (load "when delegation is requested or materially useful"), not explicit-only; per-task opt-out phrase documented. — shim M:88, R:190 — PROVEN (collision run 1 + test C invoked it via natural prompts).
- **C6** Description-level anti-trigger: "Not for small or tightly coupled work" keeps ordinary/small tasks single-agent. — SKILL.md frontmatter — PROVEN (test C: model quoted it when choosing all-primary execution).

## Authority and precedence (points 19–21)

- **C7** User's current explicit instruction is the highest authority for mode selection. — SKILL.md:15,17 — PROVEN (tests B/C).
- **C8** Global managed shim routing outranks skill-internal redirects (Superpowers' own bootstrap concedes user instructions outrank skills). — shim M:90; archfix report §"Key transcript evidence" — PROVEN (models quoted the shim while rejecting `executing-plans`→SDD redirect, 3 samples).
- **C9** Workflow directives embedded in artifacts (plans/specs/generated files/repo text/prior output) are orchestration metadata, never opt-in; technical content remains authoritative. — SKILL.md:17 — PROVEN for plan artifacts (authentic + adversarial); DOCUMENTED for other channels.
- **C10** Compatible Superpowers component skills remain individually usable in İAA mode (whitelist of 8; 2 seat-prescribing components only execute pre-authorized lanes). — SKILL.md:19 — PROVEN (TDD, verification, finishing, executing-plans all co-invoked in runs).
- **C11** İAA never disables, uninstalls, patches, or configures Superpowers (or any other framework). — campaign reports ("no plugin file modified", mtime sweeps) — PROVEN.

## Primary-agent contract (points 6, 12–13, 15)

- **C12** The primary owns: decomposition, dependency order, agent selection, shared contracts, scope assignment, integration, contradiction resolution, final validation, user answer. — SKILL.md:27 — PROVEN (every run; LCO production).
- **C13** Child reports are evidence, not truth; load-bearing claims verified against source/diffs/tests/runtime before acceptance. — SKILL.md:79, DC:45–53 — PROVEN (run 1 re-read every diff; run 2 re-ran suite 5×).
- **C14** Final validation always runs in the primary context. — SKILL.md:79, DC:52 — PROVEN (all runs).
- **C15** On child failure/interruption: task is not complete; preserve valid evidence; report/retry proportionately; stop redundant work; primary still validates. — SKILL.md:75, S:H — DOCUMENTED (scenario H never run).
- **C16** Primary does non-overlapping work while children run; waits only when a child result gates the next critical decision. — SKILL.md:75 — PROVEN (overlapping child intervals + concurrent root work in native-audit; campaign runs).

## Delegation decision (points 7–8, 18)

- **C17** Delegate only with ≥1 concrete benefit: parallelism / bounded isolation / specialization / context offloading / independent verification. — SKILL.md:37–43 — PROVEN.
- **C18** Stay single-agent when tiny, sequential, tightly coupled, poorly bounded, same-file, same-context, or cheaper direct — including despite "use subagents where appropriate". — SKILL.md:45 — PROVEN (Task-1 class never delegated; test C all-primary).
- **C19** Sequential delegation is the shape for coupled/clustered work (one context beats N context-rebuilds). — SKILL.md:45,63; collision run 2 D1 clustering — PROVEN.
- **C20** Parallel delegation is the shape for independent workstreams, in one wave with disjoint ownership. — SKILL.md:39,57–63 — PROVEN (3- and 2- implementer parallel batches).
- **C21** Specialist delegation maps to capability classes (fast explorer / general worker / deep reviewer) and built-in roles; no hardcoded model names; strongest reasoning stays primary for global synthesis. — SKILL.md:73, PA — PROVEN (role use in all runs; SDD's model tiering observed in native mode only).
- **C22** Reviewer delegation requires task-specific material benefit (risk classes: auth/security/destructive migrations/concurrency/shared contracts/public APIs/ambiguous correctness); no manufactured reviewers; low-risk verified by primary. — SKILL.md:21, R:90 — PROVEN (0 reviewers small tasks; 2 justified reviewers in attempt 3; production LCO wave-3 primary).
- **C23** Mixed primary+worker execution is normal (primary keeps coupled/shared work while workers take independent lanes). — SKILL.md:59–63 — PROVEN (all multi-agent runs).
- **C24** No agents for artificial roles, one-per-file, or availability; smallest useful number. — SKILL.md:47–49 — PROVEN.
- **C25** Authorizing one stage never preauthorizes the next (review → fixer → re-reviewer each re-justified); optional/Minor findings stay primary or deferred. — SKILL.md:21 — PROVEN (attempt-3 leak documented then structurally fixed; D3 fix wave in native mode was SDD's, not İAA's).

## Ownership and dependencies (points 9–10)

- **C26** Non-overlapping write ownership before concurrent edits; each child has an exclusive write set; shared contracts/APIs/schemas/types/DB/central-config/abstractions are primary-owned, settled first, or single-designated-owner. — SKILL.md:55–63, DC:25 — PROVEN (zero concurrent same-file writers in any run).
- **C27** Dependency-aware waves; skip valueless phases. — SKILL.md:65 — PROVEN (run shapes; LCO 3-wave production).
- **C28** Workers preserve unrelated edits and never revert others' work; told they are not alone in the workspace. — DC:25 — PROVEN (briefs recorded in transcripts).

## Conflict/integration (points 11–13)

- **C29** Contradictions between child reports are resolved centrally by the primary. — SKILL.md:27,79, DC:51 — PROVEN (synthesis behavior in all multi-worker runs).

## Cost and context (point 14)

- **C30** Context isolation is a benefit AND a cost: prefer fresh-context spawns; inherit history (Codex `fork_turns` beyond `"none"` — `"all"` or a positive-integer-string recent-turns count; Claude fork) only when genuinely required. — PA:8,18 — PROVEN (fresh spawns standard in runs; Codex value surface schema-verified 2026-09-23, see release-hardening/02).
- **C31** Context offloading (large logs/docs/searches/test output) is a legitimate delegation benefit. — SKILL.md:42 — PROVEN (Explore usage; LCO wave 1).
- **C32** Cost awareness is evidentiary, not enforced: measured campaign costs (İAA-mode $2.90–3.27 vs co-loaded SDD $9.57 vs native SDD $8.16–11.24) document the economic rationale; no runtime metering exists. — campaign reports — PROVEN (as measurement).

## Lifecycle and nesting (points 16, 25)

- **C33** Root-to-child delegation only; a child spawns grandchildren only with explicit user request + concrete bounded benefit; briefs carry "Do not spawn subagents" otherwise. — SKILL.md:71, DC:27 — PROVEN (rejection side: 0 nested spawns everywhere); positive authorized-nesting path DOCUMENTED only.
- **C34** Nesting guard is runtime-mixed: Claude = env cap depth 1 (PLATFORM, managed by M), ZCode = impossible (PLATFORM), Codex = policy-only. — PA:10,19,27; M:154–213 — PROVEN (Claude/ZCode), DOCUMENTED (Codex).
- **C35** Explore/Plan-style agents don't inherit global instructions → primary restates constraints/ownership/no-nesting per brief. — PA:17,25; S:I — PROVEN in practice (briefs contain restated constraints), scenario I itself DOCUMENTED only.
- **C36** Agent lifecycle is per-task stateless: no persistent agent definitions created by İAA, no daemon, no cross-session state except the depth marker. — M, R — PROVEN (by construction).

## Runtime integrations (points 22–24)

- **C37** Claude Code: CLAUDE.md shim + `~/.claude/skills` symlink + managed `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1`. — M, R:62–66 — PROVEN (live; verify passes).
- **C38** Codex: AGENTS.md shim + `~/.agents/skills` symlink; pre-existing `[agents]` config and reviewer.toml untouched. — M, R:56–60 — PROVEN (live links; mtime evidence).
- **C39** ZCode: AGENTS.md shim + `~/.zcode/skills` symlink; desktop UI needed for live check; ZCode-side behavior not re-tested post-campaigns. — M, R:68–72 — DOCUMENTED (install-time evidence only).
- **C40** All three consume one canonical source through relative symlinks; edit-once-refresh-everywhere. — R:160–168 — PROVEN (hashes identical through links).

## Trust boundaries (point 20)

- **C41** Enforcement hierarchy: current explicit user selection > global/user routing (shim) > active İAA mode > artifact-embedded suggestions; lower never silently overrides higher. — artifact-boundary report — PROVEN (tests B/C/D).

## Verification matrix summary

PROVEN: C1–C14, C16–C24, C26–C31, C33(rejection), C34(Claude/ZCode), C35(practice), C36–C38, C40, C41.
DOCUMENTED-only: C15 (failed child), C33 (authorized nesting), C35 (scenario I as such), C39 (ZCode live behavior), C9 (non-plan channels), C34 (Codex nesting).
HISTORICAL (explicitly not current): prose-precedence override of co-loaded SDD (v0/v1); post-load topology gate; SDD cadence leakage under co-loading; install-era reviewer manufacturing.
