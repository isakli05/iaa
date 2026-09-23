# FINAL 0.1.1 PUBLICATION REPORT

Date: 2026-09-23 (publication window 23:14–23:5x +0300). Controller: the
main Claude Code / GLM-5.3 session (sole release controller per the task
brief). GUI legs executed by the owner (the established evidence channel);
all git/GitHub, build, filesystem, network, and restoration work by the
main session. No subagent performed any publication action.

## Record (task §12)

1. **Final release commit.** `e2e763c5c3370f5550d251fa748c43c25f145fcf`
   (`e2e763c`) — the approved candidate head, unchanged.
2. **Integration method.** Fast-forward merge:
   `git checkout main && git merge --ff-only release/0.1.1-zcode-packaging`
   → `793124d..e2e763c`, pushed. No squash, no force, no synthetic merge
   commit; candidate history preserved (4 commits: `b65e671`, `1f9bd78`,
   `1ff1f7d`, `e2e763c`). `origin/main == local main == e2e763c` verified
   after push. Core hashes and parity/static checks re-run green
   post-integration.
3. **v0.1.1 tag.** Annotated tag object
   `746c9923cfed931657d766cfffd1c683bcdec055`, dereferencing to
   `e2e763c5c3370f5550d251fa748c43c25f145fcf`. Pushed; remote
   dereference verified via `git ls-remote --tags origin`.
4. **Signing posture.** **Unsigned annotated tag.** No signing key exists
   on this machine; none was invented and owner security setup was not
   modified (per task §4). This is the same explicit annotated-tag posture
   already accepted for `v0.1.0` (also unsigned annotated — verified by
   inspecting the v0.1.0 tag object before tagging). Recorded here as the
   unsigned-tag fact.
5. **GitHub release URL.** https://github.com/isakli05/iaa/releases/tag/v0.1.1
   — title `İAA 0.1.1`, tag `v0.1.1`, public (not draft, not prerelease),
   notes from `03-release-material.md` §4 (factual, no superlatives,
   narrowly characterized as a ZCode packaging/distribution patch).
6. **Final artifact filenames.** `iaa-0.1.1-src.tar.gz`,
   `iaa-0.1.1-claude-plugin.tar.gz`, `iaa-0.1.1-codex.tar.gz`,
   `iaa-0.1.1-zcode.tar.gz`, `iaa-0.1.1-plugin.zip`, `SHA256SUMS`
   (6 assets, all uploaded).
7. **Exact SHA256 values** (built from the tag; = published SHA256SUMS):

   ```
   291be4d48ba3e32298d6863041eb04e1ce13ac579c5cc906e385d8fdfd36a8c5  iaa-0.1.1-claude-plugin.tar.gz
   e94ad3b8a3f0ed76949d1292100403ac8b3b7c6cbee81d26c417fe0e00462469  iaa-0.1.1-codex.tar.gz
   3af52b7496486dc66d2789cffe84cc969ae285420e038363454cc1af773171fa  iaa-0.1.1-src.tar.gz
   1c6f796d041b3a83784c384148b5c446f166cb9f19e00f2be38a10a8f28a735e  iaa-0.1.1-zcode.tar.gz
   621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c  iaa-0.1.1-plugin.zip
   ```

   The `plugin.zip` value equals the approved candidate pin and the
   committed `marketplace.remote.json` sha256 (enforced by the release
   builder). The four tarballs embed the release commit epoch, so they
   differ from the `1ff1f7d` validation-build values recorded in
   `03-release-material.md` §1 exactly as that file anticipated.
8. **Deterministic tagged-build result.** `scripts/build-release.sh v0.1.1`
   run twice → `diff -r` clean (all artifacts byte-identical). An
   additional two-run determinism proof had already passed at `e2e763c`
   pre-tag. The `plugin.zip` is byte-identical to the official upstream
   `build_dist.py` output over the same plugin tree (re-proven this task:
   fresh clone, staged contribution, `cmp` clean).
9. **Release-asset re-download verification.** All 6 assets re-downloaded
   from the release URLs after upload: `sha256sum -c SHA256SUMS` all OK;
   every file `cmp`-identical to the local tagged build. One first attempt
   (`iaa-0.1.1-zcode.tar.gz`) failed with a transient TLS interception
   error (`certificate subject name 'dotcom.glb' does not match` — a
   network middlebox, not GitHub); retried normally with certificate
   verification on, then verified. No TLS check was ever bypassed.
10. **Production marketplace URL.**
    `https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.remote.json`
    — HTTP 200; served document byte-identical (`jq -S` + `cmp`) to
    `origin/main:packaging/zcode/marketplace.remote.json`; entry: `iaa`
    0.1.1, `source=url`, `type=zip`, the exact v0.1.1 release-asset URL,
    sha256 `621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`,
    `path=iaa`.
