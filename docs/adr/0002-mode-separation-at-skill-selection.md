# ADR-0002 — Structural separation: two orchestration modes, selected at skill-load time

Date: 2026-08-27 (campaign 2). Status: accepted — this IS current İAA behavior.
Raw evidence: `~/mao-sdd-archfix-20260827/` (local); exact diffs in
`historical-notes/v0-v3-lineage/`.

## Decision

Replace in-context precedence with per-task mutual exclusion, enforced at selection level:

1. **Adaptive İAA mode (default):** any delegation-flavored request selects İAA alone; SDD
   (and any roster/cadence/sequencing-prescribing skill) is *not loaded*. Compatible
   Superpowers component skills remain individually usable (whitelist of 8; the 2
   seat-prescribing ones only execute pre-authorized lanes).
2. **Native workflow mode:** only an explicit, by-name user request; the named workflow then
   governs itself and İAA stands down entirely.

Enforcement surfaces: İAA frontmatter description (sole-authority routing, 247 chars —
bounded by ZCode's ~250-char injection limit), the "Orchestration modes" SKILL section, the
managed shim's final sentence (all three runtimes; installer re-ran → 3rd backup set), and
the Claude adapter's pre-dispatch mode check. Superpowers files untouched; the routing rule
rides the user-instruction channel, which Superpowers' own bootstrap defers to.

Rejected alternatives: (a) an integration/bridge skill (duplicates existing coverage);
(b) partial import (not supported); (c) disabling SDD plugin-wide (destroys opt-in mode).

## Validation

Tests A1/A2 (İAA mode: SDD never loaded in 2 samples; 3+3 parallel implementers; 0
reviewers; $2.90/$2.91 vs $9.57 co-loaded), B (native opt-in: full SDD cadence, 15 agents,
İAA absent), C (no agent wording: all-primary). Transcripts quote the model rejecting the
`executing-plans`→SDD redirect citing the shim sentence. Verdict PASS.

## Consequences

- Co-loading is eliminated in tested samples; residual risk is a routing violation (visible,
  regression-testable via scenario J) instead of silent leakage.
- `writing-plans`-generated plans still embed SDD directives → led to ADR-0003.
- Codex/ZCode got the same shim text for consistency; not behaviorally re-tested there.
