# Release Hardening 02 — Erratum E-2 resolution: Codex `fork_turns`

Date: 2026-09-23. Controller: main Claude Code session (no orchestration
framework used as controller). Task: Gate 1, §3 — independently verify current
Codex behavior and documentation for `fork_turns`, and correct factually
unsupported adapter text if present.

## 1. What was claimed, and by whom

**MAO adapter text under review**
(`multi-agent-orchestration/references/platform-adapters.md`, Codex section,
PA:8 at freeze):

> "Prefer an explicit fresh-context spawn (`fork_turns: "none"`) … If parent
> history is genuinely needed, inherit only the smallest useful recent-turn
> **suffix** with a **positive `fork_turns` value**; use `fork_turns: "all"`
> only when the child needs the full parent-thread history."

**Provenance of the claim:** ADR-0000 generalized the 2026-08-26 Codex native
audit (`~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md`) as
"fork_turns isolation semantics (none/all/**suffix**)". The raw diagnostics
live-tested only `fork_turns=none` and `fork_turns=all`; the word "suffix" and
any numeric-value semantics appear nowhere in the raw evidence.

**Comparison-phase finding (Erratum E-2, comparison/00 §5):** "`fork_turns:
"suffix"` is found nowhere (docs, issues, or SDK) — treat as nonexistent";
only `none`/`all` observed; recommendation class: adapter-accuracy defect.

## 2. Independent verification performed this session (2026-09-23)

1. **Local installed binary (static, decisive for syntax).** The official
   Codex CLI 0.154.0 npm package
   (`@openai/codex` 0.154.0, native binary
   `…/codex-linux-x64/vendor/x86_64-unknown-linux-musl/bin/codex`) contains,
   compiled in:
   - the tool-parameter description shown to the model:
     > "Optional number of turns to fork. Defaults to `all`. Use `none`,
     > `all`, or a positive integer string such as `3` to fork only the most
     > recent turns."
   - the validation error string:
     > "fork_turns must be `none`, `all`, or a positive integer string"
   - the model/effort interaction rule:
     > "Full-history forks (`fork_turns` omitted or `\"all\"`) inherit the
     > parent model and reasoning effort and do not accept overrides. … when
     > doing so, set `fork_turns` to `\"none\"` or a positive integer string."
   - and the V1/V2 bridge: "fork_context is not supported in MultiAgentV2;
     use fork_turns instead".
2. **Upstream source (openai/codex @ main,
   `codex-rs/core/src/tools/handlers/multi_agents_spec.rs`):** `fork_turns`
   is defined as a `JsonSchema::string` parameter of v2 `spawn_agent` with
   exactly the description quoted above; no enum type; default conveyed as
   `all`. The same file defines both tool-name generations
   (`send_message`/`followup_task`/`interrupt_agent` **and**
   `send_input`/`resume_agent`/`close_agent`, plus `wait_agent`, `list_agents`)
   — the comparison's "tool-surface drift" is coexistence of aliases, not
   removal of the audited names.
