# MANIFEST — İAA web knowledge pack (2026-09-22)

## Recommended upload set (ChatGPT Project / Claude Project knowledge)

Upload in this order:

1. `00-READ-ME-FIRST.md` — orientation + terminology (read first)
2. `01-IAA-PROJECT-BRIEF.md`
3. `sources/SKILL.md` ← **AUTHORITATIVE** (the actual policy)
4. `sources/references-delegation-contract.md` ← authoritative
5. `sources/references-platform-adapters.md` ← authoritative
6. `02-CURRENT-ARCHITECTURE.md` — explanatory
7. `03-BEHAVIORAL-CONTRACT.md` — explanatory (verification-labeled)
8. `05-IAA-SDD-BOUNDARY.md` — explanatory
9. `06-INTEGRATIONS-CLAUDE-CODE-CODEX-ZCODE.md` — explanatory
10. `07-HISTORY-AND-EVIDENCE.md` — historical
11. `08-TESTS-AND-VALIDATION.md` — explanatory + execution record
12. `09-KNOWN-LIMITATIONS-AND-OPEN-QUESTIONS.md` — explanatory
13. `04-SOURCE-OF-TRUTH-AND-FILE-MAP.md` — reference
14. `10-COMPARISON-RESEARCH-BRIEF.md` — task definition (only when doing the comparison)

Optional (deeper context, larger): `sources/CANONICAL-README.md` (authoritative install-era
doc, 16 KB), `sources/tests-scenarios.md` (authoritative scenario contract),
`sources/scripts-manage.sh` (authoritative installer — needed only for install-mechanics
questions).

## Authority classes

- **Authoritative (override everything else):** everything under `sources/` — byte-exact
  copies of the live canonical files (SKILL.md sha256 fee98091…).
  **Parity status (2026-09-23, after the İAA/`iaa` identity rename):** identity tokens
  were updated in every `sources/` file; `scripts-manage.sh`, `references-delegation-contract.md`,
  and `CANONICAL-README.md` are byte-identical to the live canonical tree, while
  `SKILL.md`, `references-platform-adapters.md`, and `tests-scenarios.md` are still the
  pre-Gate-1 snapshots this pack was built from (pre-existing drift, predating the
  rename; refresh before upload if adapter-fix parity matters).
- **Explanatory summaries:** 01–06, 08–09 — audit-written; every claim sourced; if a
  summary conflicts with a source file, the source file wins.
- **Historical:** 07 — describes past states; explicitly labels what is no longer active.
- **Task definition:** 10 — instructions for future work; contains no findings.
- **Must not override canonical source:** all numbered docs; especially anything quoting
  historical policy wording (v0/v1) in 05/07 — current = v3 only.

## Not in this pack (by design)

Raw campaign transcripts/runs/repos (local-only), machine secrets (none present),
the audit working files (in the repo's audit/ dir), unrelated machine state.
