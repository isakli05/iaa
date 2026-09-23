# İAA 0.1.0 — PUBLICATION RUNBOOK (prepared, NOT executed)

Status: PREPARED by Gate 3 (2026-09-23). Every irreversible step is marked
**[IRREVERSIBLE]** or **[IRREVERSIBLE — EXTERNAL]**. Nothing below has been
run. Preconditions: Gate-3 report accepted by owner; repository still
PRIVATE; `v0.1.0-rc.1` intact; Gate-3 branch merged-ready.

Owner decision inputs this runbook assumes are settled before step 1:
LICENSE choice (01-license-review.md), commit-email policy
(09-final-publication-safety.md §3), LCO-citation keep/generalize
(09 §6), and — optionally but recommended — the ZCode GUI checklist
(05-zcode-final-validation.md §6, ~5 min, upgrades the ZCode plugin-form
claim to TESTED at that version).

---

## Phase P — pre-publication owner approvals (no repo/public mutation)

- **P1. Approve the license** (recommendation: OPTION A = MIT + NOTICE;
  candidate files verbatim at `release-hardening/gate-3/license-candidate/`).
  If substituting the copyright holder line (handle → legal name), edit the
  candidate first.
- **P2. Note the commit-email posture** (history carries
  `isakaya709@gmail.com`; future commits may use GitHub noreply — history is
  NOT rewritten).
- **P3. Optional: execute the ZCode GUI checklist** on the desktop app
  (05 §6) and record results.

## Phase A — license installation (repo-local, reversible by commit revert)

1. `cp release-hardening/gate-3/license-candidate/LICENSE .` and
   `cp release-hardening/gate-3/license-candidate/NOTICE .`
2. Stamp SPDX `"license": "MIT"` into `packaging/templates/claude-plugin.json`
   + `packaging/templates/codex` manifest template + change
   `"UNLICENSED"` → `"MIT"` in `packaging/templates/zcode-plugin.json`;
   run `sh scripts/build-packages.sh`.
3. README: replace the "License: TBD" paragraph with the chosen license +
   links to LICENSE/NOTICE. `docs/` cross-links if needed.
4. `python3 scripts/validate-static.py && sh scripts/check-parity.sh`
5. Commit: `license: MIT + NOTICE (owner-approved), SPDX stamps in manifests`.

## Phase B — final deterministic checks (repo-local, reversible)

6. From a CLEAN tree: `sh scripts/build-packages.sh && git status --porcelain`
   → must be empty (regeneration determinism).
7. `python3 scripts/validate-static.py && sh scripts/check-parity.sh &&
   sh tests/doctor/run-tests.sh && sh tests/install-matrix/run-matrix.sh`
   (all green; skips documented where environmental).
8. Optional model layers if desired for release confidence (not required —
   Gate-3 evidence current): layer-B trigger suite; boundary companion j/k.

## Phase C — version flip (repo-local; the exact diff is pre-validated)

9. The flip is PREPARED and validated:
   `release-hardening/gate-3/prepared-0.1.0-version-flip.diff` (15 files,
   all version stamps; no core files; parity green at 0.1.0). Execute the
   equivalent: `echo 0.1.0 > VERSION && sh scripts/build-packages.sh`,
   verify `git diff` equals the prepared diff modulo the license-phase
   stamps.
10. README/docs: update version line `0.1.0-rc.1` → `0.1.0`, repository-
    status section (release published), dated notes as appropriate.
11. Commit: `release: 0.1.0 (first public release; policy revision v3)`.

## Phase D — integrate into main (repo-local)

12. `git checkout main && git merge --no-ff release-hardening/gate-3` →
    resolve nothing expected; push main. (No force push anywhere.)
13. Verify main: CI layer A green on the merge commit;
    `sh scripts/check-parity.sh`; `scripts/iaa doctor` exit 0.

## Phase E — tag and artifacts **[IRREVERSIBLE]**

14. `git tag -s v0.1.0 <merge-commit> -m "İAA 0.1.0 — first public release"`
    (annotated; include version + policy revision v3 + evidence summary).
15. `git push origin v0.1.0`; verify `git rev-parse v0.1.0^{}` == merge
    commit; `git tag -v v0.1.0`.
