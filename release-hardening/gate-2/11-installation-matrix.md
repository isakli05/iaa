# Gate 2 — 11: Clean Install / Update / Uninstall Matrix

Date: 2026-09-23. Executed by `tests/install-matrix/run-matrix.sh` — every case
in a disposable environment (`CLAUDE_CONFIG_DIR` / `CODEX_HOME` / `IAA_HOME` /
`ORCHESTRATION_HOME` redirected; the real HOME is never touched). Exit status
per case printed; the whole matrix is re-runnable on any machine with the
`claude`/`codex` CLIs present.

Before/after filesystem/config state is captured by the script's `snapshot()`
helper (sorted path/hash/link-target inventory) where mutation-scope matters
(m8, m14, m15 assert on it; m12/m13 assert final state).

## Results (2026-09-23, claude 2.1.274, codex-cli 0.156.0)

| # | Case | Result | Evidence |
|---|---|---|---|
| m1 | clean Claude install | **PASS** | marketplace add (repo path) → install `iaa@iaa` → registered w/ version + commit SHA |
| m2 | Claude install with Superpowers already installed | **PASS** | Superpowers registration untouched; both plugins co-registered |
| m3 | clean Codex package install | **PASS** | marketplace add + `codex plugin add iaa@iaa` → installed+enabled, version-pinned cache |
| m4 | Codex dynamic validation | **SKIP (env)** | requires an authenticated interactive Codex session in the disposable home — the single remaining dynamic gap, documented in gate-2/06 §7; note the skills-dir form IS live-validated incl. the E9 probe |
| m5 | ZCode static package validation | **PASS** | official-layout structural validation (mirror of the official validator's checks, offline) |
| m6 | ZCode local-plugin validation | **SKIP (env)** | GUI-only; exact manual checklist prepared in gate-2/07 §6 — explicitly NOT claimed as executed |
| m7 | legacy former-MAO installation detected | **PASS** | doctor exit 1 + `legacy:share-dir` report |
| m8 | legacy migration dry-run | **PASS** | read-only detection; no new markers written (snapshot equality) |
| m9 | legacy migration explicit execution | **PASS** | markers replaced w/ backup, user prose intact, legacy link swapped, state adopted |
| m10 | duplicate İAA install prevention | **PASS** | plugin + personal-skill both active → doctor exit 1, `duplicate:claude` |
| m11 | update older İAA → current | **PASS** | version-pinned cache (0.1.0-rc.1); update path = marketplace refresh + reinstall (structurally verified; two-version exercise possible only after a second version exists) |
| m12 | uninstall (plugin + integration) | **PASS** | plugin registration gone, managed block gone, depth state gone |
| m13 | reinstall | **PASS** | clean reinstall + reintegrate |
| m14 | malformed managed-marker safety | **PASS** | integrate refuses; file byte-untouched |
| m15 | no unrelated user config modified | **PASS** | user prose in CLAUDE/AGENTS, foreign plugin state, unrelated settings keys all intact after script-mode install |
| m16 | rollback | **PASS** | documented one-command rollback restores the previous live tree after deploy |

**Totals: 14 passed, 0 failed, 2 skipped** (both skips are documented
environment limits, not silent omissions).

## Standing caveat

Installation success ≠ orchestration compatibility — the behavioral layers are
§15 (trigger characterization) and §17 (real-machine boundary), never this
matrix.

## Accidental live-machine incident (disclosed)

During early test development, one matrix-style invocation mistakenly ran
`manage.sh install` against the **real** HOME (the test passed `IAA_HOME`, but
manage.sh reads `ORCHESTRATION_HOME`). Effect: the three live skill links were
re-pointed to the repo checkout for ~2 minutes, and the automatic link backups
inside the skills dirs were briefly discoverable as duplicate skills (observed
in the developing session's skill list — a live confirmation of the
duplicate-activation class). **Restoration:** links restored from the automatic
backups with original targets/timestamps; `manage.sh verify` green; shims and
settings were never modified ("unchanged" in the accidental run). Hardening
outcomes shipped in this Gate: env-propagation fix in `scripts/iaa`
(`ORCHESTRATION_HOME` export in script mode), a new doctor check for loadable
backup links inside skills dirs, and matrix/test hardcoding of the correct
variable. Recorded here and in 08-iaa-doctor.md rather than buried.
