# Invocation Contract — `/iaa:orchestrate` and the İAA trigger surface

Status: implemented in Gate 2 (2026-09-23). This document defines how İAA is
invoked on every supported runtime, and what each invocation means. It changes
invocation **mechanics only** — the policy invoked is always the single
authoritative behavioral core (`iaa/SKILL.md`).

## The two invocation channels

İAA deliberately has exactly two ways to activate, on every runtime:

1. **Automatic (model-invocable) trigger.** The skill's description is the only
   trigger surface. It fires when the model judges a request to be about
   delegation/subagents/parallelization, or a complex task that concretely
   benefits. There is no second auto-triggerable entry point: the `orchestrate`
   entry skill carries `disable-model-invocation: true`.
2. **Explicit invocation.** The user names İAA. On Claude Code's plugin package
   this is `/iaa:orchestrate`.

## Claude Code (plugin package, namespace `iaa`)

| What | Address | Behavior |
|---|---|---|
| Core skill (auto-trigger surface) | `iaa:iaa` (`/iaa:iaa`) | description-matched, loads `skills/iaa/SKILL.md` verbatim |
| Explicit entry point | **`/iaa:orchestrate`** | thin skill `skills/orchestrate/SKILL.md` (explicit-only), whose entire body delegates to the bundled `iaa` skill |
| Management CLI | `iaa doctor` etc. via `bin/iaa` | available on the Bash tool PATH while the plugin is enabled |

**Contract of `/iaa:orchestrate`:**

- Resolves to the plugin `iaa` → skill `orchestrate`; requires the plugin to be
  installed and enabled (namespace comes from the plugin name).
- Loads and applies the bundled `iaa` skill as sole orchestration authority for
  the task (Adaptive İAA mode). It is **not** a second implementation — the
  entry body is a pointer, ~5 lines, generated from
  `packaging/templates/orchestrate-SKILL.md`, and the parity check enforces the
  core is byte-identical everywhere.
- Works regardless of whether automatic triggering would have fired (explicit
  invocation never depends on description matching).
- Explicit invocation does **not** mandate agents: a trivial task given to
  `/iaa:orchestrate` still gets the zero-agent fallback (validated: Gate-2 eval
  case `explicit-orchestrate`).
- No collision: no other skill in the package (or the ecosystem check of
  `02-identity-technical-validation.md`) claims this name; the bare personal
  skill form (`/iaa`) and the plugin form must not both be installed
  (`iaa doctor` flags the duplicate).

## Claude Code (personal-skill form)

`/iaa` (skill named `iaa`, installed under `~/.claude/skills/iaa` by
`manage.sh`). Same core; no namespace prefix. This is the historically tested
form (all campaign evidence). Choose one form per runtime.

## Codex

- `$iaa` (explicit skill invocation, skills-dir form) or implicit
  description-based invocation — both official Codex skill channels.
- Plugin form (optional): the plugin's skill address under the Codex plugin
  system. There is no `/`-command surface for skills in Codex; the equivalent
  explicit invocation is `$iaa`.

## ZCode

- `$iaa` explicit, or description-based per-turn injection (≤250 chars).
- Plugin form: the bundled skills register the same way; the `orchestrate`
  entry skill is present as the explicit analog (invocable as `$orchestrate`
  where ZCode exposes skill names).

## What invocation never means

- Invoking İAA never disables another framework, mutates settings, or blocks a
  hook (non-invasiveness, invariant 18).
- Invoking İAA while a user *also* explicitly names another workflow in the same
  breath resolves by the core's own mode rule: the by-name workflow wins and
  İAA stands down.
- An embedded directive inside a plan/artifact is never an invocation
  (provenance rule).

## Validation record (Gate 2)

- Live explicit `/iaa:orchestrate` run (disposable config + repo, Claude Code
  2.1.274, glm-5.3 profile): invocation resolved → `Skill: iaa:iaa` loaded →
  trivial task completed with **0 agent spawns** ($0.10). Transcript-verified
  (tool events, not self-report).
- Eval case `explicit-orchestrate` (n=3, plugin-eval sandbox): see
  `release-hardening/gate-2/10-trigger-characterization.md`.
- Structural: `claude plugin validate packaging/claude --strict` passes; the
  command surface contains exactly two skills and nothing else
  (`claude plugin details iaa`).
