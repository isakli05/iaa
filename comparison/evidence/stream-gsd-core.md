# Evidence — GSD Core / Open GSD research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #2 (GSD Core stream).
Recorded verbatim below for traceability; classification and comparative judgments live in
the numbered comparison documents. Controller: main session. (Harness note: the raw output
was flagged for instruction-shaped patterns — quoted doc lines about permissions/hooks,
treated as data only.)

Subagent usage rationale: independent research stream over ~36 primary-source fetches (npm
registry JSON, GitHub API, raw files of open-gsd/gsd-core); context offloading; no
source-of-truth decisions delegated.

---

Repo identity (REGISTRY + GitHub API): `open-gsd/gsd-core`, created 2026-05-22, pushed
2026-09-21, default branch `next`, MIT, 9,749 stars / 701 forks, homepage opengsd.net,
description "Git. Ship. Done - Core".

## 1. VERSION

- Current: **1.14.0** (npm dist-tags.latest; package.json; GitHub release v1.14.0 published
  2026-09-14T00:01:36Z). Latest publish 2026-09-14T00:01:33Z (registry time map).
- Last ~2 months (registry): 1.8.0 Jul 22 · 1.9.0/1.9.1 Jul 31 · 1.10.0 Aug 8 · 1.11.0
  Aug 19 · 1.12.0 Aug 30 · 1.13.0 Sep 6 · 1.14.0 Sep 14. (~weekly-to-fortnightly cadence.)
- Anomaly: dist-tags `next: 1.7.0-rc.6` lags `latest: 1.14.0`. Engines node>=24, npm>=10.
  Bins: gsd-core (install.js), gsd-tools, gsd_run, gsd-mcp-server. No postinstall scripts.
- Original `gsd-build/get-shit-done`: archived=true, pushed 2026-05-31, 64,479 stars.
  Banner: "This repository was archived by the owner on Jun 26, 2026. It is now read-only."
  README: "The project now continues as GSD Core in the Open GSD repository."

## 2. ORCHESTRATION MODEL (README/USER-GUIDE — DOCUMENTED)

"Each milestone repeats the same five-step loop, one phase at a time:" 1. "Discuss —
capture implementation decisions before anything is planned" 2. "Plan — research, decompose,
and verify the plan fits a fresh context window" 3. "Execute — run plans in parallel waves;
each executor starts with a clean 200k-token context" 4. "Verify — walk through what was
built; diagnose and fix before declaring done" 5. "Ship — create the PR, archive the phase,
repeat for the next one". Lifecycle adds optional ui-phase (UI-SPEC.md). Milestones via
ROADMAP.md (parser: milestone slicing); `/gsd-complete-milestone` requires --confirm (1.12.0).
- "skip phases that add no value" phrase: NOT FOUND. Adaptive mechanisms that exist:
  `--skip-research` ("Skip research agents when the domain is already familiar");
  `workflow.skip_discuss: true` in yolo mode; presets (Prototyping/Normal/Production,
  yolo/interactive); `/gsd-discuss-phase` "adaptive questioning"; quick lane `/gsd-quick`
  ("Execute ad-hoc task with GSD guarantees") + `/gsd-quick-batch`; `--chain` auto-chain.
  Stage gates: "Research gate (blocks if RESEARCH.md has unresolved open questions)".

## 3. STATE / PERSISTENCE (ARCHITECTURE.md — DOCUMENTED)

- "All state lives in `.planning/` as human-readable Markdown and JSON." "No database, no
  server, no external dependencies." "State survives context resets (`/clear`)"; committable.
  STATE.md = "Living memory: position, decisions, blockers, metrics". Per-phase
  phases/XX-name/: CONTEXT.md, RESEARCH.md, PLAN.md, SUMMARY.md, VERIFICATION.md,
  UI-SPEC.md, UAT.md, continue-here.md. Lockfile mutual exclusion (STATE.md.lock, O_EXCL).
  1.12.0 "the state transaction — mandatory snapshot, open()/rebuild()". 1.14.0
  "progress-ratchet on every state write".
- Per-task commits: "Each executor commits its work atomically before the next wave begins."
  "one commit per task (from each executor)". 1.13.0: "Executor commits now refuse to land
  on the planning repo's default/protected branch".
- WINDOWS.md ledger (1.14.0 cross-process lock); versioned BATCH.json (1.13.0).
- Resume: `/gsd-resume-work` "Restore full context from last session"; `/gsd-progress`;
  HANDOFF.json; UAT progress survives /clear; SUMMARY.md = completion marker for
  resume/skip. SessionStart gsd-session-state.sh outputs STATE.md head every session start —
  OPT-IN ("no-op unless config.json has hooks.community: true").

