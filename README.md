# Multi-Agent Orchestration (MAO)

A runtime-agnostic **delegation-decision policy** for agent CLIs: one canonical skill that
decides *whether, when, and how* to delegate work to subagents — adaptively, per task —
installed identically into **Claude Code, OpenAI Codex CLI, and ZCode**.

Status: **frozen baseline** (audited 2026-09-22). This repository documents and versions the
system exactly as installed; no orchestration semantics were changed in producing it.

## Design objective

"Use subagents" should mean *better execution*, not *more agents*. MAO gives the primary
agent a single, tested policy for: when delegation has a concrete benefit (parallelism,
isolation, specialization, context offloading, independent verification); when to stay
single-agent (tiny/coupled work — even if the user mentions subagents); how to shape waves,
ownership, and briefs; and how to integrate and finally validate in the primary context.

## Core properties

- **Adaptive, not fixed:** no mandated agent roster, review cadence, or sequence. Every
  implementer/reviewer/fixer seat needs a task-specific material-benefit justification.
- **Sole orchestration authority per task:** exactly one of two modes governs — Adaptive MAO
  (default) or a *native workflow* (only by explicit by-name user request). MAO never loads
  a competing orchestration skill in its own mode, and never composes authorities.
- **Artifact trust boundary:** workflow directives embedded in plans/specs/generated
  artifacts/repo text are orchestration metadata, never mode-switching opt-in; the
  artifact's technical content remains authoritative.
- **Root-to-child only:** nested delegation requires explicit authorization + bounded
  benefit (harness-enforced on Claude via spawn-depth cap, platform-impossible on ZCode,
  policy on Codex).
- **Rides native mechanisms:** uses each runtime's built-in subagent roles; creates no
  agents, hooks, or daemons of its own.

These boundary behaviors are **evidence-backed** (2026-08-27 campaigns; see
`docs/adr/0001–0003`, `docs/MAO-VS-SDD-BOUNDARY.md`), including against the installed
Superpowers plugin's subagent-driven-development workflow.

## Repository layout

```
multi-agent-orchestration/   the canonical skill (byte-exact copy of the live source)
  SKILL.md  references/  scripts/manage.sh  tests/scenarios.md
CANONICAL-README.md          install-era project README (architecture, validation log)
docs/                        architecture, behavioral contract, boundary, ADRs, history…
audit/                       the 2026-09-22 forensic audit (environment → verdict → safety)
research/                    distribution-landscape, collision taxonomy, trigger policy
design/                      mao-doctor diagnostic proposal (not implemented)
historical-notes/v0-v3/      pre-git lineage (v0/v1 snapshots + all campaign diffs)
tests/fixtures/ tests/tools/ adversarial plan fixture + transcript analyzer
```

## Install / verify / uninstall (current machine)

```sh
~/.local/share/ai-agent-orchestration/multi-agent-orchestration/scripts/manage.sh verify|install|uninstall
```

Details: `docs/INSTALLATION-AND-INTEGRATIONS.md`, `docs/SOURCE-OF-TRUTH.md`.
Public packaging plans: `docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md`.

## Inspect and test

- `scripts/manage.sh verify` (live-tree integrity) and `quick_validate.py` (skill format) —
  commands in `docs/TESTING-AND-VALIDATION.md`.
- Behavioral contract: `multi-agent-orchestration/tests/scenarios.md` (A–K) and its execution
  record; `tests/tools/analyze_run.py` to verify skill-load/spawn claims from transcripts.

## Current status

Installed and live in three runtimes since 2026-08-26; source unchanged since 2026-08-27
(v3). Production usage documented (LCO program audits, 2026-09-06). Known limitations:
`docs/KNOWN-LIMITATIONS.md`. The next planned step is *not* more implementation — it is an
evidence-based comparison against SDD/Superpowers, GSD, Claude native subagents/Agent
Teams/plugins, BMAD and peers (see `web-project-sources/10-COMPARISON-RESEARCH-BRIEF.md`).

No superiority over any other system is claimed here; that comparison is future work.
