# Known Limitations (frozen baseline, 2026-09-22; status notes added 2026-09-23 Gate 2; reconciled with Gate 2/3 evidence 2026-09-24 — IAA-BL-018)

Genuine, evidence-backed limitations only. No invented improvement work.
Items whose status changed in Gate 2 carry a **[Gate-2 update]** note; the
original 2026-09-22 text is preserved.

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
   **[Status 2026-09-24]** exercised by BL-004 (post-release/bl-004-provenance-channels/):
   artifact and repository-file channels PROVEN (plan artifacts authentic + adversarial;
   README directive 2/2 samples + read-exposure). Pasted content — issue text, quoted
   transcripts, prompts written by another tool — is out of scope by owner decision
   2026-09-24: text the user places in their own message is the user's instruction, and
   users name the workflow they want (observed routing either way; recorded, not a defect).

## Coverage / validation

5. Scenarios F, H, I never executed as controlled tests (TESTING-AND-VALIDATION table);
   authorized-nesting positive path never exercised.
6. Codex and ZCode not behaviorally re-tested after the Aug-27 campaigns; ZCode live checks
   need the desktop UI (no headless CLI). **[Status 2026-09-24]** partially superseded by
   the Gate-2/3 legs: Codex plugin-form live discovery and the E9 probe (2026-09-23,
   release-hardening/gate-3/04-codex-final-validation.md — discovery executed there, E9
   referenced as Gate-2 evidence), and ZCode 0.1.1 plugin form GUI-accepted at 3.14.3
   (release-hardening/0.1.1/02-gui-validation.md). Still untested, precisely: no ZCode
   model-call behavioral evidence at 3.14.3, per docs/COMPATIBILITY.md ("plugin-form GUI
   observation only — no model-call evidence at 3.14.3").
7. All behavioral evidence is from `glm-5.3[1m]` samples via the GLM provider on Claude Code
   2.1.246 + install-time Codex/GPT-5.6-sol; no other model families sampled.
   **[Status 2026-09-24]** the August evidence on 2.1.246 remains accurate as history;
   Gate-1/2/3 evidence ran on Claude Code 2.1.274 with the same GLM-5.3 profile
   (docs/COMPATIBILITY.md tested baseline; release-hardening/gate-2/01-versioning-model.md
   §C); still single-model (IAA-BL-007, docs/BACKLOG.md).
8. `manage.sh verify` description bound (1024 B) ≠ operative ZCode ~250-char injection limit;
   current description (245–249 B) satisfies both, but verify won't catch a future breach of
   the tighter one. **[Gate-2 update]** the packaging layer now enforces the tighter budget:
   `scripts/validate-static.py` (CI) fails any core-skill description over 250 bytes.

## Packaging / distribution (current install model)

9. Single un-namespaced user-scope skill name: safe on this machine, but any same-named
   personal/project/plugin skill creates shadowing (Claude resolution: personal > project;
   plugin namespaced — both load). Public distribution must handle this
   (docs/PUBLIC-DISTRIBUTION-ARCHITECTURE.md). **[Status 2026-09-24]** resolved for the
   public install model: namespaced plugin packages
   (release-hardening/gate-2/03-package-architecture.md), the doctor duplicate-install
   check (release-hardening/gate-2/08-iaa-doctor.md), and the explicit reversible shim
   integration step (`scripts/iaa integrate`; gate-2/08 tests).
10. No version metadata in the skill itself (no version field; lineage tracked only by hash
    and this repo). Installer is idempotent but version-unaware. **[Status 2026-09-24]**
    resolved in part: packages stamp VERSION into every manifest and carry PROVENANCE files
    (release-hardening/gate-2/01-versioning-model.md; 03-package-architecture.md §5–§7);
    the skill file itself still has no version field; semantics remain tracked on the
    separate policy-revision axis (docs/POLICY-LINEAGE.md).
11. Installer hardcodes absolute home-relative paths (`~/.claude`, `~/.codex`, `~/.zcode`,
    `~/.agents`) and shim text inline in `manage.sh`; multi-user/multi-install scenarios
    (e.g., ORCHESTRATION_HOME fake-home) exist and were tested, but the design assumes one
    user, one machine.
12. Live canonical tree is not version-controlled in place; history lives in this repo +
    evidence trees (docs/SOURCE-OF-TRUTH.md sync procedure). **[Status 2026-09-24]**
    resolved: the repository `iaa/` is authoritative; the live tree is a `scripts/iaa
    deploy` projection, and direct edits count as drift detected by `iaa doctor`
    (release-hardening/gate-2/04-source-of-truth-normalization.md; 08-iaa-doctor.md).

## Local environment facts (not defects, but constraints)

13. ZCode carries a stale Superpowers **6.2.0** cache with a broken internal symlink
    (audit/01 §C) — upstream artifact; version skew vs Claude's 6.3.0.
    **[Status 2026-09-24]** re-verified on this machine: the 6.2.0 cache and its broken
    AGENTS.md symlink (target /tmp/zcode-plugin-src-l9PoZx/CLAUDE.md, still wiped) are
    still present; a ZCode-side 6.4.1 cache copy appeared 2026-09-23 alongside it (Claude
    Code itself now at 6.4.1). `iaa doctor` from a main @ f334dc9 checkout: exit 0, 0
    actionable — the stale upstream cache is not İAA state and is not flagged.
14. Session transcript of the original install is not preserved (audit/02 §5 UNRESOLVED);
    install actions are reconstructed from manage.sh + backups + README.
15. README's install-era limitation "Claude Code not logged in" is stale (now authenticated);
    its backup list predates the third (archfix-era) backup set — minor doc drift inside
    CANONICAL-README.md, preserved byte-exact by policy.
16. ZCode 3.14.x provider issue (environment constraint): model requests fail ETIMEDOUT on
    IPv4-only networks — Node `autoSelectFamily` Happy-Eyeballs opens with the dead IPv6
    route, then kills IPv4 connects slower than its 250 ms per-attempt budget. Upstream:
    zai-org/feedback#699 (root cause and controlled A/B, confirmed at 3.14.3:
    post-release/zcode-official/NETWORK-DIAGNOSTIC.md). İAA GUI validation windows used
    the documented temporary single-IPv4 `api.z.ai` `/etc/hosts` workaround
    (release-hardening/0.1.1/02-gui-validation.md; TLS-verified, backed up, restored after
    each window). IAA-BL-002 is CLOSED — the confirming comment on #699 is posted
    (docs/BACKLOG.md); check the upstream issue before assuming the bug still applies.