11. **Production plugin.zip URL.**
    `https://github.com/isakli05/iaa/releases/download/v0.1.1/iaa-0.1.1-plugin.zip`
    — HTTP 200; independently downloaded bytes match the pinned sha256.
12. **Production remote-install result.** **PASS** — owner-executed GUI
    install from the FINAL production remote marketplace (not the local
    test marketplace): marketplace loaded, `iaa` 0.1.1 listed, installed,
    enabled. ZCode's downloaded copy of the marketplace document was
    recovered from disk and is byte-identical to the served production
    document. The downloaded archive itself was removed by the
    owner's uninstall; byte integrity of the channel is corroborated by
    (a) ZCode's mandatory client-side sha256 gate — install cannot succeed
    on mismatch (`Plugin zip sha256 mismatch` is a hard failure) — and
    (b) the independent download of the same URL matching the pin (item
    11).
13. **Exact ZCode version in the final smoke.** ZCode Desktop **3.14.3**
    (AppImage `3.14.3.7762`, embedded Node 24.14.0).
14. **One-Skill result.** **PASS** — component inventory exactly 1 Skill
    (`iaa`), 0 others.
15. **Explicit Command result.** **PASS** — exactly 1 Command
    (`/orchestrate`, flat name); 0 Agents / 0 Hooks / 0 MCP.
16. **`$iaa` result.** **PASS** — `$iaa what is 2 + 2?` → direct answer,
    zero delegated agents.
17. **`/orchestrate` result.** **PASS** — `/orchestrate what is 2 + 2?` →
    same authoritative policy, zero delegated agents, no duplicate skill
    activation.
18. **Zero-agent result.** **PASS** — trivial task stayed zero-agent on
    both entry paths.
19. **Disable/uninstall result.** **PASS** — disable removed skill +
    command from discovery; uninstall clean; marketplace removal clean;
    registries verified free of `iaa` (7 plugins / 2 official marketplaces);
    disk residues (downloaded marketplace copy + empty cache tree)
    archived to the rollback dir and removed.
20. **`iaa doctor` result.** Exit **0**, 0 actionable, before and after
    the window; final output byte-identical to the pre-window baseline;
    `--json`: 14 findings, 0 problems.
21. **Network workaround / restoration.** Gate first: embedded-runtime
    fetch with default flags reproduced the #699 failure (ETIMEDOUT ×3),
    so the workaround was required. Applied per the documented procedure:
    fresh A records (`8.217.233.95`, `8.217.100.151`) TLS-verified
    normally (both CN `*.z.ai`, Sectigo chain, `Verify return code: 0`);
    `/etc/hosts` backed up (pre-change sha256 `44a76ff1…` — the known
    clean-original value); one entry `8.217.100.151 api.z.ai` appended;
    `resolvectl flush-caches`; effective lookup = exactly one address;
    embedded fetch → **HTTP 200 ×3**. Restored afterward from the backup:
    0 `api.z.ai` entries, original hash restored, caches flushed, real
    DNS back (both A records), end-to-end HTTP 200 via normal resolution.
    Window telemetry (`~/.zcode/cli/log/zcode-2026-09-23.jsonl`):
    **zero** `model.request.failed` / `model.network.failed` /
    `handshake_failed` events after the override; 10
    `model.request.completed` events (the two behavioral runs). The 26
    non-model "failed" events in the window are unrelated pre-existing
    noise (`mcp.server.ping.failed` / `mcp.server.failed` /
    `hook.run.failed` — the chrome-devtools-mcp plugin not running).
    Model-failure events earlier in the day (103, last 20:45 local) all
    pre-date the override and match the documented #699 daily pattern.
22. **Original skills-dir restoration.** `~/.zcode/skills/iaa` symlink
    restored (identical relative target `../../.local/share/iaa/iaa`);
    `~/.zcode/AGENTS.md` **byte-identical** to the pre-window snapshot
    (`46da57ab…`, `cmp` clean; the unintegrate-time automatic backup was
    verified equal to the snapshot before restore and removed after;
    older backup files from prior windows pre-date this task and were
    left untouched). Claude and Codex untouched throughout (doctor-verified).
    Rollback snapshot (private, outside the repo):
    `~/.local/state/iaa/rollback-zcode-011-pub-20260923T232346+0300/`.
