# 02 — Current Architecture (condensed; full version in the repo docs/)

Sources: `sources/SKILL.md` (the policy), `sources/references-*.md`, `sources/CANONICAL-README.md`.

## Shape

```
~/.local/share/iaa/            ← deployed runtime source (projection of the repo)
├── README.md
└── iaa/{SKILL.md, references/2, scripts/manage.sh, tests/scenarios.md}
        ↑ symlinked from ~/.claude/skills, ~/.zcode/skills, ~/.agents/skills (Codex)
~/.claude/CLAUDE.md, ~/.codex/AGENTS.md, ~/.zcode/AGENTS.md   ← identical 2-para managed shim each
~/.claude/settings.json → CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1 (managed, marker-owned)
~/.config/iaa/claude-depth.state ("managed-absent")
```

manage.sh = install/verify/uninstall only: marker-validated shim writes (backup-first,
idempotent), self-owned symlinks (never replaces foreign ones), depth key owned only if it
was absent pre-install. Uninstall removes only its own artifacts.

## Execution model (what the primary agent does under İAA)

1. **Mode gate (first):** delegation-flavored request → Adaptive İAA mode; explicit
   by-name workflow request → that workflow governs (İAA absent). Artifacts can't switch
   modes. In İAA mode: SDD never loads; 8 whitelisted Superpowers component skills may
   still be used individually; 2 seat-prescribing components only execute pre-authorized
   lanes.
2. **Interpret intent:** "use subagents" = apply policy, not maximize agents.
3. **Orient proportionately** (obey project retrieval policies first, e.g. graphify).
4. **Benefit test:** ≥1 of parallelism / bounded isolation / specialization / context
   offloading / independent verification — else stay primary (trivial + coupled work stays
   primary *even when the user mentions subagents*).
5. **Shape:** read-heavy = safest (prefer read-only/Explore roles); write-heavy = disjoint
   exclusive write sets, shared contracts primary-owned/settled first; dependency-aware
   waves, skip useless phases.
6. **Dispatch:** brief per the delegation contract (objective/scope/non-scope/context/
   dependencies/ownership/deliverable/validation/constraints + "Do not spawn subagents");
   root-to-child only; capability classes not model names; primary works meanwhile.
7. **Integrate:** child reports are evidence; verify load-bearing claims; resolve
   contradictions centrally; final validation in primary context.

## Platform adapters (mechanism mapping only)

- **Codex:** explorer/worker/default built-ins; fresh-context spawns (fork_turns none) by
  default; runtime steering; nesting = policy-only.
- **Claude:** Explore/Plan/general-purpose; pre-dispatch mode check; Explore/Plan don't
  inherit CLAUDE.md → restate constraints in briefs; spawn depth harness-capped at 1.
- **ZCode:** Explore (no AGENTS.md injection → restate) / general-purpose; nesting
  platform-impossible; custom agents beta (not used).

## Key asymmetries worth knowing for comparison

- İAA has **no SessionStart hook** (Superpowers injects a bootstrap every session); İAA's
  routing rides the user-instruction channel, which Superpowers' own bootstrap defers to.
- Enforcement grade: İAA = behavioral instruction-following (+1 harness env cap on Claude);
  GSD-style systems use PreToolUse guard hooks; ZCode nesting is platform-impossible.
- İAA is policy-only: no persistent state, no ledger/workspace, no per-task commits, no
  scripts at execution time (contrast SDD's ledger/brief/review-package scripts).
