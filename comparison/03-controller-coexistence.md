# Comparison 03 — Controller Coexistence

Date: 2026-09-22. How systems behave when multiple orchestration frameworks are installed
simultaneously, across four distinct classes (baseline research/02 taxonomy):
**I**nstallation/filesystem, **N**amespace, **T**rigger, **O**rchestration-authority.
"Both install successfully" is never treated as "they coexist safely."

## 1. What each system offers for coexistence, from current primary sources

| System | Ownership protocol | Yield rules | Namespace behavior | Installer warnings | Trigger-precedence rules | Verdict |
|---|---|---|---|---|---|---|
| MAO (baseline) | Yes — two-mode mutual exclusion at selection time; sole-authority declaration; artifact provenance rule (C2/C3/C9 PROVEN) | Yields fully on explicit by-name workflow request (tested for SDD only) | un-namespaced user skill (known risk, limitation #9) | none (marker-delimited self-discipline only) | description routing + instruction-channel shim | the only system with an authority concept |
| Superpowers 6.4.1 | **None** — no awareness of MAO/GSD/BMAD anywhere in repo/docs read | None (skills "Mandatory workflows, not suggestions") | plugin-namespaced `superpowers:*`; same-named plugin+local skills **both load** (Claude official) | none | its bootstrap *concedes* precedence: "User instructions (CLAUDE.md, AGENTS.md…) take precedence over skills" (verbatim at 6.4.1); no per-skill disable documented | no coexistence design; accidental compatibility via that one concession |
| GSD Core 1.14.0 | **None toward foreign frameworks** (no Superpowers/other-plugin mention found; shadow docs cover only GSD-own multi-scope installs) | None; guards explicitly **allow** foreign dispatches (agent-isolation guard activates only for `subagent_type === "gsd-executor"`; workflow guard advisory, default-off) | npm global installs as **skills** (model-invocable, broad descriptions); Claude plugin installs namespaced `/gsd-core:*` | W028 shadow warning (own scopes only; "does not change which scope wins"); refuses unprovable foreign `gsd-tools` ("It stops rather than guessing") | guards scoped to `.planning/config.json` projects; outside GSD projects, hooks are inert except secret-read guard (unconditional) + update/session checks | mechanism-grade for *invariants*, deliberately non-authoritarian toward *authority* |
| Claude native | None — conflicts resolve by model judgment ("may load the wrong skill"; "Claude uses judgment to reconcile") | n/a | plugin skills namespaced; `skillOverrides` 4 states but **excludes plugin skills**; same-name local+plugin both load | plugin trust warnings (security, not coexistence) | "a request, not a guarantee" doctrine; `/name` explicit invocation is the deterministic path | platform supplies collision *mechanics*, not policy |
| Codex native | None | n/a | name collisions "both can appear in skill selectors" (not merged) | none found | `allow_implicit_invocation` per skill (default true); Ultra-tier **proactive delegation template** ("materially improve speed or quality") — a prose policy that would share instruction space with MAO's AGENTS.md shim if both active (untested) | same |
| ZCode native | None documented | n/a | `.agents/skills` fallback only when no same-named `.zcode/skills` skill; `.zcode-plugin` → `.claude-plugin` manifest priority | none found | per-turn ≤250-char description injection; no implicit-disable flag | same |
| BMAD 6.12 | **None** (zero mentions of other frameworks) | None | installs skill dirs per tool + managed block in repo AGENTS.md | ancestor_conflict_check (own files only) | none documented | rides AGENTS.md/skills conventions; additive, unaware |

**Structural result:** *no system reciprocates anyone else's authority.* MAO's mutual
exclusion is one-sided by necessity — it works because MAO declines to load competitors
and yields on explicit request, not because anyone yields back.

## 2. Pair-by-pair analysis (current evidence, matrix deltas vs baseline)

### MAO + Superpowers (installed together)
The only **behaviorally tested** pair (campaigns 1–3; PROVEN in both directions). Status
at current versions: local 6.3.0 evidence; upstream 6.4.1 delta re-checked doc-level —
SDD contract, REQUIRED SUB-SKILL header, bootstrap, precedence concession all
verbatim-unchanged (00 §4B). Classes: I=OK (plugin-scoped cache; MAO touches nothing
foreign, mtime-swept), N=OK (namespaced), T=**permanently open flank** (both
`subagent-driven-development` and `dispatching-parallel-agents` descriptions overlap MAO's
trigger surface; no per-skill disable exists upstream), O=resolved-by-MAO (exclusion;
residual = routing mis-fire, tripwired by scenario J). **Pending: the documented
upgrade-check against 6.4.1 has not been run** (limitation #2 — now due).

### MAO + GSD (not installed locally — analysis from primary sources; untested behaviorally)
Baseline matrix scored this pair **unknown across I/T/O** with the specific worry "GSD's
PreToolUse workflow guards may gate MAO's own dispatches." Current evidence **resolves the
mechanism question and largely de-risks T/O**:
- **O/T:** GSD's agent-isolation guard hard-blocks only `gsd-executor` dispatches in
  GSD-configured projects under `harness-worktree` isolation; **any other Agent/Task
  dispatch "returns allow" before GSD state is even consulted** (stream-gsd §7). MAO's
  Explore/general-purpose dispatches inside a GSD-managed repo would pass untouched. The
  reverse direction (GSD global skills' broad descriptions competing with MAO's
  description on a "divide this work" prompt) is a genuine **Class-3 trigger contest with
  zero tested evidence** — same shape as the original SDD collision, untested.
- **I:** GSD's npm installer writes 23 JS + 5 shell hook files into `~/.claude/hooks/` and
  managed entries in settings; MAO's artifacts are disjoint paths (symlink, CLAUDE.md
  block, one env key) — no file overlap by construction on either side. GSD's
  SessionStart hooks (canonical-path check, update check) are additive with Superpowers'
  bootstrap and MAO's shim (all coexist as separate hook entries — Claude hooks "merge
  across settings levels").
- **Open question (P4 gap, unchanged):** MAO's by-name yield rule ("a native workflow…
  governs itself") is generic wording; `/gsd-new-project`-style explicit invocations are
  covered by policy text but never tested against a real GSD run.

### Superpowers + GSD
Not tested anywhere; no awareness in either direction (GSD docs: none; Superpowers repo:
none found). Both install additively (plugin cache + npm hooks). Predicted flashpoints:
(i) Superpowers' bootstrap pressure vs GSD's workflow discipline inside a GSD project
(untested); (ii) GSD's global *skills* (npm form) vs Superpowers skills sharing the
model-invocable listing (Class-3); (iii) both write hooks — additive by platform merge
rules. No evidence exists; any "works alongside" claim would be fabricated.

### MAO + Claude Agent Teams
Teams still experimental + flag-gated (official), off locally. Two 2026-09 findings sharpen
the baseline's "unknown": (a) **auto-formation caveat** — "while agent teams are enabled, a
subagent that Claude names launches as a teammate, so teams can form even when you didn't
ask for one" → if a user enables teams, MAO-authorized dispatches could silently become
teammates (full sessions, higher token cost, no worktree isolation — "partition the
work"), changing topology semantics under MAO's feet; (b) no project-level team config
exists, so MAO cannot detect or defer to a team declaratively. Also: SendMessage/ListAgents
give *peer* identity that cuts across MAO's root-to-child model. Untested; flag remains a
real interaction class, now with a concrete mechanism.

### MAO + native Codex multi-agent
Mechanism, not authority (baseline verdict; unchanged). New wrinkles: (a) officially
documented CLI surface now lists `spawn_agent/send_input/resume_agent/wait_agent/
close_agent` while the locally audited 0.149.1 surface was `spawn_agent/send_message/
followup_task/wait_agent/interrupt_agent/list_agents` — tool-name drift to re-verify on
next local Codex behavioral test; (b) Responses-API multi-agent (hosted beta) officially
allows unbounded child-spawns-child nesting — MAO's Codex nesting stance (policy-only)
remains the weak flank and is now *officially* documented as unbounded upstream; (c) if a
user runs Codex at Ultra with the proactive-delegation template active, two
delegation-trigger policies (template + MAO shim) share one instruction space — same
instruction channel, compatible *values* (both gate on material benefit) but untested
interaction.

### MAO + ZCode plugin/subagent mechanisms
MAO's ZCode integration rides documented public surfaces (skills symlink, AGENTS.md shim)
— all still documented at 3.14.3 (with local skew: machine runs 3.11.2, adapter text
anchored to 3.7.7 behavior — rules re-verified doc-level 2026-09-22 but not live).
ZCode-side competitor surface: stale cached Superpowers 6.2.0 with a broken internal
symlink (upstream artifact, re-verified this session) — evidence that *plugin-version skew
across runtimes* is itself a coexistence hazard class (a user could have SDD 6.2.0 on
ZCode and 6.4.1 on Claude with different behavior each). ZCode dynamic workflows (3.14+)
are user-invoked script orchestration — opt-in like Claude workflows; collision with MAO
only if invoked inside an MAO-governed task (untested, same class as Claude Workflow).

### MAO + BMAD (not installed)
No coexistence design on BMAD's side; BMAD's surface is per-project skill dirs + managed
repo-AGENTS.md block + named agents. Overlap with MAO: bmad-build's own delegation
(reviewer subagents) would run *inside* whatever controller governs the session — if MAO's
shim is active, MAO's seat-materiality policy and BMAD's mandatory-review stage prescribe
conflicting cadences (same O-class collision as SDD, softer because BMAD reviews are
per-run not per-task). Untested; BMAD's 47-platform footprint makes it the most likely
foreign methodology a public MAO user will have installed.

### MAO + Claude native dynamic workflows (added)
Explicit opt-in only ("ultracode" keyword must be typed by the user; /effort ultracode;
saved workflow commands; plugin workflows). Gated so it cannot self-seize; would collide
only by explicit user invocation inside an MAO task — a P4-style by-name case MAO's yield
rule nominally covers, untested (07-E10).

## 3. Cross-cutting findings

1. **Nobody enforces authority; two systems enforce invariants; one system (MAO) declares
   authority.** Coexistence today = (MAO's one-sided exclusion) + (everyone's mutual
   ignorance) + (platform namespace mechanics). It holds locally because exactly one
   authority-declaring system is installed.
2. **The universal collision channel is the trigger listing**, not files: every
   model-invocable broad-description skill (MAO, SDD, dispatching-parallel-agents, GSD's
   global skills, BMAD's bmad-* skills) competes in the same selection step, and official
   doctrine says that step is fallible. Claude now documents mitigation knobs
   (skillOverrides) that explicitly do not reach plugin skills — the knob gap is official.
3. **SessionStart injection is an arms race MAO declined to enter** — and the only system
   that entered it (Superpowers) uses it for skill-first discipline, not authority; GSD's
   session hooks are opt-in state reminders. No bootstrap anywhere enforces a controller.
4. **This comparison session is itself a live coexistence datum** (2026-09-22, recorded):
   Superpowers SessionStart bootstrap injected (its hook ran, context present in this
   session), MAO shim present via CLAUDE.md, user task prompt explicitly forbidding
   framework control — and no controller seizure occurred; Superpowers process skills were
   available but unloaded. One sample, consistent with campaigns.
5. **Version skew is a coexistence dimension of its own**: local reality spans Superpowers
   6.2.0 (ZCode cache) / 6.3.0 (Claude) / 6.4.1 (upstream); ZCode 3.7.7 (adapter anchor) /
   3.11.2 (local) / 3.14.3 (current). Any public coexistence *claim* must pin versions or
   it is meaningless — the compatibility matrix already encodes this; the public README
   must too.

## 4. Do competitors have ownership protocols? (direct task question)

No. Inventory across all researched systems: ownership protocols — **none** (MAO only);
explicit yield rules — **none** (MAO only, SDD-tested); namespace only — Superpowers
(plugin), GSD (plugin form), everyone via platform mechanics; installer warnings — GSD
(self-scope W028 + foreign-tool identity refusal, closest analog: "stops rather than
guessing" about *its own CLI*, not about authority); trigger-precedence rules — none
(Codex per-skill implicit-disable is a self-control, not a precedence rule); no solution
at all — BMAD, ZCode, native platforms. **The controller-arbitration layer remains
unoccupied outside MAO** — the strongest single differentiator finding of this comparison
(H4), and simultaneously the least reciprocated.
