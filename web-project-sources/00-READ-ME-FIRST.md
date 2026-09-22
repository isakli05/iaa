# 00 — READ ME FIRST (MAO knowledge pack)

This pack describes **MAO (Multi-Agent Orchestration)** exactly as it exists on the owner's
machine on **2026-09-22** — a frozen, audited baseline. It exists so a fresh model with no
prior context can understand MAO accurately.

**How to treat this pack:**
- `sources/` files are **verbatim copies of the live canonical source** — authoritative.
  Where any summary and a source file disagree, the source file wins.
- Numbered docs (01–09) are explanations written during the audit, every claim sourced.
- `10-COMPARISON-RESEARCH-BRIEF.md` defines a *future* comparison task — it does NOT
  perform it and contains no conclusions about other systems' quality.
- Nothing here claims MAO is better or worse than SDD/GSD/BMAD/etc. That is the next task.

**Key terminology:**
- **MAO** — the `multi-agent-orchestration` skill: a delegation-decision policy installed
  globally for Claude Code, OpenAI Codex CLI, and ZCode.
- **Adaptive mode / MAO mode** — MAO's default: primary agent adaptively decides whether
  and how to delegate; no fixed roster/cadence.
- **Native workflow mode** — a user-explicitly-named alternative workflow (e.g. Superpowers
  SDD) that then governs itself; MAO stands down.
- **SDD** — `superpowers:subagent-driven-development`, a fixed-cadence orchestration skill
  from the installed Superpowers plugin (6.3.0 locally; 6.4.1 upstream).
- **Shim** — a marker-delimited managed block MAO's installer writes into each runtime's
  global instruction file (CLAUDE.md / AGENTS.md).
- **The three evidence trees** — read-only local directories holding the 2026-08-27 test
  campaigns that produced MAO's current boundary rules (see 07).

**Reading order:** 01 → 02 → 03 → 05 → 06 → 07 → 08 → 09 → 04 (file map) → 10 (only if
doing the comparison). Skim `sources/SKILL.md` early — it is short and is the actual
policy.
