# Gate 2 — 04: Source-of-Truth Normalization

Date: 2026-09-23. Problem (Gate brief §6): the baseline deliberately kept **live
runtime source** (`~/.local/share/iaa/`) and **versioned maintenance source**
(`/home/isa/projects/iaa`) as two hash-identical trees synchronized by manual
copy-back. Correct for a forensic freeze; wrong as a long-term model.

## 1. Normalized model (implemented)

```
/home/isa/projects/iaa            = authoritative development source (git)
        |
        |  scripts/iaa deploy      (stage → verify → swap → provenance)
        v
~/.local/share/iaa/               = derived runtime source (deployment output)
        |
        +-- ~/.claude/skills/iaa -> ..   (consumer links unchanged: same path)
        +-- ~/.agents/skills/iaa -> ..
        +-- ~/.zcode/skills/iaa  -> ..
```

Direction of truth is inverted: **edit the repo → deploy → runtime follows.** The
pre-Gate-2 "edit live canonical file, then copy back into git" procedure is
retired (docs/SOURCE-OF-TRUTH.md updated accordingly).

## 2. The deploy transaction (`scripts/iaa deploy`)

1. **Stage** into `<share>/.iaa-stage-<stamp>/` (sibling of the live tree, same
   filesystem): copies repo `iaa/` + `CANONICAL-README.md` → stage `iaa/` + `README.md`.
2. **Verify** the staged core byte-matches the repo (`diff -r`); on mismatch the
   transaction aborts having touched nothing.
3. **Provenance** written to `~/.config/iaa/provenance.json`: package version,
   policy revision (v3), source commit, core-file sha256 map, dirty flag.
4. **Swap**: existing live tree moved to `~/.local/share/iaa.iaa-previous-<stamp>`
   (rollback copy), stage moved into place. Two `mv`s on one filesystem; consumer
   symlinks keep resolving because the live path is unchanged.
5. Printed rollback command restores the previous tree in one `mv`.

Properties required by the brief, and how each holds:

| Requirement | Mechanism |
|---|---|
| repo authoritative | only `deploy` writes the live tree; editing it directly now counts as drift |
| runtime = derived output | provenance.json records origin; `iaa doctor` verifies live-tree hashes against it (or against the repo when run from a checkout) |
| rollback possible | previous tree retained per deploy; printed rollback command |
| existing install not broken | path-stable swap; links verified to survive (tested) |
| transactional | stage-verify-swap; abort-before-touch on verification failure |
| verifiably derived | provenance hashes + doctor check (T12 unit test proves drift detection) |
| uninstall scope unchanged | deploy owns no consumer state; manage.sh uninstall semantics untouched |

## 3. Validation performed (2026-09-23, disposable HOME)

- `deploy --dry-run` mutates nothing (verified).
- First deploy into empty HOME: correct layout (README.md + iaa/), provenance
  hashes byte-equal to the §2 freeze table (all five core digests).
- Consumer symlink created → redeploy → link still resolves to the new tree
  (`readlink -f` + SKILL.md present). Previous tree retained.
- `iaa doctor` in the deployed environment: `hash:live-tree matches recorded
  provenance hashes`.
- Unit tests T2/T12 (tests/doctor/run-tests.sh) cover read-only-ness and drift
  detection.

## 4. Real-machine cutover

The real machine cutover is executed at Gate-2 completion time (after the final
commit), as the last mutation of the Gate:

```
sh scripts/iaa deploy          # from the final Gate-2 checkout
~/.local/share/iaa/iaa/scripts/manage.sh verify   # links/shims/depth green
scripts/iaa doctor             # live-tree hash: OK via provenance
```

Because the repo core and live core are byte-identical throughout Gate 2 (§23),
the cutover is content-neutral: it changes *who is authoritative*, not any byte
consumed by a runtime. The pre-cutover live tree is retained as
`iaa.iaa-previous-<stamp>` (one-command rollback), and the identity-migration
rollback snapshot from 2026-09-23 remains untouched.

## 5. Residual notes

- `provenance.json` is İAA-owned state (uninstall-safe: it is metadata only; the
  documented uninstall leaves it for forensics, see docs/UNINSTALL.md).
- Rollback copies accumulate one per deploy (`iaa.iaa-previous-*`); cleanup is a
  documented manual step (kept deliberately conservative — evidence-disposition
  policy).
- Live-tree edits made directly after a deploy are now *detectable drift*
  (doctor PROBLEM with redeploy instruction) instead of silent divergence.
