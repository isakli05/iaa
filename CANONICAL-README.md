# Persistent cross-tool multi-agent orchestration

Installed 2026-08-26 for the local Codex CLI, Claude Code, and ZCode environments. This is a user-level workflow preference; no application repository was modified.

## Architecture

```text
~/.local/share/ai-agent-orchestration/
└── multi-agent-orchestration/       canonical source of truth
    ├── SKILL.md                     decision policy
    ├── references/                  delegation + platform adapters
    ├── scripts/manage.sh            install / verify / uninstall
    └── tests/scenarios.md           behavior contract
             │
             ├── ~/.agents/skills/multi-agent-orchestration   (Codex)
             ├── ~/.claude/skills/multi-agent-orchestration   (Claude)
             └── ~/.zcode/skills/multi-agent-orchestration    (ZCode)
```

All three discovery entries are relative directory symlinks to the same canonical skill. Each product also has a short managed global-instruction section that tells the primary agent to load the skill when delegation is requested or materially useful. Detailed procedure is loaded only when relevant.

## Installed versions and native mechanisms

| Product | Installed | Integration |
|---|---:|---|
| Codex CLI | 0.149.1 | `~/.codex/AGENTS.md`; user skill symlink under `~/.agents/skills`; built-in `explorer`, `worker`, and `default` agents |
| Claude Code | 2.1.246 | `~/.claude/CLAUDE.md`; user skill symlink under `~/.claude/skills`; built-in `Explore`, `Plan`, and `general-purpose`; spawn depth capped at 1 |
| ZCode | 3.7.7 | `~/.zcode/AGENTS.md`; user skill symlink under `~/.zcode/skills`; built-in `Explore` and `general-purpose` |

The ZCode installation is behind the 3.9.2 version advertised by the current download page. The documented behaviors used here apply to 3.7.7: AGENTS.md injection for ordinary subagents dates from 3.7.1, while built-in Explore still omits it.

Official references:

