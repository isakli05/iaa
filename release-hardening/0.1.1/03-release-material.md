# İAA 0.1.1 — Release Material (PREPARED, NOT PUBLISHED)

Per task §17: everything below is prepared for the later publication task.
Nothing here has been tagged, released, merged, or submitted. The candidate
branch is `release/0.1.1-zcode-packaging` (HEAD at preparation: `1ff1f7d`
+ this record's commit).

## 1. Exact final artifact list

Built by `scripts/build-release.sh <tag>` from the future `v0.1.1` tag commit
(release task MUST rebuild from the actual tag; the hashes below are from the
validation builds at `1ff1f7d` — the `plugin.zip` is content-pinned and will
be byte-identical; the four tarballs embed the commit and will differ if any
commit lands between `1ff1f7d` and the tag):

```
iaa-0.1.1-src.tar.gz
iaa-0.1.1-claude-plugin.tar.gz
iaa-0.1.1-codex.tar.gz
iaa-0.1.1-zcode.tar.gz
iaa-0.1.1-plugin.zip          ← the ZCode remote-install archive
SHA256SUMS
```

SHA256SUMS as built from `1ff1f7d` (rebuild from the tag will refresh the
tarball lines; the `plugin.zip` line is stable):

```
86ae3beb4737f293832b98bccc4f246d158492f7f1946907e448017902189254  iaa-0.1.1-claude-plugin.tar.gz
5cf4ae7c1dff2c6692516435596db443f104bd3e12daf1a764e1a11e8bc72a8e  iaa-0.1.1-codex.tar.gz
fe737ecf65cac74db285c997a5c56959d533c9f21dc09c75c992c074690f1867  iaa-0.1.1-src.tar.gz
d9639b330f339ed7ed6dd9d33c6cf2023224630f7c8cc05d7c6355a5da0b845e  iaa-0.1.1-zcode.tar.gz
621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c  iaa-0.1.1-plugin.zip
```

Determinism: proven (two consecutive `build-release.sh HEAD` runs → `diff -r`
clean); the release script aborts if the committed `marketplace.remote.json`
sha pin does not equal the freshly built zip.

## 2. Production remote marketplace document

Committed in-repo (served over the stable raw URL once main carries it):

- File: `packaging/zcode/marketplace.remote.json` (generated + parity-checked)
- Stable URL to add in ZCode → Discover:
  `https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.remote.json`
- Entry: `iaa` 0.1.1 · `category: productivity` · source
  `{source: url, type: zip, url: https://github.com/isakli05/iaa/releases/download/v0.1.1/iaa-0.1.1-plugin.zip, sha256: 621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c, path: iaa}`
- **Status honesty:** the `…/v0.1.1/…` GitHub URL did not exist during this
  task; it is NOT claimed tested. The url/zip/sha256/path mechanism itself IS
  tested (local 127.0.0.1 contract test, byte-verified download — see
  `02-gui-validation.md`). Final-URL smoke checklist in §7 below.

## 3. Expected GitHub Release asset names

`iaa-0.1.1-src.tar.gz`, `iaa-0.1.1-claude-plugin.tar.gz`,
`iaa-0.1.1-codex.tar.gz`, `iaa-0.1.1-zcode.tar.gz`,
`iaa-0.1.1-plugin.zip`, `SHA256SUMS` — release title `İAA 0.1.1`, tag
`v0.1.1` (signed), target = the release commit on main after merge.

## 4. Concise v0.1.1 release notes (draft)

> İAA 0.1.1 — ZCode packaging patch. SemVer package 0.1.1 · behavioral/policy
> revision v3 (unchanged) · namespace `iaa`.
>
> **What changed (ZCode channel only)**
> - The explicit entry point is now a **Command: `/orchestrate`** (flat name —
>   ZCode does not prefix plugin commands). In 0.1.0 it shipped as a second
>   skill, which ZCode exposed as auto-discoverable; the package now contains
>   exactly one model-discoverable skill: `iaa`.
> - `README_CN.md` added (plugin-level Chinese README, semantically equivalent
>   to the English one).
> - **Remote marketplace distribution fixed:** `marketplace.remote.json` uses
>   the official verified-archive form (`url` + `zip` + `sha256` + `path`)
>   pinned to the versioned `iaa-0.1.1-plugin.zip` release asset. The 0.1.0
>   raw-URL form (relative plugin source) resolved only from a local path or
>   repository clone.
> - Deterministic `plugin.zip` (official `build_dist` discipline; byte-identical
>   to the official builder's output over the same tree).
>
> **Not changed:** the behavioral core (`iaa/` skill + references) is
> byte-identical to 0.1.0 (semantic diff D = NONE); Claude and Codex packages
> carry version metadata only; no JEV, no competitor features, no orchestration
> redesign.
>
> **Validation:** ZCode Desktop 3.14.3 GUI acceptance — remote marketplace
> install with byte-verified archive sha256, 1 Skill / 1 Command / 0 agents /
> 0 hooks / 0 MCP inventory, `$iaa` and `/orchestrate` trivial runs with zero
> delegated agents, disable + uninstall lifecycle. Official
> `zai-org/zcode-plugins` `validate.py` + `build_dist.py` pass. Evidence:
> `release-hardening/0.1.1/` in the repository.
>
> **Integrity:** artifacts byte-reproducible from the tag
> (`scripts/build-release.sh v0.1.1`); checksums in `SHA256SUMS`. MIT — see
> `LICENSE` / `NOTICE`.

## 5. Upstream contribution (prepared; NOT submitted)

- Patch: `release-hardening/0.1.1/upstream-pr.patch` (867 lines; 13 files:
  marketplace.json entry insert + `plugins/iaa/**` at 0.1.1), generated
  against `zai-org/zcode-plugins` @ `cf739288` (current main, 26 plugins).
- Staging recipe (reproducible from this branch):
  ```sh
  UP=<fresh clone of zai-org/zcode-plugins>
  jq --slurpfile entry packaging/zcode/marketplace.json \
     '.plugins += $entry[0].plugins' "$UP/marketplace.json" > tmp && mv tmp "$UP/marketplace.json"
  cp -r packaging/zcode/plugins/iaa "$UP/plugins/iaa"
  cd "$UP" && python3 scripts/validate.py && python3 scripts/build_dist.py && git diff --check
  ```
  (verified end-to-end in this task: `OK: 1 plugin(s) validated`; build_dist
  zip byte-identical to our artifact)
- README/README_CN ship inside `plugins/iaa/` (equivalent content, 16-topic
  parity verified).
- Commit message (Conventional Commits): `feat(iaa): add adaptive delegation policy plugin`

## 6. Proposed upstream PR body (draft)

> **feat(iaa): add adaptive delegation policy plugin**
>
> **User problem:** "use subagents" should mean better execution, not more
> agents. İAA is a delegation-decision policy: one skill that decides whether,
> when, and how to delegate — adaptive, per-seat justified, with a zero-agent
> fallback for trivial or tightly coupled work. It is a policy, not a
> framework: no roles, no cadences, no state.
>
> **Visible behavior:** exactly one Skill (`iaa`) and one explicit Command
> (`/orchestrate`). No agents, hooks, or MCP servers.
>
> **Testing (ZCode Desktop 3.14.3, GUI):** remote `url/zip/sha256` marketplace
> install (downloaded archive sha256 byte-verified against the marketplace
> pin), component inventory 1 skill / 1 command / 0 agents / 0 hooks / 0 MCP,
> `$iaa` and `/orchestrate` trivial runs with zero delegated agents,
> disable removes both from discovery, uninstall clean. Screenshots attached.
> Repo checks: `validate.py` OK, `build_dist.py` builds, `git diff --check`
> clean.
>
> **Version / registration:** new plugin `iaa` v0.1.1, category
> `productivity`, registered in the root `marketplace.json`
> (name/version/description/i18n aligned with the manifest).
>
> **Dependencies / network / permissions / side effects:** none / none / none /
> none at runtime. An optional, separately-documented integration step writes
> one marker-delimited block into `~/.zcode/AGENTS.md` only when run
> explicitly by the user.
>
> **Licensing / provenance:** MIT (`LICENSE`) with acknowledgements
> (`NOTICE`); all content originates from the public repository
> https://github.com/isakli05/iaa; no third-party code or assets.

## 7. Post-publication final-URL smoke checklist (for the release task)

1. `curl -fsSL -o /tmp/pub.zip https://github.com/isakli05/iaa/releases/download/v0.1.1/iaa-0.1.1-plugin.zip`
   → HTTP 200, sha256 == `621bdd1ffd24f40c736019e8b4d0961bc3dbda26b553ae72a425ea625e061e2c`.
2. Confirm `raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.remote.json`
   serves the merged document (main carries the merge) and its pin matches the
   published asset.
3. In ZCode (skills-dir integration disabled transactionally for the check):
   add that remote URL in Discover → install `iaa` 0.1.1 → verify inventory
   (1 Skill / 1 Command), `$iaa` trivial zero-agent run → disable → uninstall
   → remove marketplace.
4. `iaa doctor` exit 0 before and after; restore any transactional state.
5. Record results under `release-hardening/0.1.1/` (post-publication addendum).

## 8. Exact next publication task (execution order, owner-gated)

1. Owner reviews + merges `release/0.1.1-zcode-packaging` → main (no squash
   that would lose the validated commits' identity, or re-validate after).
2. `git tag -s v0.1.1 <release-commit> -m "İAA 0.1.1" && git push origin v0.1.1`.
3. `scripts/build-release.sh v0.1.1` → fresh `dist/`; record final SHA256SUMS.
4. Create GitHub release `İAA 0.1.1` on `v0.1.1` with the 6 assets and the
   §4 notes.
5. Run the §7 smoke checklist; append the addendum record.
6. Upstream PR: fork `zai-org/zcode-plugins`, branch from latest main, apply
   `upstream-pr.patch` (re-stage per §5 if main moved — keep the entry last,
   re-run their validators), Conventional Commit, §6 body, screenshots from
   the GUI evidence. Do not post to `zai-org/feedback#699` without separate
   owner approval (comment draft already prepared in
   `post-release/zcode-official/NETWORK-DIAGNOSTIC.md`).