16. Rebuild artifacts from the tag (deterministic builder):
    `scripts/build-release.sh v0.1.0` → record SHA256SUMS; verify a second
    build is byte-identical (Gate-3 §14 mechanism).

## Phase F — public visibility **[IRREVERSIBLE — EXTERNAL]**

17. Confirm intent (this is THE point of no return for the repo):
    `gh repo edit isakli05/iaa --visibility public` (or via web UI; also
    set description/topics if desired). Repo still carries LICENSE from
    Phase A.
18. Sanity-check the public view: README renders, LICENSE detected by
    GitHub (license badge), no broken links, `dist` absent (gitignored).

## Phase G — GitHub release **[IRREVERSIBLE — EXTERNAL]**

19. `gh release create v0.1.0 dist/iaa-0.1.0-*.tar.gz dist/SHA256SUMS
    --title "İAA 0.1.0" --notes <notes.md>` — notes state: version, policy
    revision v3, tested-versions matrix summary (version-pinned!), the
    honest ZCode/Codex claim scoping, and the evidence-tree pointer.

## Phase H — marketplace submissions **[IRREVERSIBLE — EXTERNAL]**

20. **Re-run the namespace re-check first** (06 doc; registries change
    daily). If an exact `iaa` collision appeared in a target registry,
    stop and apply the runtime-specific slug rule (product name unchanged).
21. **Claude**: the repo root already is a marketplace
    (`.claude-plugin/marketplace.json`, owner `isakli05`, validated).
    Public install path becomes live automatically at visibility change:
    `claude plugin marketplace add isakli05/iaa && claude plugin install
    iaa@iaa`. Optionally submit to `anthropics/claude-plugins-official`
    via their contribution process (follows their review cadence).
22. **Codex**: skills-dir script install is live with the repo public.
    For the plugin form: add the repo as a marketplace source per current
    `openai/plugins` guidance (or their directory process if open then);
    the universal ChatGPT+Codex directory requires a maintained 5-positive/
    3-negative test suite + identity verification — do NOT enter that
    program casually; the GitHub-marketplace path is enough for 0.1.0.
23. **ZCode**: submit PR to `zai-org/zcode-plugins` (their CONTRIBUTING
    process) adding `marketplace.json` entry + `plugins/iaa/` tree, or
    publish the marketplace JSON at a stable URL. Status label in docs
    stays STRUCTURALLY COMPATIBLE (or TESTED if P3 done) — update the
    matrix to match whatever evidence exists at submission time.

## Phase I — post-publication verification (read-only)

24. Install smoke on a disposable config per runtime:
    `claude plugin marketplace add isakli05/iaa && claude plugin install
    iaa@iaa && claude plugin details iaa` (2 skills, ~0 always-on tokens);
    live `/iaa:orchestrate` trivial-task run → expect zero-agent fallback;
    Codex disposable-home `$iaa` probe (per gate-3/04 §2 method).
25. `iaa doctor` in the disposable environment → exit 0.
26. Verify README install commands work exactly as written from the public
    repo URL; verify docs links resolve on the public view.
27. Record outcomes (and any marketplace review feedback) in
    `release-hardening/` as a dated publication record.

## Rollback / incident procedure

- **Before F17 (visibility)**: everything is a commit/tag revert — normal
  git operations; delete unpushed tag with `git tag -d`; pushed-but-private
  tag can be deleted with owner consent (`git push origin :refs/tags/v…`).
- **After F17 (public) but before marketplace submissions**: re-privating
  is possible (`gh repo edit --visibility private`) but caches/clones/forks
  may persist — treat as NOT fully reversible. GitHub release can be
  deleted; the tag remains unless also deleted.
- **A marketplace leg fails/rejects** (e.g., Codex directory, ZCode PR):
  the runtime-specific slug rule applies; if a runtime cannot ship, mark
  that channel in docs as planned/unavailable — never let one channel
  invalidate the others; the repo + tarballs remain the canonical source.
- **Post-publication defect found**: fix on a branch → release `0.1.1`
  (SemVer pre-1.0 allows breaking in minors, but prefer patch for fixes);
  re-run CI layer A + affected behavioral layers; new tag/release; update
  marketplaces via their update flows (version-pinned caches make old
  versions stay available).
