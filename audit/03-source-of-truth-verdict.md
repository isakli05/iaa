# Audit 03 — Source-of-Truth Verdict

Issued 2026-09-22 after Phases 0–3, on the evidence of audit/01 (footprint) and audit/02
(provenance). Every classification below is evidence-backed; none required a judgment call
between competing candidates, because no competitor exists on this machine.

## Verdict

**Authoritative MAO source today (FACT):**

```
/home/isa/.local/share/ai-agent-orchestration/
├── README.md                                        ← project-level doc (canonical)
└── multi-agent-orchestration/
    ├── SKILL.md                                     ← THE policy (v3, fee98091…)
    ├── references/delegation-contract.md
    ├── references/platform-adapters.md
    ├── scripts/manage.sh
    └── tests/scenarios.md
```

Why: (1) all three live runtime symlinks resolve here; (2) the managed shims installed by
its own installer are live; (3) hash lineage proves it is the latest of a strictly linear
v0→v3 chain; (4) no other copy on disk is newer or divergent; (5) production use (LCO,
2026-09-06) ran against exactly this installation; (6) it has been quiescent and internally
consistent since 2026-08-27 16:22.

**Runtime installation material (not source):** the three symlinks, the three managed shim
blocks, `~/.config/ai-agent-orchestration/claude-depth.state`, and the managed
`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` entry in `~/.claude/settings.json`. All are
*outputs* of `manage.sh install` and are reproducible from canonical at any time.

**Generated artifacts:** none in canonical (no generated files). Campaign trees' `runs/`,
`repos/`, `transcripts/`, `generated-PLAN.md` are generated test artifacts — evidence class.

**Historical evidence (must remain untouched for provenance):**
- `/home/isa/mao-sdd-archfix-20260827/` — campaign 2 (structural separation), PASS
- `/home/isa/mao-sdd-artifact-boundary-20260827/` — campaign 3 (artifact boundary), PASS
- `/home/isa/collision-smoke-test-evidence/` (+ `~/collision-smoke-test-report.md`, `.zip`)
  — campaign 1 (collision) + 1b (prose post-fix), PARTIAL PASS ×2
- MAO-named backup files (9 instruction-file backups + 1 settings backup), install-era
- `~/.codex/diagnostics/native-multi-agent-audit-20260826-020733.md`
- Session metadata dirs under `~/.claude/projects/` (collision/archfix/boundary runs)
- `~/projects/llm_council_orchestrator/**` MAO-topology docs (production usage record)

**Archival (local-only, do not publish raw):** campaign `transcripts/`, `runs/` JSONs,
`repos/`, the evidence `.zip`, session dirs. They contain conversation transcripts, cost
data, model/provider names, and machine paths (see audit/05 publication safety).

**Redundant:** nothing destructive to remove; the ancestor snapshots (`policy-*-SKILL.md`,
`*.before`) are redundant *as source* but essential *as lineage* — keep in place.

**Divergent:** none. No forks exist.

**What must NOT be treated as source:** everything in the three evidence trees except the
diffs/snapshots' documentary value; `.superpowers/sdd` dirs in user projects (Superpowers
artifacts); LCO audit docs (usage records).

## Gap items the maintained project should absorb (from evidence → source)

1. `analyze_run.py` (test-transcript analysis tool) — exists only in campaign trees.
2. The v0→v3 diffs — the only surviving record of pre-git evolution; belong in the repo as
   history (small, clean).
3. Campaign FINAL-REPORTs ×3 + collision report — condense to ADRs; raw copies optional
   (they are already secret-free — verified in Phase 8 — but long).

## Migration decision (feeds Phase 5)

Canonical has **no version control**; its only history is the evidence trees. The safe
migration is therefore **in-place history capture, not relocation**: initialize the
maintained project at `/home/isa/projects/multi-agent-orchestration` as a git repository
containing the canonical tree (copied byte-exact, hashes re-verified), leaving the live
canonical directory and all three symlinks untouched. A relocation would gain nothing
(single consumer path already correct) and would risk the only live integration surface —
violating the task's own migration-safety rules. The canonical directory remains the
runtime source; the project repo becomes the versioned source of truth for *maintenance
and publication*, synchronized by copy + hash check (documented procedure), until a later
decision changes install layout.

Alternative considered and rejected: moving canonical into the project and symlinking back.
Rejected for this baseline task — it mutates the live integration path with zero provenance
benefit while the audit's mandate is freeze-and-document.