- Codex: [skills](https://developers.openai.com/codex/skills), [AGENTS.md](https://developers.openai.com/codex/guides/agents-md), [subagents](https://developers.openai.com/codex/multi-agent)
- Claude Code: [memory and CLAUDE.md](https://code.claude.com/docs/en/memory), [skills](https://code.claude.com/docs/en/slash-commands), [subagents](https://code.claude.com/docs/en/sub-agents)
- ZCode: [Agent and AGENTS.md](https://zcode.z.ai/en/docs/agents), [skills](https://zcode.z.ai/en/docs/skill), [subagents](https://zcode.z.ai/en/docs/subagents), [install](https://zcode.z.ai/en/docs/install)

## Trigger and decision semantics

These phrases match the skill description and the managed shim:

- "use subagents for this"
- "divide this among subagents"
- "delegate this work"
- "parallelize this where appropriate"
- "orchestrate this with agents"

They mean: apply the orchestration policy and delegate only where a bounded child context provides a concrete advantage. They do not require maximum fan-out or delegation of every operation. A direct instruction such as "do not use subagents for this task" overrides the global default for that task.

The policy also permits proactive delegation for materially complex work with genuine parallelism, useful isolation, specialization, context offloading, or meaningful independent review. Tiny or tightly coupled work stays primary.

The primary agent always owns decomposition, shared contracts, disjoint write ownership, integration, final tests, and the answer. Root-to-child is the default; nested orchestration is blocked in Claude and prohibited by policy elsewhere unless deliberately enabled for a bounded, explicitly requested case.

## Platform adapters

### Codex

Codex reads the global shim from `~/.codex/AGENTS.md` and discovers the canonical skill through `~/.agents/skills/multi-agent-orchestration`. The pre-existing `[agents]` configuration remains enabled with a four-child concurrent ceiling. No Codex model name was added or changed.

Codex can use targeted history-free/bounded forks for isolation and full-history forks only when the child genuinely needs surrounding decisions. The pre-existing `~/.codex/agents/reviewer.toml` remains available; this installation did not create or modify it.

### Claude Code

Claude reads `~/.claude/CLAUDE.md` and follows the officially supported symlink in `~/.claude/skills`. `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` is set to `1` in `~/.claude/settings.json`, disabling child-to-grandchild spawning while preserving primary-to-child delegation.

Built-in Explore and Plan omit CLAUDE.md and preloaded skills, so the platform adapter tells the parent to restate repository constraints and ownership in every such assignment. Full custom agents were unnecessary.

### ZCode

ZCode reads only the user global `~/.zcode/AGENTS.md` and the current workspace-root `AGENTS.md`; it does not continuously use CLAUDE.md or merge a nested instruction chain. The skill is linked into the documented `~/.zcode/skills` location. ZCode officially supports symlink import mode.

Built-in Explore is read-only and does not inject AGENTS.md. General-purpose and ordinary user agents do inject it in this installed release. ZCode subagents cannot spawn other subagents. No beta custom ZCode agent was created.

## Existing-policy reconciliation

Existing Graphify sections in all three global instruction files were preserved. Codex's older, duplicated native-orchestration prose was replaced by the managed shim because the canonical skill now holds that method.

The enabled Superpowers plugin in Claude and ZCode contributes `subagent-driven-development` (SDD), a complete alternative orchestration engine: fresh implementer per task, mandatory task review and final whole-branch review, no parallel implementers. MAO and SDD are never composed on one task — see "Superpowers execution modes" below. Compatible Superpowers component skills remain usable individually. No plugin cache file was edited and the plugin stays enabled.

## Superpowers execution modes

Exactly one orchestration authority governs a task.

**Mode 1 — Adaptive MAO (default).** Any request to use subagents, delegate, divide, or parallelize — including "use subagents where appropriate" — selects MAO. The full SDD umbrella skill is not loaded as a competing authority; its per-task reviewer cadence, fresh-implementer rule, and sequential-implementer rule do not enter execution. MAO alone decides topology, concurrency, ownership, and review materiality, and owns integration and final validation.

**Mode 2 — Native Superpowers SDD (explicit opt-in).** Only an explicit request naming the workflow ("use native superpowers:subagent-driven-development", "execute this with Superpowers SDD") selects it. SDD then governs its own execution; MAO does not constrain it. The modes are mutually exclusive per task.

**Component skills MAO mode may still use individually:** `test-driven-development`, `using-git-worktrees`, `verification-before-completion`, `receiving-code-review`, `finishing-a-development-branch`, `systematic-debugging`, `writing-plans`, and `executing-plans` for plan-execution discipline. Two component skills prescribe agent seats — `requesting-code-review` and `dispatching-parallel-agents` — and are applied only to execute a lane MAO has already authorized. SDD-internal mechanisms (ledger workspace, task-brief/review-package scripts, prompt templates) are not required in MAO mode; the delegation contract covers briefs and handoffs.

**Review authorization stays adaptive.** MAO authorizes an independent reviewer when risk warrants it (auth, security, destructive migrations, concurrency, shared contracts, public APIs, ambiguous correctness); low-risk mechanical work is verified by the primary. Authorizing a review never preauthorizes a fixer or re-reviewer.

**Why not prose precedence:** behavioral evidence (2026-08-27, `~/collision-smoke-test-evidence/post-fix-20260827/`) showed the same precedence policy honored in one model sample and ignored in another once SDD's full imperative body was loaded. The fix moves control to skill selection: SDD is simply not loaded in MAO mode, so there is no second topology authority to fight.

**Testing the routing:** `tests/scenarios.md` J (default delegation request must not load SDD) and K (explicit native request must let SDD govern). Post-separation behavioral evidence lives in `~/mao-sdd-archfix-20260827/`.

**Superpowers upgrade check:** after any Superpowers update, re-check `skills/executing-plans/SKILL.md` and `skills/writing-plans/SKILL.md` for redirects into `subagent-driven-development`, re-scan component skills for new agent-prescribing text, and re-run scenario J. Update the mode wording in `SKILL.md` if upstream trigger descriptions change.

## Files and links

Created files:

- `/home/isa/.local/share/ai-agent-orchestration/README.md`
- `/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/SKILL.md`
- `/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/references/delegation-contract.md`
- `/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/references/platform-adapters.md`
- `/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh`
- `/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/tests/scenarios.md`
- `/home/isa/.config/ai-agent-orchestration/claude-depth.state`

Created symlinks:

- `/home/isa/.agents/skills/multi-agent-orchestration -> ../../.local/share/ai-agent-orchestration/multi-agent-orchestration`
- `/home/isa/.claude/skills/multi-agent-orchestration -> ../../.local/share/ai-agent-orchestration/multi-agent-orchestration`
- `/home/isa/.zcode/skills/multi-agent-orchestration -> ../../.local/share/ai-agent-orchestration/multi-agent-orchestration`

Modified files:

- `/home/isa/.codex/AGENTS.md`
- `/home/isa/.claude/CLAUDE.md`
- `/home/isa/.claude/settings.json`
- `/home/isa/.zcode/AGENTS.md`

Backups created:

- `/home/isa/.codex/AGENTS.md.multi-agent-orchestration-backup-20260826T173941+0300`
- `/home/isa/.codex/AGENTS.md.multi-agent-orchestration-backup-20260826T174355+0300`
- `/home/isa/.claude/CLAUDE.md.multi-agent-orchestration-backup-20260826T173941+0300`
- `/home/isa/.claude/CLAUDE.md.multi-agent-orchestration-backup-20260826T174355+0300`
- `/home/isa/.claude/settings.json.multi-agent-orchestration-backup-20260826T173941+0300`
- `/home/isa/.zcode/AGENTS.md.multi-agent-orchestration-backup-20260826T173941+0300`
- `/home/isa/.zcode/AGENTS.md.multi-agent-orchestration-backup-20260826T174355+0300`

The second AGENTS/CLAUDE backups were produced by the first installer normalization pass; subsequent installer runs were byte-identical and produced no additional backups.

## Validation results

Configuration checks completed:

- `codex --strict-config doctor`: 19 OK, 0 warnings/failures; multi-agent feature enabled.
- `claude doctor`: no installation issues; current authentication is missing, so live Claude model smoke tests stop at `/login`.
- Canonical skill quick validation: passed.
- `manage.sh verify`: all three links, all three shims, Claude spawn depth, and ZCode description limit passed.
- Installer run twice on the real setup: byte-identical second run.
- Full install → repeat install → uninstall lifecycle in an isolated fake home: passed.
- Independent read-only review: no blocking findings; uninstall preflight and marker-order validation were hardened from its feedback, and the scenario contract was expanded for nesting, conflicting skills, failed children, and Explore constraint propagation.
- ZCode 3.7.7 filesystem and installed-runtime evidence confirms its existing skill symlinks are followed; this new skill still needs Settings → Skills → Refresh for a desktop-native live check.

Codex behavioral smoke results in a disposable repository:

| Scenario | Result |
|---|---|
| A — trivial task | Passed after refinement: primary read the heading directly; zero child threads. |
| B — independent exploration | Passed: two direct depth-1 `explorer` children mapped orders and billing separately; primary owned shared synthesis. |
| C — overlapping writes | Passed: primary changed the shared contract first, then two depth-1 `worker` children owned disjoint orders/billing test files; full suite passed. |
| D — explicit investigate/fix | Passed: two bounded depth-1 diagnosis lanes confirmed one billing typo; primary made the single functional fix and ran targeted/full tests. |
| E — implicit benefit | Passed: without agent wording, three direct depth-1 explorers handled architecture, test gaps, and contract risk; primary verified and synthesized. |

The first A run exposed over-triggering through a manufactured reviewer task. The policy was tightened so trivial edits and equally small verification are an explicit no-delegation default, and the rerun passed.

## Edit once, refresh everywhere

Edit the canonical files only:

```sh
${EDITOR:-vi} /home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/SKILL.md
```

Changes flow through all three symlinks immediately. Codex normally detects skill edits automatically; restart if a selector is stale. In Claude run `/reload-skills` or start a new session. In ZCode open Settings → Skills, click Refresh, and start a new task if an existing task still has old metadata.

Keep the description concise and trigger-specific; ZCode injects only about the first 250 characters of enabled-skill descriptions. The current description is 245 characters.

## Verify discovery

Run the static checks:

```sh
/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh verify
python3 /home/isa/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  /home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration
```

Product-native checks:

- Codex: `codex -a never exec --ephemeral -s read-only --skip-git-repo-check 'Invoke $multi-agent-orchestration and summarize its delegation decision rule.'`
- Claude: after login, use `/memory`, `/skills`, and `/reload-skills`; invoke `/multi-agent-orchestration` or a matching natural-language prompt.
- ZCode: Settings → Skills → Refresh; confirm `multi-agent-orchestration` is enabled, then invoke `$multi-agent-orchestration`. Settings → Subagents should show the built-in general-purpose and Explore roles.

## Disable, reinstall, or uninstall

For one task, say: `Do not delegate or spawn subagents for this task.`

For a full reversible uninstall:

```sh
/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh uninstall
```

This removes only the three marked shims and three symlinks, and removes the Claude depth setting only if it still has the managed value `1`. It preserves unrelated configuration, backups, and the canonical source. Restart active sessions after uninstalling.

Reinstall with:

```sh
/home/isa/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh install
```

To remove the retained source too, first run `uninstall`, then move `/home/isa/.local/share/ai-agent-orchestration` to a recoverable archive location. Remove `/home/isa/.config/ai-agent-orchestration` only after confirming it contains no state you want to keep.

## Limitations

- Claude Code is installed but not logged in, so only its native doctor, documented paths, settings parse, symlink, and static discovery were validated. A live Claude behavior run requires `/login`.
- ZCode 3.7.7 exposes no supported headless CLI; live discovery and behavior must be checked in the desktop UI. `zcode --version` is not a diagnostic—it launches the app.
- Active sessions can cache instruction and skill metadata. Start a new task/session after installation, refresh, or uninstall.
- Claude's depth cap intentionally disables nested delegation by default. For a deliberately bounded nested task, start that session with a higher `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, then return to `1`.
