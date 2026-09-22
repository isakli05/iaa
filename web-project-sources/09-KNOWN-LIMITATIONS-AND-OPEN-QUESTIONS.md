# 09 — Known Limitations and Open Questions

## Limitations (evidence-backed; full list in repo docs/KNOWN-LIMITATIONS.md)

**Authority model**
1. Boundary is instruction-following, not harness-enforced; a future model could mis-route
   (made visible + regression-testable, not impossible). Claude Code doctrine: prose is "a
   request, not a guarantee."
2. One-directional: MAO knows Superpowers; Superpowers doesn't know MAO. Upstream changes
   re-open the contest until the documented upgrade-check runs. (Upstream is now 6.4.1 vs
   installed 6.3.0 — check pending.)
3. Codex nesting guard is policy-only (config max_depth ignored by MultiAgentV2).
4. Provenance rule proven for plans only; other artifact channels share wording, untested.

**Coverage**
5. Scenarios F/H/I never run as controlled tests; authorized nesting never exercised.
6. Codex/ZCode not behaviorally re-tested post-campaigns; ZCode needs desktop UI.
7. Single model family evidence (glm-5.3 on Claude; GPT-5.6-sol only for the pre-install
   native audit).
8. verify() checks description ≤1024 B but the operative ZCode constraint is ~250 chars.

**Packaging**
9. Un-namespaced user-scope skill name — shadowing possible if another same-named skill
   appears (public-distribution problem; design exists, not implemented).
10. No version field in the skill; lineage tracked by hash + repo only.
11. Installer assumes one user/one machine (fake-home tested, but not a multi-user design).
12. Live tree not version-controlled in place (repo copy + sync procedure instead).

**Environment**
13. ZCode carries stale Superpowers 6.2.0 with a broken internal symlink (upstream artifact).
14. Install-session transcript lost (actions reconstructed; see 07).

## Open questions (for the comparison/design phase — deliberately unanswered here)

- Is MAO's adaptive-materiality model genuinely differentiated vs SDD/GSD/BMAD/native
  primitives, or do others now cover it? (→ 10-COMPARISON-RESEARCH-BRIEF.md)
- Should the public build add mechanism-grade enforcement (SessionStart context-append
  hook, Codex allow_implicit_invocation tuning) — and can that be done without violating
  MAO's own non-invasiveness principle?
- Plugin packaging for all three stores (all now have official plugin systems; ZCode even
  accepts Claude manifests): does the load-bearing CLAUDE.md/AGENTS.md shim survive
  plugin-form distribution, or does distribution stay script-based?
- How should MAO behave toward GSD's hook guards and Claude Agent Teams (both untested,
  both structurally different: mechanism-grade / multi-instance)?
- Trigger model for public: keep hybrid (status quo), go explicit-only, or runtime-tuned?
- Should authorized nested delegation ever be a first-class path, or stay discouraged?
