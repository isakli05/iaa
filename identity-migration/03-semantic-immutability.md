# 03 — Semantic Immutability Proof (identity-only migration)

Method: byte-compare pre-image (commit `122dcf1`) against post-image (this branch) after
normalizing **only** the identity tokens of §16: `MAO ↔ İAA`, `Multi-Agent Orchestration ↔
İAA — İştirak-i A‘mâl-i Ajanîye`, `multi-agent-orchestration / ai-agent-orchestration ↔
iaa` (plus their documented compounds: `mao-dev↔iaa-dev`, `Multi-agent orchestration↔İAA
orchestration`, `MAO_REPO↔IAA_REPO`, `mao doctor↔iaa doctor`, `mao-core↔iaa-core`).
Scripts: `/tmp/iaa_normdiff.py` (behavioral core, full unified diff) and
`/tmp/iaa_fullnorm.py` (every changed file, line-level residual).

## Behavioral core — normalized diff results

| Surface (pre → post) | Result after normalization |
|---|---|
| `SKILL.md` (modes, provenance rule, trigger policy, benefit test, dispatch, integration) | **IDENTICAL** |
| `references/delegation-contract.md` | **IDENTICAL** (byte-untouched) |
| `references/platform-adapters.md` (Codex/Claude/ZCode mechanics) | **IDENTICAL** |
| `tests/scenarios.md` (behavioral contract A–K) | **IDENTICAL** |
| dev-plugin skill copies (SKILL.md, manage.sh) | **IDENTICAL** to canonical (byte-verified via `diff -r`) |

Therefore the following are provably unchanged: materiality/benefit test, zero-agent
fallback for trivial work, seat-by-seat justification, adaptive topology rules,
dependency/wave handling, ownership model (primary = orchestrator + final integration
authority), integration-over-collection rules, reviewer policy (no manufactured
reviewers), root-to-child constraint, artifact trust boundary (embedded directives are
metadata, never opt-in), explicit foreign-controller yield (native workflow mode only by
by-name user request), SDD boundary semantics.

## Installer (`manage.sh`) — residual diff classification

Normalized diff shows exactly three change classes:
1. **Identity tokens:** state dir `~/.config/ai-agent-orchestration → ~/.config/iaa`,
   markers `managed: multi-agent-orchestration → managed: iaa`, link names
   `skills/multi-agent-orchestration → skills/iaa`, future backups
   `.multi-agent-orchestration-backup-* → .iaa-backup-*`, shim heading/text tokens.
2. **LEGACY additions (§14 allowance):** `LEGACY_*` constants +
   `orchestration_without_legacy_block`, `orchestration_remove_legacy_shim`,
   `orchestration_remove_legacy_links`, `orchestration_migrate_legacy_state`, and their
   call sites in install/uninstall — guarded, backup-first, only touch artifacts that
   resolve to this source, every use labeled LEGACY. No fresh-install behavior differs
   from the pre-rename script except the identity strings themselves.
3. **Nothing else.** Install/verify/uninstall sequencing, marker validation, depth-state
   machine (`managed-absent`/`preserve-existing`), jq handling, symlink relativity, and
   all error paths are line-for-line identical after token normalization.

## Eval/companion harness — residual diff classification

1. `plugin.json` name/description tokens; grader `input_match` regex
   `(?:[\w-]+:)?multi-agent-orchestration → (?:[\w-]+:)?iaa` (assertion mechanics
   unchanged; still matches plain and namespaced forms).
2. Companion script: local variable renames `mao→iaa`, `expect_mao→expect_iaa`
   (identifier identity only) + LEGACY transcript matcher branch (§14). Assertion
   logic, comparisons, thresholds, prompts, and verdict messages are otherwise
   token-identical.
3. Eval prompts/fixtures/case.yaml: token-only (fixture `resources/PLAN.md` and
   `tests/fixtures/generated-PLAN.md` untouched — no identity tokens present).

## Whole-repo residual review

`/tmp/iaa_fullnorm.py` over every changed file: all residuals are (a) intended identity
phrasings (titles, first-introduction display name, §4C "formerly MAO" framings),
(b) the LEGACY code above, (c) decision-record updates explicitly closing D5
(comparison/08, docs/PUBLIC-DISTRIBUTION-ARCHITECTURE §"Identity/namespace"), or
(d) foreign-filename restorations (`01-BASELINE-AND-MAO-TOPOLOGY.md` in the LCO repo).
No behavioral semantic diff was found; nothing required reversion.

## Known pre-existing (NOT introduced by this migration)

- `web-project-sources/sources/SKILL.md` is the pre-Gate-1 snapshot (`fee98091…`), not
  the Gate-1 `ade65cf7…` — drift predates this task; identity tokens updated in place,
  content not synced (out of scope).
- Companion harness `REPO_ROOT` resolves one level below what its comment claims
  (`…/release-hardening/evals` vs `…/release-hardening`); identical behavior pre- and
  post-rename (path depth unchanged). Left as-is; flagged for Gate-2 wiring.

## Conclusion

The migration is identity-only. After normalizing exactly the §16 token set, the
behavioral policy, adapters, installer logic, scenarios, and eval assertions are
equivalent to commit `122dcf1`.