23. **Core semantic parity.** **PRESERVED — D = NONE.** All six
    authoritative hashes match the 0.1.0 freeze (`73f7b887…`,
    `23184f0d…`, `849b769c…`, `5fa9617e…`, `21964702…`, `4d78fd57…`),
    verified at the candidate commit, post-merge, and at the end of the
    task; `git diff v0.1.0 v0.1.1 -- iaa/ scripts/iaa` is empty.
24. **Immutable v0.1.0 status.** Intact — tag `v0.1.0` still dereferences
    to `130c543` (local and remote); the `İAA 0.1.0` GitHub release and
    its assets were not touched in any way.
25. **v0.1.0-rc.1 status.** Intact — still dereferences to `0d4c563`
    (local and remote).
26. **Upstream validator/build result.** Fresh clone of
    `zai-org/zcode-plugins` @ `cf739288` (= current main; unchanged
    since the patch was generated): staged contribution →
    `python3 scripts/validate.py` → **`OK: 27 plugin(s) validated`**;
    `python3 scripts/build_dist.py` → builds
    `dist/plugins/iaa/0.1.1/plugin.zip` sha256 `621bdd1ffd24…`;
    `git diff --check` clean. The upstream-built zip is byte-identical
    (`cmp`) to the published release asset. No competing `iaa` plugin or
    PR exists upstream (re-checked before opening).
27. **Upstream PR.** **OPEN** — https://github.com/zai-org/zcode-plugins/pull/42
    (`feat(iaa): add adaptive delegation policy plugin`, base `main`,
    head `isakli05:feat/iaa-plugin`, maintainer edits enabled, fork
    `isakli05/zcode-plugins` created this task). Body from
    `03-release-material.md` §6, updated with the now-real final-URL
    smoke evidence; states policy-not-framework, zero-agent validity,
    1 Skill + 1 Command, ZCode 3.14.3 behavioral + remote-install
    evidence, dependencies/network/side effects (none/none/none),
    MIT + NOTICE, validation commands/results, source repository,
    version 0.1.1; no universal-compatibility claims.
28. **Unresolved issues.** None blocking. Noted, non-blocking: (a) the
    transient `dotcom.glb` TLS interception on one asset download
    (network middlebox; retried clean with full verification); (b) the
    unrelated MCP/hook failure noise during the GUI window (pre-existing
    environment); (c) ZCode 3.14.x provider bug (#699) still unfixed
    upstream — the workaround procedure is documented and was required
    again this window.
29. **Rollback / follow-up requirement.** **None.** No release defect was
    found; no v0.1.2 is warranted.
30. **#699 comment status.** **NOT POSTED** (per task §10). The prepared
    confirming-comment draft remains in
    `post-release/zcode-official/NETWORK-DIAGNOSTIC.md`, awaiting separate
    owner approval and action.
31. **Orchestration semantics changed.** **NO.** D = NONE across every
    behavioral surface; the ZCode Command is a distribution adapter
    delegating to the same unchanged core; policy revision v3 unchanged.
32. **Exact recommended next engineering task.** Monitor upstream PR
    `zai-org/zcode-plugins#42` and respond to maintainer feedback — if
    upstream `main` moves before merge, rebase `feat/iaa-plugin`, keep the
    `iaa` marketplace entry last, and re-run their
    `validate.py`/`build_dist.py`/`git diff --check`. Separately (owner
    decision only): post the prepared #699 confirming comment. No JEV, no
    İAA 0.2, no further release work unless a real release defect
    appears.

## Pre-publication gate record (task §2, all green before any irreversible action)

Working tree clean; `main == origin/main` (`793124d`); release branch ==
origin counterpart; merge-base == main head (clean fast-forward); candidate
head == `e2e763c`; exactly the four expected commits; no `v0.1.1` tag or
release anywhere; no upstream `iaa` PR; repository PUBLIC; repo-local
noreply identity (`isakli05 <40129610+isakli05@users.noreply.github.com>`);
core hashes == freeze; D = NONE; `git diff --check` clean;
`validate-static.py` OK (frontmatter incl. Command checks, docs links,
ASCII paths, secrets scan); `check-parity.sh` ALL PASSED (incl. remote
marketplace sha pin); 13/13 doctor tests; deterministic release build ×2
byte-identical; official upstream validator + `build_dist` byte-parity;
archive safety (testzip clean, 12 entries, single `iaa/` root, 0644,
2026-01-01, deflate, no traversal/symlink/dir entries).

---

```
İAA v0.1.1 PUBLICATION:
  COMPLETE

FINAL PRODUCTION ZCODE DISTRIBUTION:
  TESTED

UPSTREAM ZCODE MARKETPLACE PR:
  OPENED (zai-org/zcode-plugins#42)

CORE SEMANTIC INTEGRITY:
  PRESERVED
```