3. **Upstream engineering evidence:** openai/codex PR #23352 distinguishes
   `SpawnAgentForkMode::FullHistory` from "truncated forks … once we keep
   only the last N turns" — the bounded recent-N-turns fork is a real,
   maintained code path. Third-party corroboration (mindfold-ai/trellis#434):
   "It accepts `none`, `all`, or a positive number of recent turns … a number
   maps to a bounded-history fork."
4. **Official documentation:** the current public docs page
   (learn.chatgpt.com/docs/agent-configuration/subagents, redirected from
   developers.openai.com/codex/multi-agent) documents the `[agents]` config
   but does **not** document `fork_turns` at all. The tool schema is the only
   authoritative public surface.
5. **Live dynamic probe: NOT PERFORMED — blocked.** Local Codex auth is
   expired (`codex exec` fails with "Your access token could not be refreshed
   because your refresh token was already used. Please log out and sign in
   again."). Re-authentication requires an interactive owner login, which
   this task does not perform. The 2026-08-26 audit's dynamic method remains
   the recipe for the behavioral leg (comparison/07 E9); recorded as an open
   item, not as evidence.

## 3. Verdict on the old claim

| Element of the old text | Verified status today |
|---|---|
| `fork_turns: "none"` = fresh-context spawn | **CONFIRMED** (schema, validation, docs-by-schema) |
| `fork_turns: "all"` = full parent history | **CONFIRMED** |
| A bounded "recent-turn suffix" mode exists, selected by a positive value | **CONFIRMED in substance** — but the accepted form is a **positive integer string** (e.g. `"3"`), documented as "fork only the most recent turns"; the word "suffix" is MAO/ADR vocabulary, not upstream vocabulary |
| The advice was locally evidenced at write time | **FALSE** — the 2026-08-26 audit tested only none/all (E-2's core finding stands) |
| Comparison E-2's "nonexistent upstream" | **PARTLY WRONG** — a literal `"suffix"` string value indeed does not exist (that part stands), but the *mechanism* the sentence described (bounded recent-turns inheritance) is real and shipped in stable 0.154.0. The comparison's evidence stream searched for the wrong shape (a string enum) and missed the numeric mode its own issue #32031 reference pointed at |
| New fact worth stating | **Omitting `fork_turns` defaults to `all` (full history)** — an unconfigured spawn is NOT a fresh-context spawn. Strengthens, never weakens, MAO's fresh-context-first principle |

## 4. The correction applied (factual repair, not policy redesign)

**Only the Codex adapter sentence in `references/platform-adapters.md` was
changed** (synchronized: live canonical tree + repo copy + dev-plugin eval
copy, hash-verified identical — see 05-core-semantics-diff.md).

- **Old:** "…If parent history is genuinely needed, inherit only the smallest
  useful recent-turn suffix with a positive `fork_turns` value; use
  `fork_turns: "all"` only when the child needs the full parent-thread
  history. …"
- **New:** "…Note that omitting `fork_turns` is not a fresh-context spawn —
  it defaults to full history. If parent history is genuinely needed, pass
  the smallest useful number of recent turns as a positive integer string
  (for example `fork_turns: "3"` forks only the most recent three turns); use
  `fork_turns: "all"` only when the child truly needs the full parent-thread
  history. …"

**Why this is factual repair:**

1. MAO's orchestration principle is untouched: fresh-context-first remains
   the default (`fork_turns: "none"` + targeted brief); inheritance remains
   the exception requiring genuine need; the warning that inherited history
   weakens isolation/cost/boundaries is verbatim-preserved.
2. The behavioral meaning of the middle option is preserved **where
   supported** — and it is supported: "smallest useful recent-turn" ≡
   "smallest useful N" under the verified "fork only the most recent turns"
   semantics.
3. What changes is only fact-precision: the exact accepted syntax (integer
   string, not "a positive value"), the removal of MAO-coinage ("suffix")
   presented as if it were platform vocabulary, and one newly verified fact
   (omission ⇒ full history) that makes the fresh-context-first default
   *stronger*.
4. No core-semantic surface (benefit test, seat justification, topology,
   ownership, nesting, boundary) is named by or depends on this sentence;
   the behavioral-contract entry C30 needed only its mechanism parenthetical
   updated to match (see 05).

**Erratum against the comparison (recorded, historical documents unchanged):**
E-2's "treat as nonexistent" conclusion is superseded by this verification —
recorded here and in 05; comparison/00 is a dated snapshot and is not edited.

## 5. Residual gaps (honest)

- The numeric mode is schema-verified and source-verified but **not yet
  behaviorally observed on this machine** (Codex auth expired). The original
  audit's none/all dynamic evidence plus today's static evidence bound the
  claim; a live `codex exec` probe after owner re-login closes it fully
  (comparison/07 E9 method, one cheap read-only session).
- Whether the truncated fork preserves the parent's prompt prefix is
  explicitly *not* preserved per PR #23352 (truncated forks rebuild context
  baseline) — irrelevant to MAO's advice, recorded for completeness.
