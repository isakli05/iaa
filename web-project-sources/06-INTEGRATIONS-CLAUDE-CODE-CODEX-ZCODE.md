# 06 — Integrations: Claude Code, Codex, ZCode

All three integrations are identical in *meaning*, different only in
*mechanism*. Two distribution forms exist since Gate 2: **skills-dir**
(symlink + managed shim, the historically tested form) and **plugin package**
(marketplace-distributed; the shim still installs via the explicit integration
step — plugins cannot write instruction files). Authoritative docs on GitHub:
`docs/INSTALLATION.md`, `docs/INVOCATION.md`, `docs/COMPATIBILITY.md`.

## Mechanism map (stable)

| | Claude Code | Codex CLI | ZCode |
|---|---|---|---|
| Instruction surface | `~/.claude/CLAUDE.md` managed block | `~/.codex/AGENTS.md` managed block | `~/.zcode/AGENTS.md` managed block |
| Skills-dir surface | `~/.claude/skills/iaa` symlink | `~/.agents/skills/iaa` symlink (official user-skills dir) | `~/.zcode/skills/iaa` symlink |
| Explicit invocation | `/iaa` (skills-dir) · **`/iaa:orchestrate`** (plugin) | `$iaa` | `$iaa` (skills-dir) · **`/orchestrate`** Command (plugin; ZCode commands are flat, unprefixed) |
| Auto-trigger | description-matched skill `iaa` (both forms) | implicit description-based | per-turn description injection (≤250 chars) |
| Extra integration | spawn-depth=1 env key (managed) | none (pre-existing `[agents]` config untouched) | none |
| Adapter notes | Explore/Plan don't inherit CLAUDE.md → restate constraints in briefs; pre-dispatch mode check | explorer/worker/default; fresh-context spawns preferred; nesting policy-only | Explore lacks AGENTS.md injection → restate; nesting platform-impossible |

## Facts that matter for reasoning about the integrations

- The **entry points are adapters, not second implementations**: the
  `orchestrate` skill/command bodies are ~5-line pointers that delegate to the
  byte-identical bundled `iaa` skill (parity-enforced).
- Explicit invocation never mandates agents: a trivial task given to
  `/iaa:orchestrate` still gets the zero-agent fallback (validated, Gate 2).
- Exactly **one form per runtime** — installing both skills-dir and plugin
  forms of İAA is a duplicate-install error (`iaa doctor` flags it).
- Per-task opt-out phrase: "Do not delegate or spawn subagents for this task."
- ZCode's ~250-char description injection budget is CI-enforced at the
  packaging layer.

**Stable file** — current tested runtime versions, package versions, and
per-form claim statuses live in `11-CURRENT-STATE.md` and GitHub
`docs/COMPATIBILITY.md` (both honesty-graded: TESTED / PARTIALLY TESTED /
STRUCTURALLY COMPATIBLE / UNVERIFIED).
