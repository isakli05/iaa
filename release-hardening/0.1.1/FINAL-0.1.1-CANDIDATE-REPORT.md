# FINAL 0.1.1 CANDIDATE REPORT — ZCode packaging patch

Date: 2026-09-23. Controller: the main Claude Code / GLM-5.3 session (sole
controller per the task brief). GUI leg executed by the owner. This is a PATCH
RELEASE CANDIDATE report: nothing was tagged, released, merged, or submitted
upstream by this task.

## Direct answers (task §19)

1. **Branch and final candidate commit.** Branch
   `release/0.1.1-zcode-packaging` (from main `793124da36…`), pushed to
   origin, not merged. Content commits: `b65e671` (ZCode adapter + build
   system + version flip, 30 files), `1f9bd78` (docs, 4 files), `1ff1f7d`
   (static-validation record), plus this report's commit (evidence, release
   material, compatibility-row update) — the branch tip including this file
   is the candidate.
2. **Exact files changed** (vs `793124d`, excluding this record's own files):
   `VERSION`; 10 generated packaging files (3 plugin manifests, 2 + 1 new
   marketplaces, 3 package READMEs, 5 PROVENANCE markers); removed
   `packaging/zcode/plugins/iaa/skills/orchestrate/SKILL.md`; added
   `commands/orchestrate.md`, `README_CN.md`, `marketplace.remote.json`
   (+ 4 new templates incl. the command and README_CN templates);
   `scripts/{build-packages,build-release,check-parity}.sh`,
   `scripts/validate-static.py`, new `scripts/build-plugin-zip.py`;
   `README.md`, `docs/{COMPATIBILITY,INSTALLATION,INVOCATION}.md`;
   `release-hardening/0.1.1/**`. Claude/Codex trees: version stamps +
   PROVENANCE only.
3. **Final version metadata.** `0.1.1` in VERSION, all three plugin
   manifests, both marketplaces + the remote document, all package READMEs
   and PROVENANCE markers, root README, compatibility matrix. Policy revision
   **v3 unchanged**; no channel version divergence.
4. **Core hash parity.** All five behavioral-core files byte-identical to the
   approved 0.1.0 freeze (verified before change and again post-GUI):
   `73f7b887…`, `23184f0d…`, `849b769c…`, `5fa9617e…`, `21964702…`
   (+ `scripts/iaa` `4d78fd57…`). **D = NONE.**
5. **README_CN status.** Added at `packaging/zcode/plugins/iaa/README_CN.md`
   (generated from template, parity-checked). Semantically equivalent to the
   extended English README: 16/16 mandated topics present in both, 12 bullets
   each; no marketing superlatives; no universal-compatibility claims.
6. **ZCode component inventory.** 1 Skill (`iaa`) · 1 Command
   (`/orchestrate`) · 0 Agents · 0 Hooks · 0 MCP — owner-observed in the GUI
   component list.
7. **Exact ZCode explicit command syntax.** **`/orchestrate`** — flat, no
   plugin prefix. Evidence: ZCode 3.14.3 client code (`resolvePluginCommandRoots`
   + `getCommandName` with `namespaceSeparator:"/"` over the manifest-declared
   `commands` root) and official shipped plugins (`/android-dev`, `/ios-dev`,
   `/restore-legacy-sessions`); confirmed live in the GUI (criterion E).
8. **Deterministic plugin.zip SHA256.**
   `621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`
   (18 217 bytes, 12 entries, single top-level `iaa/`, fixed 2026-01-01
   mtime, 0644, deflate). Two consecutive builds byte-identical; two full
   `build-release.sh` runs byte-identical; **byte-identical to the official
   upstream `build_dist.py` output** over the same plugin tree.
9. **Local marketplace status.** `packaging/zcode/marketplace.json` preserved
   in meaning (relative `./plugins/iaa` source; local-path / cloned-repo /
   upstream-contribution form), version 0.1.1; passes official `validate.py`.
   Purpose disambiguated from the remote document in packaging README +
   docs/INSTALLATION.
10. **Remote URL/ZIP source test result.** **PASS.** Local contract test
    (127.0.0.1:8397, plain-http-allowed-for-loopback by the client's own URL
    validator): marketplace loaded, plugin installed; ZCode's downloaded
    archive cached in-place with sha256 **equal to the pinned value** — the
    mandatory client hash gate verifiably passed on our exact bytes. The
    production GitHub-release URL is prepared but not yet testable (no tag);
    post-publication smoke is a required release-task step
    (`03-release-material.md` §7).
11. **Exact ZCode version behaviorally tested.** ZCode Desktop **3.14.3**
    (AppImage `3.14.3.7762`, embedded Node 24.14.0), re-detected inside the
    task window; unchanged from the post-release diagnostic.
12. **`$iaa` result.** **PASS** — owner-executed `$iaa what is 2 + 2?`:
    policy resolved, direct answer, zero delegated agents.
13. **Zero-agent result.** **PASS** — trivial task stayed zero-agent through
    both the skill and the command path.
14. **Explicit orchestrate Command result.** **PASS** — `/orchestrate what is
    2 + 2?` ran the same authoritative policy (thin entry delegating to the
    bundled `iaa` skill), zero agents, no duplicate skill activation, no
    second implementation.
15. **One-Skill contract result.** **PASS** — Settings → Skills showed
    exactly `iaa`; `orchestrate` absent as a skill (it is a Command).
16. **Disable/uninstall result.** **PASS** — disable removed skill + command
    from discovery; uninstall clean; registries verified free of `iaa`
    afterwards (residue archived + removed by the main session).
17. **Doctor result.** Exit **0**, **0 actionable** before, during, and after
    the test window; final output identical to the pre-task baseline;
    `--json`: 14 findings, 0 problems, version 0.1.1.
18. **Temporary IPv4 workaround result.** Applied per brief: fresh A-record
    resolution (both IPv4s TLS-verified, CN `*.z.ai`, hostname verification
    on), `/etc/hosts` backed up, one entry `8.217.100.151 api.z.ai` added,
    `resolvectl flush-caches` + effective-lookup verification, then the gate:
    embedded-runtime fetch with **default flags only** → **HTTP 200 ×3**
    (identical test was ETIMEDOUT ×3 pre-override). Only then was ZCode
    opened. No IPv6 disable, no `/etc/gai.conf`, no credential or TLS
    changes. App log for the window: zero model-request failures.
19. **Final `/etc/hosts` restoration.** Restored from the verified backup
    (`/etc/hosts.iaa-011-backup-20260923T222507+0300`); 0 `api.z.ai` entries;
    caches flushed; real DNS confirmed (both A records, CNAME resolution,
    end-to-end HTTP 200 via normal resolution).
20. **Original ZCode integration restoration.** `~/.zcode/skills/iaa` symlink
    object restored (identical relative target `../../.local/share/iaa/iaa`);
    `~/.zcode/AGENTS.md` **byte-identical** to the pre-task snapshot
    (`46da57ab…`, `cmp` clean). Claude and Codex untouched throughout.
21. **Official validator result.** `python3 scripts/validate.py` on the
    staged contribution tree: **`OK: 1 plugin(s) validated`** (upstream @
    `cf739288`, re-cloned fresh 2026-09-23).
22. **Upstream build_dist result.** `python3 scripts/build_dist.py` succeeds;
    its `plugins/iaa/0.1.1/plugin.zip` is **byte-identical** to our
    distributed artifact (sha256 match + `cmp` clean).
23. **Security/publication scan.** `validate-static` secret scan clean;
    `git diff --check` clean; evidence files contain only public metadata
    (marketplace JSON + archive hash); raw runtime state kept outside the
    repo (`~/.local/state/iaa/rollback-zcode-011-…/`); no API keys, OAuth
    data, private paths, or conversation content captured.
24. **0.1.0 immutable artifacts untouched.** Yes — tags `v0.1.0` (`130c543`)
    and `v0.1.0-rc.1` (`0d4c563`) unchanged; no GitHub release mutation of
    any kind; published 0.1.0 assets not downloaded-over, edited, or deleted;
    the 0.1.0 defect was documented, not rewritten.
25. **Orchestration semantics changed.** **NO.** D = NONE across every
    behavioral surface (policy, materiality, zero-agent fallback, per-seat
    justification, topology, dependency shaping, ownership, controller
    ownership, explicit yield, artifact trust boundary, primary integration
    authority). The command is a distribution adapter delegating to the same
    core.
26. **Candidate safe to release.** **YES — READY**, gated on the owner-driven
    publication sequence (merge → tag → release → smoke → upstream PR). All
    §15 acceptance criteria passed; release material prepared in
    `03-release-material.md`.
27. **Exact next publication task.** `03-release-material.md` §8, in order:
    owner merge to main → signed `v0.1.1` tag → `scripts/build-release.sh
    v0.1.1` → GitHub release `İAA 0.1.1` with 6 assets + notes → final-URL
    smoke checklist (§7) + addendum record → upstream PR from
    `upstream-pr.patch` (rebased on latest main, their validators re-run) →
    optional #699 comment only with separate owner approval.

---

```
İAA 0.1.1 CANDIDATE:
  READY

ZCODE PLUGIN-FORM BEHAVIOR:
  TESTED

REMOTE MARKETPLACE DISTRIBUTION:
  TESTED (url/zip/sha256/path contract, byte-verified download;
          final GitHub asset URL pending post-publication smoke)

CORE SEMANTIC INTEGRITY:
  PRESERVED
```
