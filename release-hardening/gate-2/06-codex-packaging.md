# Gate 2 — 06: Codex Packaging

Date: 2026-09-23. Deliverable: `packaging/codex/` around the SAME behavioral
core, with the **skills-dir + script form as primary** (decision D6) and a
fully assembled, locally validated plugin form for later reach.

## 1. New facts recorded this Gate (drift since the baseline docs)

- Local Codex CLI is now **0.156.0** (docs said 0.154.0; version drift noted).
- The plugin CLI surface exists and works **without authentication** for
  local-marketplace operations: `codex plugin marketplace add|list|remove`,
  `codex plugin add|remove|list`.
- Codex auth (chatgpt mode) was refreshed 2026-09-22T23:14 — the Gate-1
  "auth expired" blocker has lifted; the deferred E9 live probe was run
  (see §4).

## 2. Package layout (mirrors official `openai/plugins` / `codex-warp`)

```
packaging/codex/
├── .agents/plugins/marketplace.json   local marketplace catalog (official format)
├── plugin/
│   ├── .codex-plugin/plugin.json      manifest: name iaa, version from VERSION, skills
│   └── skills/iaa/…                   byte-exact core (+ PROVENANCE)
└── README.md                          generated: primary script install + optional plugin
```

Facts verified against the official `openai/plugins` repository
(`.agents/plugins/marketplace.json` shape, `plugins/<name>/.codex-plugin/plugin.json`,
`skills/` layout) and the working local `codex-warp` marketplace on this
machine.

## 3. Lifecycle validation (disposable `CODEX_HOME`, 2026-09-23)

| Step | Command | Result |
|---|---|---|
| discover | `codex plugin marketplace add <pkg>` | ok (one earlier form rejected: `policy.authentication:"NOT_REQUIRED"` is not in the enum {`ON_INSTALL`,`ON_USE`} — the policy block is omitted for a no-auth plugin) |
| list | `codex plugin list` | shows `iaa@iaa not installed` with correct source |
| install | `codex plugin add iaa@iaa` | ok — enabled, **version-pinned cache** `plugins/cache/iaa/iaa/0.1.0-rc.1`, `[plugins."iaa@iaa"] enabled=true` in config.toml |
| uninstall | `codex plugin remove iaa@iaa` | ok — registration + versioned cache removed (an empty `plugins/cache/iaa/` dir remains; upstream behavior) |
| marketplace remove | `codex plugin marketplace remove iaa` | ok — config.toml clean of iaa entries |
| update | structure | cache is version-pinned per release; update path = marketplace snapshot refresh + re-add (validated structurally; a two-version update exercise is part of the install matrix where feasible) |

No unrelated user configuration was modified in any step (only
`config.toml` plugin/marketplace registrations owned by these commands; the
disposable-home before/after capture is in the §16 matrix).

## 4. MultiAgentV2 + `fork_turns` live probe (E9 — closed this Gate)

The Gate-1 residual honesty note ("numeric `fork_turns` schema-verified but
never behaviorally observed; local auth expired") is now closed with live
evidence (2026-09-23, codex-cli 0.156.0, chatgpt auth):

> Prompt (real HOME, İAA active via its own AGENTS.md shim + skill): spawn
> exactly ONE child with `fork_turns: "3"`, read `items.txt`, report.
> Result: exactly one child spawned; the child's report was correct; the model
> echoed the exact value passed: `fork_turns: "3"`. ~14 tokens of overhead
> beyond the trivial probe.

Notes: İAA itself governed the run (its adapter text appears in the transcript
context; anti-overdelegation held at exactly one agent — consistent with the
policy). The adapter sentence in `iaa/references/platform-adapters.md`
("omission defaults to full history; positive integer string forks only the
most recent turns; `all` for full history") is now **behaviorally confirmed on
all three documented values** (none/all in the 2026-08 campaigns; numeric this
run). No adapter text change was needed.

## 5. Interaction with the current install model

- The primary form remains `manage.sh install` (symlink `~/.agents/skills/iaa`
  + AGENTS.md managed block): this is the form all Codex behavioral evidence
  (ADR-0000, campaigns, E9) ran under, and it uses only officially documented
  surfaces (`~/.agents/skills` user dir, global AGENTS.md).
- The plugin form distributes the skill only; Codex plugins do not own
  `~/.codex/AGENTS.md`, so the routing block still comes from the explicit
  script step — stated plainly in the package README.
- Duplicate rule: skills-dir and plugin forms are mutually exclusive;
  `iaa doctor` detects both registrations (config.toml plugin table +
  skills-dir link) and reports the duplicate.

## 6. Submission-path facts (for a later gate, not acted on now)

The universal ChatGPT+Codex plugin directory requires a maintained test suite
(5 positive + 3 negative cases) plus identity verification; the enterprise
GitHub-marketplace path accepts Claude manifests for org-internal use. Gate 2
ships nothing to any directory — repository stays private.

## 7. Residual limits

- Dynamic *behavioral* validation of the plugin channel (skill discovery by a
  live Codex session from `plugins/cache/…`) was not run: it requires an
  authenticated interactive session in the disposable home; the static
  lifecycle validation above plus the byte-identical core bound the risk.
  Carried as the single remaining dynamic gap for the Codex plugin form
  (the skills-dir form is fully live-validated, including E9).
