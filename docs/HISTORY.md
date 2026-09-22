# History

Condensed from audit/02 (full chronology, hash lineage, and evidence citations there).

- **2026-08-26 (early hours)** — Codex MultiAgentV2 native capabilities audited live
  (ADR-0000): spawn/send/followup/wait/interrupt/list tools, fork isolation, roles,
  concurrency. Design research preceding installation.
- **2026-08-26 17:39–17:54** — İAA v0 installed for Codex CLI 0.149.1, Claude Code 2.1.246,
  ZCode 3.7.7: canonical dir + 3 relative symlinks + 3 managed shims + managed Claude
  spawn-depth=1; `manage.sh` lifecycle validated incl. fake-home; Codex behavioral smoke
  A–E passed (after one policy tightening: no manufactured reviewer on trivial tasks).
- **2026-08-27 00:55–06:28 — Campaign 1 (collision smoke test).** First behavioral test of
  İAA vs co-loaded SDD on glm-5.3: İAA kept topology authority; SDD's review cadence and
  no-parallel rule leaked; ~2.5× cost. PARTIAL PASS (ADR-0001).
- **2026-08-27 07:39–08:47 — Campaign 1b (prose post-fix).** Four attempts; attempt 3 vs 4
  proved identical policy text yields opposite outcomes across samples ⇒ prose precedence is
  unreliable. PARTIAL PASS; "no instruction arms race."
- **2026-08-27 10:24–15:22 — Campaign 2 (structural archfix, v1→v2).** "Orchestration
  modes" + sole-authority description + shim routing sentence + scenarios J/K. Tests A1/A2/B/C:
  SDD never loads in İAA mode (3/3), native opt-in intact (15 agents). PASS (ADR-0002).
- **2026-08-27 16:22–21:20 — Campaign 3 (artifact boundary, v2→v3).** Provenance rule +
  adapter extension; authentic adversarial plan fixture; tests B/C/D incl. strengthened
  "MUST use SDD" wording. PASS (ADR-0003).
- **2026-08-27 21:20 → 2026-09-22** — canonical tree quiescent; no further source changes.
- **2026-09-06** — production usage: LCO fifth-audit program executed under İAA adaptive
  mode (3 parallel read-only Explore investigators in isolated worktrees → primary-authored
  plan → primary sequential TDD implementation), documented in
  `isakli05/llm_council_orchestrator` `audit-output/**/01-BASELINE-AND-MAO-TOPOLOGY.md`
  (foreign-repo filename, unchanged there; it used the product's pre-rename name MAO).
- **2026-09-22** — this baseline audit: footprint inventory, provenance reconstruction
  (v0→v3 hash-proven), architecture/behavioral-contract reconstruction, source-of-truth
  verdict, migration into this repository (byte-exact copy; live integrations untouched),
  documentation and web knowledge pack, publication-safety audit, GitHub baseline (private).

## Version table

| Version | Date | sha256 (8) | Defining change |
|---|---|---|---|
| v0 | 2026-08-26 17:54 | `38128852` | initial install (prose-precedence era) |
| v1 | 2026-08-27 08:47 | `1a04e5e9` | prose post-fix (review/sequencing ownership) — failed approach, superseded |
| v2 | 2026-08-27 10:28 | `0d3ea454` | structural mode separation (ADR-0002) |
| v3 (current) | 2026-08-27 16:22 | `fee98091` | artifact trust boundary (ADR-0003) |
