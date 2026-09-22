# Known Limitations (frozen baseline, 2026-09-22)

Genuine, evidence-backed limitations only. No invented improvement work.

## Boundary / authority

1. **Instruction-following, not harness enforcement.** Mode routing and the artifact
   provenance rule are natural-language policy. Claude Code's official doctrine: prose is
   "a request, not a guarantee." A future model sample could load SDD in İAA mode — the fix
   made that a *single visible routing violation* (detectable by scenario J / analyze_run.py)
   instead of silent cadence leakage, but it did not make it impossible. Evidence: 3-sample
   variance that defeated the prose fix (ADR-0001) never re-occurred post-fix (6+ samples),
   yet samples ≠ proof.
2. **One-directional boundary.** İAA knows about Superpowers; Superpowers knows nothing about
   İAA. Any upstream change (new redirect, new bootstrap aggressiveness, renamed skills)
   re-opens the contest until the documented upgrade-check runs.
3. **Codex nesting is policy-only.** `max_depth=1` in Codex config is a V1 fallback that
   MultiAgentV2 ignores; on Codex, the no-nested-agents rule rests on briefs + policy. Claude
   is harness-enforced (depth=1); ZCode is platform-impossible.
4. **Tested channels only.** Provenance rule proven for plan artifacts; issue text, READMEs,
   quoted transcripts share the wording but were not exercised (ADR-0003).

## Coverage / validation

5. Scenarios F, H, I never executed as controlled tests (TESTING-AND-VALIDATION table);
   authorized-nesting positive path never exercised.
6. Codex and ZCode not behaviorally re-tested after the Aug-27 campaigns; ZCode live checks
   need the desktop UI (no headless CLI).
7. All behavioral evidence is from `glm-5.3[1m]` samples via the GLM provider on Claude Code
   2.1.246 + install-time Codex/GPT-5.6-sol; no other model families sampled.
8. `manage.sh verify` description bound (1024 B) ≠ operative ZCode ~250-char injection limit;
   current description (245–249 B) satisfies both, but verify won't catch a future breach of
   the tighter one.

## Packaging / distribution (current install model)

9. Single un-namespaced user-scope skill name: safe on this machine, but any same-named
   personal/project/plugin skill creates shadowing (Claude resolution: personal > project;
   plugin namespaced — both load). Public distribution must handle this
   (docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md).
10. No version metadata in the skill itself (no version field; lineage tracked only by hash
    and this repo). Installer is idempotent but version-unaware.
11. Installer hardcodes absolute home-relative paths (`~/.claude`, `~/.codex`, `~/.zcode`,
    `~/.agents`) and shim text inline in `manage.sh`; multi-user/multi-install scenarios
    (e.g., ORCHESTRATION_HOME fake-home) exist and were tested, but the design assumes one
    user, one machine.
12. Live canonical tree is not version-controlled in place; history lives in this repo +
    evidence trees (docs/SOURCE-OF-TRUTH.md sync procedure).

## Local environment facts (not defects, but constraints)

13. ZCode carries a stale Superpowers **6.2.0** cache with a broken internal symlink
    (audit/01 §C) — upstream artifact; version skew vs Claude's 6.3.0.
14. Session transcript of the original install is not preserved (audit/02 §5 UNRESOLVED);
    install actions are reconstructed from manage.sh + backups + README.
15. README's install-era limitation "Claude Code not logged in" is stale (now authenticated);
    its backup list predates the third (archfix-era) backup set — minor doc drift inside
    CANONICAL-README.md, preserved byte-exact by policy.