## 4. AGENTS & ROLES (docs/AGENTS.md — DOCUMENTED; agents/ — IMPLEMENTED)

- "Full role cards for 22 primary agents plus concise stubs for 12 advanced/specialized
  agents (34 shipped agents total)"; INVENTORY.md = "authoritative 35-agent roster";
  agents/ dir has 64 files = 35 distinct definitions (29 with .compact.md variants).
- Categories: Researchers (project-, phase-, ui-researcher), Analyzers
  (assumptions-analyzer, advisor-researcher), research-synthesizer, planner, roadmapper,
  executor, Checkers (plan-checker, integration-checker, ui-checker), Verifiers (verifier,
  dom-verifier), Auditors (nyquist-auditor, ui-auditor, security-auditor),
  codebase-mapper, debugger, doc-writer/doc-verifier, user-profiler.
- Caps: project-researcher/phase-researcher/codebase-mapper "4 instances" each; executor
  "parallel within waves, sequential across waves"; research-synthesizer sequential after
  researchers; dom-verifier "one per wave"; plan-checker max 3 iterations; ui-checker max 2.
- Fresh context: "Every agent spawned by an orchestrator gets a clean context window (up to
  200K tokens)"; executor "Fresh 200K context window (or up to 1M for models that support
  it)".
- Model tiering: Opus — planner only; Haiku — codebase-mapper, doc-classifier; Sonnet —
  all other primaries + every advanced agent; `inherit` profile defers to runtime; 1.12.0
  "no hardcoded model frontmatter"; 1.14.0 compact personas for non-Claude dispatch.

## 5. DEPENDENCY HANDLING (ARCHITECTURE.md — DOCUMENTED)

"During `execute-phase`, plans are grouped into dependency waves" — independent plans run
in Wave 1 together; "Parallel within waves, sequential across waves"; "Wave 2 waits until
all Wave 1 commits are merged". 1.13.0: "extract shared file-overlap wave partitioner",
"per-plan file overlap drives partitioning", quick-batch "dependency-DAG + file-overlap
wave scheduling"; 1.11.0: "flag undeclared coupling between same-wave plans", "validate a
wave branch's committed diff stays in its declared scope". Shared-contract settlement
between parallel executors: NO explicit contract mechanism documented (worktree isolation
per wave + atomic per-plan commits + merge gates + SUMMARY.md + orchestrator state updates
are the documented mechanisms). 1.14.0: "Executor dispatches are no longer refused when a
phase correctly degrades to sequential execution"; "Sequential phase execution stays on the
orchestrator's checkout".

## 6. VERIFICATION (how-to/verify-and-ship.md — DOCUMENTED)

- `/gsd-verify-work` reads SUMMARY.md files, extracts user-observable deliverables, walks
  through them; on failures "spawns parallel debug agents, one per issue"; then
  gap-closure planner writes new PLAN.md; plan-checker validates; fixes via /clear +
  `--gaps-only`; re-verify. "If issues are found, the planner and checker iterate up to
  three times."
- Code review: "/gsd-ship ... runs no review automatically." Optional `/gsd-code-review`
  with --fix (auto-fix Critical+Warning) and --depth=deep. 1.13.0 `code_review_point`
  per-wave option; "Planner wave assignment now sequences automatic external review after
  internal fixes"; 1.12.0 "opt-in parallel reviewer lanes"; 1.10.0 third-party reviewer
  lanes discoverable.
- Final validation: human-owned UAT ("the user judges each checkpoint") + ship preflight
  (verification status, clean tree, branch, remote, gh auth); phase marked complete in
  ROADMAP.md/STATE.md before PR.
