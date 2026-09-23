# 00 — READ ME FIRST (İAA knowledge pack)

This pack describes **İAA — İştirak-i A‘mâl-i Ajanîye** exactly as it exists on the owner's
machine on **2026-09-22** — a frozen, audited baseline. It exists so a fresh model with no
prior context can understand İAA accurately.

**How to treat this pack:**
- `sources/` files are **verbatim copies of the repository canonical source**
  (`iaa/` in the maintained repo; the runtime tree is a deployed projection) —
  authoritative.
  Where any summary and a source file disagree, the source file wins.
- Numbered docs (01–09) are explanations written during the audit, every claim sourced.
- `10-COMPARISON-RESEARCH-BRIEF.md` defines a *future* comparison task — it does NOT
  perform it and contains no conclusions about other systems' quality.
- Nothing here claims İAA is better or worse than SDD/GSD/BMAD/etc. That is the next task.

**Key terminology:**
- **İAA** — the `iaa` skill: a delegation-decision policy installed
  globally for Claude Code, OpenAI Codex CLI, and ZCode.
- **Adaptive mode / İAA mode** — İAA's default: primary agent adaptively decides whether
  and how to delegate; no fixed roster/cadence.
- **Native workflow mode** — a user-explicitly-named alternative workflow (e.g. Superpowers
  SDD) that then governs itself; İAA stands down.
- **SDD** — `superpowers:subagent-driven-development`, a fixed-cadence orchestration skill
  from the installed Superpowers plugin (6.3.0 locally; 6.4.1 upstream).
- **Shim** — a marker-delimited managed block İAA's installer writes into each runtime's
  global instruction file (CLAUDE.md / AGENTS.md).
- **The three evidence trees** — read-only local directories holding the 2026-08-27 test
  campaigns that produced İAA's current boundary rules (see 07).

**Reading order:** 01 → 02 → 03 → 05 → 06 → 07 → 08 → 09 → 04 (file map) → 10 (only if
doing the comparison). Skim `sources/SKILL.md` early — it is short and is the actual
policy.
