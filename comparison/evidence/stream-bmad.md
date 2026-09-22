# Evidence — BMAD-METHOD research stream (2026-09-22)

Raw evidence report from read-only Explore research subagent #6 (BMAD stream). Recorded
for traceability; classification and comparative judgments live in the numbered comparison
documents. Controller: main session.

Subagent usage rationale: independent research stream over ~44 primary-source fetches
(bmad-code-org/BMAD-METHOD repo, releases, CHANGELOG, npm registry, docs.bmad-method.org);
context offloading; no source-of-truth decisions delegated.

---

Repo: now `bmad-code-org/BMAD-METHOD` (formerly bmadcode/BMAD-METHOD); created 2025-04-13;
53.3k stars; last push 2026-09-22.

## 1. VERSION

**Current: v6.12.0, released 2026-09-04** (releases atom + CHANGELOG + npm
bmad-method@6.12.0). dist-tags: latest 6.12.0, next 6.12.1-next.0, rollback 4.39.0.
**v7 in preview** (docs "Help Test v7 Previews": "set up an initiative store, configure
it, and use the ticketing preview skill"; v6.9.0: "v7 will standardize on uv").

Major timeline: v1 Apr 6 2025 → v2 Apr 17 → v3 May 20 ("Orchestrator Era") → v4 Jun 20
(Enterprise + npm) → v5.0.0 2025-06-15 ABORTED/deprecated ("Version superseded. Use
bmad-method@latest (4.44.3)") → v4.x through Sep 2025 → v6.0.0-alpha Sep 28 2025 →
**v6.0.0 stable 2026-02-17** → v6.1.0 2026-03-13 ("everything is now a skill!") → v6.3.0
2026-04-10 (consolidate Barry/Quinn/Bob into Amelia dev agent) → v6.5.0 2026-04-26 ("42
platforms"; `.agents/skills/` standard) → v6.8.0 2026-05-25 (Web Bundles) → v6.10.0
2026-07-03 (bmad-loop, bmad-dev-auto, party-mode) → v6.11.0 2026-08-10 ("Quick Dev
becomes Build, the one official way BMad implements code"; core skills 14→8; TOML + uv
hard requirements) → v6.12.0 2026-09-04 (Build skill "sizes ceremony to the change;
review triage logs a verdict per finding").

Repo tree (IMPLEMENTED): src/core-skills/ (8–9 incl. bmad-help, bmad-review,
bmad-party-mode, bmad-deep-recon, bmad-customize, bmad-brainstorming, bmad-forge-idea,
bmad-advanced-elicitation), src/bmm-skills/ (agents + plan/ + ship/ + v6-shims/),
src/scripts/ (Python: memlog.py, resolve_config.py via uv), tools/installer/ (CLI).

## 2. MODEL

**Five named agents** (IMPLEMENTED src/bmm-skills/agents/ + DOCUMENTED docs/reference/
agents.md): Analyst (Mary) — brainstorm/research/brief/PRFAQ; PM (John) — PRD, epics &
stories, "Implementation Readiness (sprint-planning gate)", course-correct; Architect
(Winston) — architecture + readiness gate; Developer (Amelia) — Build, QA test generation,
code review, sprint planning, epic retro; UX Designer (Sally). "The Technical Writer
(Paige) is on hiatus." QA no longer separate: "QA test generation is handled by the
`bmad-qa-generate-e2e-tests` workflow skill, available through the Developer agent".

Workflow (DOCUMENTED): loop "Clarify → Plan → Build and verify → Learn and adjust"; "a
vague notion enters at Clarify, a big clear idea enters at Plan, and a small change goes
straight to Build and verify. Every path runs the same loop." Planning chain: brainstorm/
brief/PRFAQ → bmad-prd → bmad-ux → bmad-architecture → bmad-create-epics-and-stories →
readiness gate → bmad-sprint-planning → bmad-build → review/walkthrough →
bmad-retrospective. **Sharding gone** ("v4 Sharded or unsharded required setup" vs "v6
Fully flexible, auto-scanned"). Stories: `stories/<story-id>-*.md` + stories.yaml;
sprint-status.yaml.

Web-vs-IDE split (DOCUMENTED): web bundles = BMad skills repackaged as Gemini Gems /
ChatGPT Custom GPTs; "Plan in the web, build in the IDE"; handoff manual (export Canvas →
paste into repo → feed to IDE skill). Six bundles shipped.

Dev loop (DOCUMENTED, bmad-build): takes "a sentence, an issue, a spec, or a planned
story"; phases: resolve intent → **"Route to smallest safe path"** → plan → spec →
implement → review → present. "It does not have to be tidy." Review stage "reviews its
own work with independent reviewers" (three lenses: "Blind Hunter", "Edge Cases Hunter",
"Verification Gap Finder"); "Review can patch the work, send it back to plan or
clarification, void it, or defer it"; deeper failures "goes back to that layer and
regenerates from there instead of patching only the diff."

Approval gates: open questions before approval; plan approval ("Approve the plan when it
describes the right thing to build. Push back if it does not"); readiness gate verdicts
"PASS, CONCERNS, or FAIL" ("a fail stops with findings ordered by severity, each naming
the skill that fixes it"); human reviews result then "ask it to push the commit and create
a PR". `bmad-build-auto` = unattended variant, no human checkpoints.

## 3. MULTI-AGENT EXECUTION

- Primary build flow = one dev worker + spawned reviewer subagents (not a swarm). bmad-
  build "works best on a platform that can spawn subagents"; build-auto REQUIRES it
  ("Each worker must be able to start the review subagents used inside its own run"),
  else halts blocked/no-subagents.
- **Party mode** (multi-agent discussions; DOCUMENTED): four modes, one active per
  session: `session` ("One model voices every persona inline"); `auto` ("inline for light
  rounds, **spawns independent agents only when independence changes the answer**");
  `subagent` ("a separate agent for each persona every substantive round"); `agent-team`
  (Claude Code only; "persistent team whose members address each other directly").
  Fallback chain agent-team → subagent → session. Shipped casts: "Code Review Crew"
  (5 personas) and "Anti-Consensus Club" (4) — "It is not a voting body: it raises
  objections, checks claims, stops repetition, and returns the decision to you."
- Orchestration above worker: bmad-build-auto = "unattended worker for one session-sized
  unit"; "A human or an orchestrator, such as an AI coding session or bmad-loop, owns
  backlog policy and dispatch." bmad-loop (v6.10 module) "Builds, verifies, and retros a
  whole epic unattended" but "is a linear scheduler: it does not infer a dependency graph"
  ("Arrange the list so each story's prerequisites appear first").
- Parallelism/dependencies: "must start one Build Auto worker per story"; "Independent
  epic streams can run in parallel when dependencies and integration boundaries are
  explicit"; "Project-level parallelism needs a higher coordination layer or separate epic
  owners", and bmad-loop "does not provide that project-level coordination".
- Orchestration memory: memlog.py (IMPLEMENTED; v6.9.0 "shared memlog script").
- "Squads": term absent from all current primary sources (flag: unsupported claim).

## 4. RUNTIMES

- One npm installer CLI across **~47 platforms** (IMPLEMENTED platform-codes.yaml, "Paths
  verified against each tool's primary docs as of 2026-04-25"): incl. Claude Code
  (.claude/skills preferred), Codex (.agents/skills preferred), Cursor, GitHub Copilot
  (also .github/agents/*.agent.md stubs), Windsurf, Gemini CLI, OpenCode, OpenHands, Pi,
  QwenCoder, Replit Agent, Warp, ZCode, Zencoder, Hermes, Kiro, Kode, Amp, Antigravity,
  Bob, Crush, iFlow, Junie, KiloCoder, Kimi Code, Mistral Vibe, Mux, Neovate, Ona,
  OpenClaw, Pochi, Qoder, Rovo Dev, Trae, Auggie, AdaL, Block Goose, CodeBuddy,
  CodeWhale, Command Code, Cortex Code, Factory Droid, Firebender, Snowflake, Sourcegraph.
  (v6.5.0 claimed "42"; yaml has 47 — minor discrepancy.) VS Code as such not a target.
- Install (DOCUMENTED): Node ≥20.12; `npx bmad-method install` (interactive) or
  `--yes --modules bmm --tools claude-code` (headless); --list-tools; **uv hard
  requirement since v6.11.0** (skills rendering Python through uv incl. bmad-build/
  bmad-build-auto). No npm lifecycle install scripts (IMPLEMENTED). Also skills route
  (`npx skills add bmad-code-org/BMAD-METHOD`) and plugin marketplaces (Claude
  `/plugin marketplace add bmad-code-org/bmad-plugins`; Codex `codex plugin marketplace
  add`).
- CLI = installer CLI only (bmad/bmad-method bins; install.js/status.js/uninstall.js);
  no runtime orchestrator CLI — execution inside the AI tools.

## 5. ENFORCEMENT

**Prompt/policy-based; no hooks/guards installed.** No npm lifecycle scripts
(IMPLEMENTED). platform-codes.yaml writes skill dirs (+ Copilot/OpenCode command stubs).
One install-time guard: ancestor_conflict_check ("Refuse install when ancestor dir has
BMAD files"). Behavioral guardrails in-skill: build-auto "The workflow commits but does
not push"; review repair loop halts on "review repair loop exceeded 5 iterations
(non-convergence)"; "A blocked story file is permanent"; clean working tree required;
build produces "A ready-to-push commit", pushes only on request.

Files written: `_bmad/` ("Single installation folder": _config/, core/, bmm/, bmb/, cis/),
`_bmad-output/` (planning-artifacts/, implementation-artifacts/), per-tool skill dirs,
Copilot .github/agents stubs, OpenCode .opencode/commands, **a managed block inside the
repo's AGENTS.md** (docs/explanation/project-context.md: harness "Reads AGENTS.md at repo
root"; BMad maintains a marked block), per-module config.yaml (v6).

## 6. STATE

`_bmad/` + `_bmad-output/` (DOCUMENTED + IMPLEMENTED uninstall.js refs). Spec state
machine: frontmatter status `draft → ready-for-dev → in-progress → in-review → done |
blocked`, resume routing on re-invoke (draft→plan; ready/in-progress→implement;
in-review→review; blocked→"halt immediately"); stories matched via stories.yaml;
terminal artifacts "Auto Run Result", baseline_revision, deferred findings. Sprint
tracking: sprint-status.yaml after readiness gate; tickets.toml (v7 path); status query
fixed priority ("resume in-progress work, review what is waiting, start the next ready
story…"); "No time estimates: status, risks, and next steps only". memlog.py memory.
Current dir `_bmad` (underscore); `.bmad-method` was v4; `.bmad` not current.

## 7. COEXISTENCE

- **No documented awareness of Superpowers, GSD, or Claude native subagents** (zero
  mentions in README/docs fetched/repo docs search — absence of evidence noted).
- BMad rides harness-native AGENTS.md / .agents/skills conventions; migration path from
  its own older versions (backup+remove .bmad-method, delete legacy .claude/commands/
  bmad-* entries, move planning docs).
- Uninstall (IMPLEMENTED): `bmad uninstall` interactive + --yes ("Remove all BMAD
  components without prompting (preserves user artifacts)"; optionally _bmad-output/ with
  "WARNING: Contains your work products"; "This action is IRREVERSIBLE!"). **No
  ownership/yield rules toward other frameworks.**

## 8. POSITIONING (verbatim README)

- "Breakthrough Method for Agile Ai Driven Development"
- "Agile Ai Driven Development — turn an idea or change request into working software
  without giving up the thinking."
- "decisions stay explicit, context carries forward, and the process sizes itself to the
  work"
- "BMad is free and open source, with no paywalled workflows or gated community." (MIT;
  BMad trademark of BMad Code, LLC; docs © 2026 BMad Code, LLC)
- Docs homepage: "BMad adds a set of named commands, called skills, to AI coding tools
  such as Claude Code and Cursor." Localized index: "Framework … with specialized agents,
  guided workflows, and intelligent planning."
- "agile agency" (v4-era) absent from current README.

## Flags

(1) v5.0.0 deprecation date unverifiable; GitHub release-page dates for old tags
retroactive/unreliable (npm/commit dates authoritative). (2) platform count 42 vs 47.
(3) "squads" unsupported. (4) 6.x npm timestamps from operational fields (registry doc
truncated before 6.x time entries).
