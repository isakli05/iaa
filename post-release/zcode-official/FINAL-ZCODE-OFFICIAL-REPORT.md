# FINAL ZCODE OFFICIAL REPORT — post-release validation 2026-09-23

İAA 0.1.0 is public and immutable. This task was post-release validation /
distribution work. JEV was NOT implemented; orchestration semantics were NOT
changed; no competitor features; no redesign. **İAA 0.1.1 was NOT implemented
or released** (STOP per owner instruction J).

## Direct answers

1. **What exact ZCode version was behaviorally tested?** Two tiers:
   skills-dir behavioral baseline = **3.11.2** (historical TESTED
   evidence); plugin-form GUI observation = **3.14.3** (AppImage
   `3.14.3.7762` — install/component behavior observed, `$iaa` model-call
   validation NOT COMPLETED). The pre-flight 3.11.2 pin was invalidated by
   an in-window AppImage replacement (mtime 20:23 local; detail in
   VALIDATION-REPORT F1).
2. **Did the GUI plugin install succeed?** YES — from the LOCAL marketplace
   path, with byte-verified 0.1.0 content (F3). The raw-URL channel FAILED
   (F2).
3. **Did `$iaa` resolve?** NOT TESTED — ZCode could not reach its model
   backend during the window (F5); no behavioral claim either way.
4. **Did zero-agent behavior work?** NOT TESTED (same blocker).
5. **Was exactly one `iaa` skill discovered?** NO — **two** skills (`iaa`
   and `orchestrate`) were exposed (F4). The intended contract is
   UI-visibly false at 3.14.3.
6. **Was `orchestrate` absent as a second auto-triggerable skill?** NO — it
   appeared as an enabled skill component; `disable-model-invocation` is
   documented for ZCode **Command** frontmatter (PLUGIN_DEVELOPMENT.md §2.3),
   not Skill frontmatter (§2.4 documents only `name`+`description`).
7. **Did disable remove the plugin skill from discovery?** NOT CAPTURED —
   the owner disabled/uninstalled the plugin amid the connection troubleshooting;
   no sanitized screenshot of the disable step was recorded. Post-state
   filesystem evidence confirms complete removal.
8. **Did doctor remain clean?** YES — before, during (test window), and
   after: exit 0, 0 actionable problems throughout; final output identical
   to baseline; `--json` 9 OK / 5 INFO.
9. **Was the original live environment fully restored?** YES — proven:
   symlink object restored with identical target; `~/.zcode/AGENTS.md`
   byte-identical to the pre-task snapshot (`46da57ab…`); plugin/marketplace
   registries contain no `iaa`; stale residues archived then removed.
   Observed non-İAA environmental deltas (app auto-update 3.11.2→3.14.3;
   three unrelated plugin version bumps) recorded, not rolled back.
10. **Is ZCode plugin form now legitimately TESTED?** NO —
    **NOT COMPLETED / FAILED CONTRACT CHECK** (owner ruling; F4+F5).
