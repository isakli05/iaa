# 09 — Known Limitations and Open Questions

Live authority: `docs/KNOWN-LIMITATIONS.md` on GitHub (frozen baseline with
Gate-2 status notes). This file condenses the current state of each item —
several once-open items are resolved and are marked so, not silently dropped.

## Limitations (evidence-backed, current)

**Authority model**
1. **Instruction-following, not harness enforcement.** Mode routing and the
   provenance rule are policy; skill selection is model-driven and fallible
   (official doctrine). Made a *single visible routing violation* by the fix,
   detectable by scenario J — not impossible.
2. **One-directional boundary.** İAA knows Superpowers; Superpowers doesn't
   know İAA. Upstream changes re-open the contest until the upgrade-check
   runs (standing item IAA-BL-010; 6.4.1 check completed in Gate 1).
3. **Codex nesting guard is policy-only** (config `max_depth` ignored by
   MultiAgentV2); Claude is harness-enforced, ZCode platform-impossible.
4. **Provenance rule proven for plan artifacts and repository files**;
   content pasted into the user's own message is the user's instruction —
   out of scope by owner decision, and users name the workflow they want
   (IAA-BL-004 closed; observed routing either way, recorded).

**Coverage / validation**
5. Scenarios F, H, I never executed as controlled tests; authorized-nesting
   positive path never exercised (→ IAA-BL-003, IAA-BL-015).
6. ZCode needs the desktop UI for live checks (no headless CLI); Codex/ZCode
   not behaviorally re-tested after the Aug-27 campaigns until the Gate-2/3
   legs (Codex plugin-form live discovery + E9 probe 2026-09-23; ZCode
   skills-dir historical production use; ZCode plugin form GUI-accepted at
   0.1.1/3.14.3).
7. **Single-model evidence** (GLM-5.3 profile; install-time GPT-5.6-sol only
   for the pre-install audit) — no other family sampled (→ IAA-BL-007).
8. ~~verify() 1024-B check vs ZCode ~250-char budget~~ **RESOLVED (Gate 2):**
   the packaging layer enforces the 250-byte budget in CI.

**Packaging / distribution**
9. ~~Un-namespaced skill shadowing (public-distribution problem)~~
   **RESOLVED (Gate 2/3):** public distribution ships namespaced plugin
   packages; duplicate installs are a doctor-flagged error; the instruction
   shim installs via the explicit reversible integration step.
10. Skill carries no version field ~~(hash+repo lineage only)~~ — packages
    now stamp `VERSION` into manifests and carry PROVENANCE files; lineage
    semantics still tracked by policy revision.
11. Installer assumes one user / one machine (fake-home tested; not a
    multi-user design) — still true, by scope decision.
12. ~~Live tree not version-controlled in place~~ **RESOLVED (Gate 2):** the
    repository `iaa/` is authoritative; the live tree is a deploy projection
    (`scripts/iaa deploy`), and direct edits to it are detectable drift.

**Environment facts (constraints, not defects)**
13. ZCode 3.14.x provider bug (zai-org/feedback#699): model requests fail
    ETIMEDOUT on IPv4-only networks; a documented temporary single-IPv4
    `api.z.ai` hosts workaround exists (TLS-verified, fully reversible).
    Upstream tracking and the İAA-side action are backlog item IAA-BL-002 —
    check its live state before assuming the bug still applies.

## Open questions (remaining; all tracked in docs/BACKLOG.md)

- Should İAA ever add mechanism-grade self-controls (e.g. a read-only
  reporting hook) — and can that avoid violating non-invasiveness?
  (Constrained by governance; comparison §14: the deficit is instrumentation,
  not enforcement.)
- How does İAA behave toward GSD's trigger surface and Agent Teams if a user
  enables them? (UNVERIFIED; characterization candidates IAA-BL-005/009.)
- Should authorized nested delegation ever be first-class, or stay
  discouraged? (IAA-BL-015.)
- Can a typed decision backend (JEV) improve decision reliability without
  becoming a dependency? (Research candidate IAA-BL-006; benchmark first.)

## Resolved questions (recorded; do not reopen without new evidence)

- ~~Comparison vs SDD/GSD/BMAD/native~~ — done 2026-09-22: four
  differentiators confirmed, no counter-finding (`comparison/`).
- ~~Plugin packaging for all three stores vs script distribution~~ — resolved
  Gate 2: both; "plugin distributes, script integrates."
- ~~Trigger model (hybrid vs explicit-only)~~ — resolved Gate 2 on
  measurement: hybrid retained (68-session characterization: 0/13 false
  positives, 6/6 yields, explicit entry 3/3).

**Stable file** — current statuses are read live from GitHub
(`docs/KNOWN-LIMITATIONS.md`, `docs/BACKLOG.md`).
