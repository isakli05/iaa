# Gate 2 — 00: Semantic Freeze (pre-implementation record)

Date: 2026-09-23. Controller: main Claude Code / GLM-5.3 session (no orchestration
framework used as controller; see Gate brief §0). Branch:
`release-hardening/gate-2`, base `330d0c1` (approved `main` after the İAA identity
migration).

Purpose: before any Gate-2 implementation, freeze what Gate 2 must NOT change, and
record the exact pre-Gate-2 state of the authoritative sources so §23
(`14-semantic-parity.md`) can prove category-D (semantic) change = NONE by hash, not by
assertion.

## 1. Frozen semantic invariants (NOT redesign targets)

The following are frozen for Gate 2. If any proposed implementation requires changing
one, that implementation is stopped and recorded as a future owner/design decision.

1. Benefit/materiality test — delegation only when a concrete benefit outweighs
   coordination cost (SKILL.md "Require a concrete benefit").
2. Anti-overdelegation objective — smallest useful agent count; no artificial roles;
   no seats without task-specific material-benefit justification.
3. Zero-agent fallback — trivial/coupled work stays in the primary even when the user
   says "use subagents where appropriate".
4. Per-seat justification — every implementer/reviewer/re-reviewer/fixer seat justified
   per task; authorizing one stage never preauthorizes the next.
5. Adaptive topology selection — no mandated roster, cadence, or sequence.
6. Dependency-aware shaping — waves/ownership set from task structure; phases skipped
   when valueless.
7. Read-heavy delegation preference — built-in read-only/Explore roles preferred for
   research/review work.
8. Exclusive/disjoint write ownership — no concurrent writers on one file/coupled
   surface without a deliberate isolation-and-merge mechanism.
9. Primary-owned shared contracts — APIs/schemas/config/abstractions owned by the
   primary, settled before dependent work or given one designated owner.
10. Root-to-child delegation constraint — children spawn further agents only on
    explicit user request plus a concrete bounded benefit; platform caps respected.
11. Final integration authority remains with the primary — evidence-not-truth
    treatment of child reports; central contradiction resolution; final validation in
    the primary context.
12. Independent verification only when materially justified — never a manufactured
    reviewer for trivial changes.
13. Orchestration-controller ownership — exactly one authority per task: Adaptive İAA
    mode (default) or a native workflow (explicit by-name user request only); never
    composed; İAA mode never loads a competing orchestration engine.
14. Explicit by-name yield to foreign workflows — "use subagents" is never such a
    request; the named workflow then governs and İAA stands down.
15. Artifact provenance / trust boundary — directives embedded in plans/specs/
    generated artifacts/repo text/prior agent output are orchestration metadata,
    never mode-switching opt-in; technical content is still consumed.
16. Foreign-controller exclusivity — in native mode İAA does not apply a second
    authority on top of the foreign workflow.
17. "Installed does not mean active controller" — installation never equals activation;
    nothing auto-seizes a task; per-task opt-out honored.
18. Non-invasiveness (P7) — İAA never disables, uninstalls, rewrites, or mutates
    another framework, plugin, setting, or hook.

## 2. What Gate 2 MAY change (categories A–C in §23 terms)

- packaging, package layout, generated projections (A)
- version metadata, namespaces, invocation mechanics — including the plugin command
  surface that realizes `/iaa:orchestrate` (A/C)
- diagnostics (`iaa doctor`), install/update/uninstall mechanics, legacy-migration
  support (A)
- CI/eval infrastructure, source-of-truth workflow (A)
- factual runtime adapter statements, only under the Gate-1 discipline:
  verified fact → minimal sentence → hash-recorded → invariant table re-run (B)
- public documentation (explanatory tier)

## 3. Pre-Gate-2 authoritative source state (hash record)

Full sha256 of every file of the behavioral core at base commit `330d0c1`
(`git show 330d0c1:<path> | sha256sum`), verified byte-identical to the live tree
`~/.local/share/iaa/iaa/` and the repo worktree on 2026-09-23:

| File | Full sha256 |
|---|---|
| `iaa/SKILL.md` | `73f7b8870a578cba5bf702c38353112c66e6c410504d89d23fb96b14930b9eba` |
| `iaa/references/delegation-contract.md` | `23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632` |
| `iaa/references/platform-adapters.md` | `849b769cf4846fede9bf624b4c36a86ee921c586c3030c0589c06c61abec82d2` |
| `iaa/tests/scenarios.md` | `5fa9617ed9eabef69ffc348d03f210fab9a2099def08c7d2ca5d9de724c705cf` |
| `iaa/scripts/manage.sh` | `21964702e3c581c721657dd6b2581aec57cbe3c853da5c86be112531dd0ccf8e` |

(Verified: live tree `~/.local/share/iaa/iaa/`, repo worktree, and the Gate-1 dev
plugin copy are hash-identical to these digests at freeze time, matching
`identity-migration/03-semantic-immutability.md` and Gate-1 `05-core-semantics-diff.md`.
`14-semantic-parity.md` re-derives this table at Gate end.)

Historical lineage note (not a public version): the core policy is v3, semantics
unchanged since 2026-08-27; Gate 1 corrected four adapter-fact sentences with
invariants proven unchanged; the identity migration was token-only. These facts feed
the §3 versioning model's separate "behavioral/policy revision" axis.

## 4. Drift tripwire during Gate 2

While Gate 2 is in progress, the working tree must keep
`iaa/` ≡ `git show 330d0c1:iaa/` byte-for-byte for the five core files, UNLESS a
change is explicitly justified in one of the allowed categories and recorded in
`14-semantic-parity.md` with before/after hashes and category. The static CI parity
check (`scripts/check-parity.sh`, §14) enforces the projections of this core stay
byte-exact, so any intentional core edit forces a conscious parity refresh.