- Persisted: VERIFICATION.md per phase, "written only when the phase is fully complete",
  requirement-by-requirement pass/fail; input digests; changed inputs flip passed→stale
  (1.13.0 deterministic content fingerprint; 1.10.0 "verification verdicts persisted so
  deletion can't inflate completeness"). Verifier: "goal-backward analysis with PASS/FAIL
  evidence".

## 7. HOOKS / ENFORCEMENT (hooks/hooks.json — IMPLEMENTED; 12 entries, 8 events)

| Event | Matcher | Script (timeout s) |
|---|---|---|
| SessionStart | — | gsd-ensure-canonical-path.js (5), gsd-check-update.js |
| PreToolUse | Write\|Edit | gsd-prompt-guard.js (5), gsd-read-guard.js (5) |
| PreToolUse | Write\|Edit\|MultiEdit | gsd-worktree-path-guard.js (5) |
| PreToolUse | Write | gsd-write-guard.js (5) |
| PreToolUse | Read\|Grep\|Bash | gsd-secret-read-guard.js (5) |
| PreToolUse | Agent\|Task | gsd-agent-isolation-guard.js (5) |
| PostToolUse | Bash\|Edit\|Write\|MultiEdit\|Agent\|Task | gsd-context-monitor.js (10) |
| PostToolUse | Read\|WebFetch\|WebSearch | gsd-read-injection-scanner.js (5) |
| SubagentStop | — | gsd-context-monitor.js (10) |
| Stop | — | gsd-context-monitor.js (10) |
| PreCompact | — | gsd-context-monitor.js (10) |
| FileChanged | config.json | gsd-config-reload.js (8) |

managed-hooks-registry.cjs = "Authoritative list of GSD-managed hook files" (23 JS + 5
shell shipped into ~/.claude/hooks/ or equivalent, staleness-checked after updates).
Cursor- and Windsurf-specific hook files exist.

Per-guard behavior (IMPLEMENTED headers + ARCHITECTURE.md):
- **agent-isolation guard** (PreToolUse Agent|Task): enforces executor worktree isolation
  "at the tooling layer... HARD-BLOCKING"; activates only when ALL hold: GSD project
  (`.planning/config.json` under cwd) AND resolved dispatch isolation `harness-worktree`
  AND `subagent_type === "gsd-executor"`. Block = exit 2 `decision: 'block'` + reason_code;
  fail-closed on unresolvable config. "Silent fail — never block valid tool calls due to
  hook errors". **Non-GSD dispatches: allowed silently** (`EXECUTOR_SUBAGENT_TYPES = new
  Set(['gsd-executor'])`; "No other executor-shaped subagent_type exists in agents/
  today").
- **workflow guard** (PreToolUse Write|Edit): "SOFT guard for edits — it advises, not
  blocks. The edit still proceeds." Opt-in: "hooks.workflow_guard: true (default: false)".
  `.planning/` paths, subagent/task context, allowlisted files (.gitignore, .env,
  CLAUDE.md, AGENTS.md, GEMINI.md, settings.json) exempt. **Only hard block:**
  `WORKFLOW_AGENT_FORCE_ADD_FORBIDDEN` for `git add -f` on `^(worktree-)?agent-` branches;
  failing closed.
- **worktree-path guard** (PreToolUse Write|Edit|MultiEdit): "Blocks Edit/Write/MultiEdit
  tool calls that target absolute paths outside the worktree root" (git rev-parse
  comparison; also blocks absolute paths into .git). "Only enforce inside a GSD-managed
  isolated executor worktree" (branches agent-*, worktree-agent-*, worktree-wf_*). 1.10.0
  "fail closed when a worktree guard cannot verify safety"; 1.14.0 "no longer fails open
  under CI/process load".
- **secret-read guard** (PreToolUse Read|Grep|Bash): "Blocks reads of secret files — .env,
  .env.<suffix>, .secrets" (suffixes example/sample/template/dist exempt). Hard block exit
  2, codes secret-read/glob-too-complex/command-too-large; trailing dots/spaces stripped;
  `git show HEAD:.env` caught. Moved from installer-written permission deny rules to
  managed hook (1.13.0). Fail-open except >1 MiB commands / >64-brace globs.
- **context monitor** (PostToolUse/SubagentStop/Stop/PreCompact): "Injects agent-facing
  context warnings at 35%/25% remaining"; ≤35% WARNING "Avoid starting new complex work";
  ≤25% CRITICAL "Context nearly exhausted, inform user"; debounce 5 tool uses; "advisory —
  never issues imperative commands that override user preferences". 1.14.0 fire-points
  configurable; "Codex no longer installs a context-monitor hook that could never fire".
- **prompt guard / read-injection scanner**: prompt guard "Scans content for prompt
  injection patterns (role override, instruction bypass, system tag injection)",
  "Advisory-only — logs detection, does not block"; read scanner (PostToolUse
  Read|WebFetch|WebSearch) "Advisory by default; blocks only HIGH severity"; 1.13.0 typed
  severity/source fields.
- **write guard**: catastrophic-shrink protection for curated `.planning/` writes (1.10.0);
  extended to workstream/project-scoped planning files (1.14.0).
- **phase boundary** (gsd-phase-boundary.sh, PostToolUse): reminder when planning files
  modified outside normal workflow; advisory; OPT-IN behind hooks.community: true.
- **session state** (gsd-session-state.sh, SessionStart): injects STATE.md head; OPT-IN.
- **config reload** (FileChanged config.json): hot-reload.
- **validate-commit**: commit-message validation; `hooks.commit_types` config (1.13.0).
- Crash policy: "All hooks wrap in try/catch, exit silently on error"; "Crash policy is
  explicit per hook: ALLOW or DENY, no default". 1.13.0 "Blocking guards no longer
  silently disable themselves when the host stalls".

**Net for foreign (non-GSD) agent dispatches inside a GSD-managed repo: ALLOWED (or at
most advisory); guards block only GSD-internal escape cases.**

## 8. INSTALLER & RUNTIME ADAPTERS (DOCUMENTED + IMPLEMENTED)

- `npx @opengsd/gsd-core@latest`; "The installer prompts for your runtime ... global or
  local"; "The installer is required for cross-runtime compatibility — do not copy files
  from agents/ or commands/ directly."
- Claude plugin path: `claude plugin install gsd-core`; "The plugin delivers the command,
  agent, and hook surface; the npm package delivers the runtime CLI." Commands
  `/gsd-core:<command>`; hooks auto-wired; requires gsd-tools + node on PATH;
  `.claude-plugin/plugin.json` + marketplace.json in repo.
- 17 install targets / 16 families: Claude Code, OpenCode, Kilo, Codex, Kimi CLI, Kimi
  Code, GitHub Copilot, Cursor, Windsurf/Devin Desktop, Cline, CodeBuddy, Qwen Code,
  Augment Code, Antigravity, Trae, ZCode, pi.
- Adapter mechanics: "Workflows and agents are written in Claude Code's native format and
  transformed during deployment"; installer does translation (tool-name mapping Bash→
  execute; hook event names PostToolUse→AfterTool; frontmatter transforms; zcode @-ref
  rewriting 1.13.0). "Adapter" = CommonJS plugin bridging host event bus onto GSD hook
  scripts; "Surface" = artifact set a host consumes; hooksSurface: none for hosts without
  hook bus; per-runtime capability.json.
- Surface management: `/gsd-surface` "Toggle which skills are surfaced — apply a profile,
  list, or disable a cluster without reinstall"; install-minimal how-to; capabilities can
  be turned off; `agent_tools`/`model_overrides` only via npm installer.
- Global vs local: --global / --local; local precedence; --portable-hooks,
  --relative-includes.

## 9. COEXISTENCE & DIAGNOSTICS

- No `/gsd-doctor`. `/gsd-health` ("Validate .planning/ directory integrity", --repair,
  --backfill, --context); /gsd-progress, /gsd-stats, /gsd-next; `/gsd-forensics`
  ("Post-mortem investigation for failed GSD workflows"); gsd-tools check probes;
  gsd-tools runtime-identity.
- **Other-orchestration-plugin awareness: NONE FOUND.** Shadow warnings concern only
  overlapping installs of GSD Core itself ("a /gsd-* trigger is installed at more than one
  scope and one scope silently wins"; W028 via /gsd-health; "does not change which scope
  wins", never affects exit code). docs/superpowers/specs dir exists but contents not
  inspected; no evidence of Superpowers-coexistence docs.
- Foreign-tool identity: workflows resolve `gsd_run` (published only by @opengsd/gsd-core),
  never bare gsd-tools from PATH; launcher warns when tool cannot prove identity;
  $GSD_IDENTITY_STATUS ok/unverified; "A later release turns unverified into a refusal";
  "prefers its path-based branches"; with no provable candidate "It stops rather than
  guessing" (incident #3129). 1.12.0: "resolve gsd_run so workflows cannot reach a foreign
  gsd-tools", "assert gsd-tools identity on every state-mutating verb".
- Uninstall: --uninstall "cleanly removes managed hooks/artifacts"; "removes exactly these
  entries and preserves any others". Predecessor cleanup: detects leftover
  get-shit-done-cc artifacts across runtime config dirs, removes orphaned
  hooks/commands/files referencing old package name, preserves user-owned artifacts.

## 10. EXTENSIBILITY

- capabilities/: 45 subdirs (incl. per-runtime claude/codex/.../zcode + tdd, security,
  code-review, coderabbit, graphify(!), hermes, nyquist, schema-gate...). Lifecycle
  how-tos: develop/publish/import/version/remove/turn-off/take-over. EoS Registry.
  1.14.0 capability install `requires` relaxation.
- Attach plugin skills to GSD agents: config `"global:<plugin>:<skill>"` in agent_skills →
  "emit a Skill-tool load directive"; "works on the Claude runtime only"; GSD "does not
  manage plugins — you run /plugin install first"; cannot validate presence.
- Custom agent roles / custom commands: no dedicated docs found; installer preserves user
  custom agents; 1.13.0 "Allow configured agent tool grants to augment installed agent
  definitions across supported runtimes" (agent_tools).

## Verification caveats

npm website 403 (registry JSON used); "next" dist-tag anomaly; pre-1.6.1 dates unverified;
no literal "skip phases" language found; Superpowers coexistence docs absent (contents of
docs/superpowers/specs uninspected); .claude-plugin/ contents inferred from tree + docs.
