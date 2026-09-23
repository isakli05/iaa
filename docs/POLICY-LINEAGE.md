# Policy Lineage (behavioral/policy revision axis)

This is the **behavioral revision history** of the İAA delegation policy — a
separate axis from the public package version (`VERSION`,
[versioning model](../release-hardening/gate-2/01-versioning-model.md)). The
package version says which distribution artifact you have; this page says which
*semantics* it carries.

| Revision | Date | What changed | Evidence |
|---|---|---|---|
| v0 | 2026-08-26 | First skill: broad proactive description + open delegation policy | `historical-notes/v0-v3-lineage/` |
| v1 | 2026-08-26 | Sole-authority boundary drafted after the first SDD co-load collision | campaign 1 |
| v2 | 2026-08-26/27 | Boundary hardening: provenance rule, explicit-by-name native mode, description narrowed | campaigns 2–3 |
| **v3 (current)** | 2026-08-27 | Final boundary shape: "installed does not mean active controller", whitelist of compatible Superpowers components, per-seat justification language | archfix/artifact-boundary campaigns (ADR-0001–0003) |

**Since v3, semantics are unchanged.** Later changes were provably not
semantic:

- 2026-09-22/23 (Gate 1): four adapter-fact sentences corrected (Codex
  `fork_turns` syntax; the removed `executing-plans`→SDD redirect) — invariants
  table re-run, all ten unchanged (`release-hardening/05-core-semantics-diff.md`).
- 2026-09-23 (identity migration): MAO→İAA token-only rename;
  normalized-diff proof of byte-equivalence
  (`identity-migration/03-semantic-immutability.md`).
- 2026-09-23 (Gate 2): packaging, invocation mechanics, diagnostics, CI only —
  core files byte-identical
  (`release-hardening/gate-2/14-semantic-parity.md`).

`iaa doctor` reports this axis as `policy revision v3`. A future semantic
change must bump this revision here AND justify itself against the frozen
invariant list before any package version ships it.
