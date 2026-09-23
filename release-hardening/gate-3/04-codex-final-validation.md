# Gate 3 — 04: Codex Final Dynamic Validation

Date: 2026-09-23. The Gate-2 blocker (gate-2/06 §7, matrix m4): "dynamic
behavioral validation of the plugin channel — skill discovery by a live
Codex session from `plugins/cache/…` — requires an authenticated
interactive session in the disposable home". This Gate: authentication was
available (chatgpt mode, tokens present, refreshed 2026-09-22T23:14Z) and
the minimum live validation was executed.

Environment: codex-cli **0.156.0** (unchanged from Gate 2; upstream latest
is 0.156.1, released 2026-09-23 — see 07-version-recheck.md; claims stay
pinned to 0.156.0). Disposable `HOME=/var/tmp/iaa-g3-codex/home` with only
`auth.json` copied in; working dir `/var/tmp/iaa-g3-codex/work`; the real
home's skills-dir İAA install was therefore invisible (no `~/.agents`).

## 1. Setup (fresh, this Gate)

```
codex plugin marketplace add <repo>/packaging/codex   → Added marketplace `iaa`
codex plugin add iaa@iaa                              → Added plugin; cache
  /var/tmp/.../plugins/cache/iaa/iaa/0.1.0-rc.1
codex plugin list                                     → iaa@iaa  installed, enabled  0.1.0-rc.1
```

`config.toml` in the disposable home contains ONLY the iaa marketplace +
plugin registrations — no unrelated configuration touched.

## 2. Live dynamic probe (authenticated session, 2026-09-23T11:17Z)

Prompt: "Use the $iaa skill. In at most three sentences, state the rule it
applies before delegating any work to a subagent, and name its zero-agent
default. Then stop — do not spawn any agents."

Result (5,770 tokens, no agents spawned):

> "The iaa skill requires a task-specific, concrete benefit that outweighs
> coordination cost before every delegation, with enough prior orientation
> to define sensible boundaries. Its zero-agent default is **no
> delegation**: keep tiny, sequential, tightly coupled, poorly bounded, or
> cheaper-to-do-directly work in the primary context."

Transcript-verified (rollout JSONL, not self-report):

1. **Discovery — CLOSED.** The session's developer context carries the
   skills table with skill root `r1 = .../.codex/plugins/cache/iaa` and
   the entry **`iaa:iaa: Use for requests to use subagents, delegate,
   divide, or parallelize work…`** — the core's exact description (249
   chars), registered from the plugin cache. The plugin channel is fully
   discoverable by a live session.
2. **Invocation — CLOSED.** The model loaded the actual core (exec-catted
   the SKILL.md from the plugin cache after one wrong path guess that it
   self-corrected via a filesystem search) and derived the answer from the
   real policy text. Honest mechanism note: in `codex exec` the `$iaa`
   token does not magically expand into context — resolution is
   model-mediated via the session skills table (locate + read), which is
   Codex's documented skill model. The first path guess
   (`cache/iaa/0.1.0-rc.1/...`) missed the marketplace segment and the
   model recovered via `rg --files` — recorded as an upstream
   UX observation, not an İAA defect.
3. **Native multi-agent surface — re-confirmed statically.** The same
   developer context carries the `multi_agent_role` guidance quoting
   `fork_turns` values ("none" or a positive integer string) — the exact
   semantics İAA's adapter documents. (Behavioral spawn + `fork_turns:"3"`
   was already live-proven by Gate-2 E9 on the skills-dir form; not
   re-spawned here — cost discipline, no new claim needs it.)
4. **No duplicate core — verified.** Disposable home has no
   `~/.agents/skills`; the plugin cache `skills/iaa` tree is
   `diff -r`-identical to the repository core (excluding PROVENANCE) —
   exactly one activation channel.
5. **Adapter assumptions — valid on 0.156.0** (see 3; 0.156.1 is a patch
   above the tested version, re-check discipline applies).
6. **No unexpected controller nesting.** The plugin distributes the skill
   only; no AGENTS.md managed block exists in the disposable home (the
   routing block comes only from the explicit script step — confirmed
   absent until that step runs).
7. **Fresh-context-first — consistent.** The platform's own child-role
   guidance (`fork_turns` inheritance semantics) matches the adapter's
   documented behavior; nothing in the plugin form contradicts it.

## 3. Verdict

The single remaining Codex dynamic gap from Gate 2 is **closed**. Evidence:
`/var/tmp/iaa-g3-codex/` (disposable home + session rollout; machine-local
per the evidence-disposition policy).

Publication-safe status for the Codex **plugin form** (matrix update):
**TESTED** — full lifecycle (Gate 2, 0.156.0) + live authenticated
discovery & explicit invocation from the plugin cache (this Gate, 0.156.0)
+ byte-identical core; behavioral delegation evidence (campaigns, E9)
carried by the same core via the skills-dir form. The skills-dir form
remains TESTED as before. No higher claim (e.g. about GSD/BMAD or other
models) is made anywhere.

Residual (non-blocking, documented): `$iaa` in exec mode resolves
model-mediated rather than by token expansion; if OpenAI later ships an
explicit skill-invocation command surface, re-validate invocation through
it (runbook post-publication smoke).