11. **Did any İAA core bytes change?** NO — zero core-file changes; all five
    authoritative hashes match the Gate-3 freeze table in the final state
    (`73f7b887…`, `23184f0d…`, `849b769c…`, `21964702…`, `5fa9617e…`);
    `git diff v0.1.0 HEAD` (before this task's evidence commits) was
    docs-only.
12. **What does current upstream require?** (zai-org/zcode-plugins, fresh
    2026-09-23): unique kebab-case name; `.zcode-plugin/plugin.json` with
    name/version/description(+i18n en & zh-CN)/author; root marketplace.json
    entry with matching name/version/description_i18n + category from the
    7-value set; ≥1 component; **equivalent README.md + README_CN.md**;
    documented deps/network/permissions/side effects + third-party
    provenance; `python3 scripts/validate.py`, `python3 scripts/
    build_dist.py`, `git diff --check`; main capability exercised in ZCode
    with recorded steps/screenshots; Conventional Commits; rebase onto
    latest main before pushing. Versioning contract: any change to a file
    in the installable package (incl. plugin READMEs) requires a semver
    bump; published versions are immutable.
13. **Can the official marketplace submission preserve exact immutable
    0.1.0 installable bytes?** **NO.** (a) `validate.py` hard-requires
    `source: ./plugins/<name>` in-repo — no external-artifact reference
    form; (b) mandatory plugin-level `README_CN.md` would be new
    installable content (build_dist.py packages every plugin-dir file
    verbatim), and the published 0.1.0 ZCode artifact contains none (tarball
    listing verified) — same-version/different-bytes divergence is
    forbidden by both upstream doctrine and İAA parity discipline.
14. **Was README_CN added without violating version immutability?** It was
    NOT added at all — deferred to 0.1.1 per the gate. Immutability of the
    published 0.1.0 is fully preserved.
15. **Did upstream validate.py pass?** Not run as a contribution build
    (no PR prepared — gate blocked). The 0.1.0 package passed the same
    validator in staged form in Gate 3; that result remains valid for the
    unchanged bytes.
16. **Did upstream build_dist.py pass?** Not run (same reason).
17. **Did `git diff --check` pass?** İAA repo: YES (clean tree, no
    whitespace errors) — run on the evidence branch before commit.
18. **Was an upstream PR opened?** NO — blocked (Q13 + Q20).
19. **PR URL?** N/A.
20. **Exact blocker?** The version-immutability gate: a compliant official
    submission requires installable-content changes (mandatory README_CN.md;
    plus the F2 remote-source fix and the F4 adapter correction), which
    cannot ship as 0.1.0.
21. **Is a 0.1.1 patch release required?** **YES** (owner approval still
    required for its execution).
22. **What should the owner do next?** See "Owner next steps".

## The minimal, evidence-backed 0.1.1 patch plan (PROPOSAL — NOT executed)

All changes are ZCode-channel packaging; the authoritative behavioral core
(`iaa/SKILL.md` + references) stays byte-identical; D = NONE. Claude and
Codex packages change only their version stamps (their validated designs
are unaffected).

1. **README_CN.md (mandatory, upstream contract)** — author a Chinese
   README semantically equivalent to `packaging/zcode/plugins/iaa/README.md`:
   what İAA is, zero-agent fallback, delegation-only-when-materially-useful,
   invocation, no hooks/agents/MCP/daemon, no external network dependency,
   no required API key, file/config side effects, MIT + NOTICE licensing,
   source repository, uninstall behavior, compatibility scope. No marketing
   superlatives; no universal-compatibility claims.
2. **Remote marketplace source fix (F2)** — publish a remote-consumable
   marketplace document whose single entry uses the official
   `{"source":"url","type":"zip","url":<versioned zip>,"sha256":<digest>,
   "path":"iaa"}` form, with a **deterministic** `plugin.zip` (fixed
   timestamps, sorted entries — same discipline as upstream build_dist.py)
   hosted as a **GitHub release asset** of v0.1.1. Keep the relative-source
   `marketplace.json` for local-path testing. Form comparison done:
   relative `./plugins/iaa` (local/clone only — observed failing raw-URL);
   github-marketplace clone (resolves root Claude manifest → wrong package);
   git-subdir (undocumented for this use in distribution.md);
   **url/zip+sha256 (chosen: documented remote form, used by 100% of
   official CDN entries, immutable + hash-verified per version)**.
3. **Adapter correction (F4)** — ZCode package: keep `skills/iaa/` as the
   sole model-discoverable skill; convert the explicit entry to
   `commands/orchestrate.md` (Command frontmatter §2.3; body = the current
   pointer text adapted with `$ARGUMENTS` passthrough); add
   `"commands": "commands"` to `.zcode-plugin/plugin.json`; remove
   `skills/orchestrate/SKILL.md` **from the ZCode package only**. Claude
   package unchanged (different documented contract).
4. **Version flip + release** — `0.1.0 → 0.1.1` across VERSION, manifests,
   projections (same 15-file class as the pre-validated 0.1.0 flip);
   rebuild packages + new `plugin.zip` artifact; run İAA CI layer A
   (validate-static, check-parity, doctor tests, install matrix) and stage
   the upstream `validate.py`/`build_dist.py` against the contribution
   tree; tag `v0.1.1`; GitHub release with SHA256SUMS.
5. **Upstream PR at 0.1.1** — fork, `feat(iaa): add adaptive delegation
   policy plugin`, full tree incl. README_CN.md, marketplace entry,
   PR checklist with real GUI evidence (see next), Conventional Commit,
   rebased on latest main.
6. **GUI re-validation precondition** — fix the ZCode model connection
   first (owner-side; likely `/etc/gai.conf` IPv4 preference — see
   VALIDATION-REPORT F5), then re-run the Gate-3 checklist at a pinned,
   updater-stable version to generate the behavioral evidence the upstream
   PR requires (one `iaa` skill + `$iaa` zero-agent run + disable removes
   discovery), with sanitized screenshots.

## Owner next steps

1. Decide/approve the 0.1.1 patch release (this plan or amended).
2. ZCode connectivity (independent of İAA): root cause CONFIRMED at the
   runtime level and matched upstream — see NETWORK-DIAGNOSTIC.md and
   [zai-org/feedback#699](https://github.com/zai-org/feedback/issues/699).
   Options: subscribe/comment on #699 (draft prepared), the #699-confirmed
   `/etc/hosts`+relay workaround, or a transient system IPv6 disable —
   owner decision. (`/etc/gai.conf` and `NODE_OPTIONS` are known
   ineffective for this app.)
3. After 0.1.1 lands: re-run the GUI validation leg and submit the upstream
   PR with real evidence.

## Second-pass corrections (2026-09-23, later — commit on this branch)

1. Network root cause: first-pass attribution ("broken IPv6 × ZCode
   connection behavior", stated as fact) replaced by a controlled result —
   **CONFIRMED at the embedded-runtime level** via single-variable A/B in
   ZCode's own Node (default autoSelectFamily → ETIMEDOUT; disabled →
   HTTP 200; ipv4first → no effect), corroborated by upstream #699 which
   also confirms the in-app path and a working workaround. Not a Z.ai
   backend failure. Full record: NETWORK-DIAGNOSTIC.md.
2. Public tracker: the first-pass claim "no public issue tracker exists"
   was wrong. Official channels include the `zai-org/feedback` GitHub
   Issues (verified; 649 open). Matching issue: #699. No new issue to
   file; confirming-comment draft prepared, not posted.
3. Compatibility wording: evidence tiers separated — 3.11.2 = skills-dir
   behavioral baseline (TESTED, historical); 3.14.3 = plugin-form GUI
   observation only (install/components; `$iaa` model-call validation NOT
   COMPLETED). Plugin form remains STRUCTURALLY COMPATIBLE (no upgrade).

---

```
ZCODE PLUGIN-FORM BEHAVIORAL VALIDATION:
  NOT COMPLETED / FAILED CONTRACT CHECK

OFFICIAL ZCODE MARKETPLACE PR:
  BLOCKED (version-immutability gate; 0.1.1 patch release required first)

İAA CORE SEMANTIC INTEGRITY:
  PRESERVED
```
