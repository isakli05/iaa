# FINAL PUBLICATION REPORT — İAA 0.1.0

Date: 2026-09-23. Controller: the main Claude Code / GLM-5.3 session, sole
release controller per the owner-approved publication brief (no orchestration
framework used as controller; no subagents — every irreversible action was
performed by the main session). Executor of `PUBLICATION-RUNBOOK.md` as
modified by the owner's final decisions in the authorization prompt.

---

## 1. Final release commit SHA

`130c543a0f75e386f97f7fa70358615d1b414101` — "release: 0.1.0 (first public
release; policy revision v3)". Integrated into `main` by fast-forward (graph
permitted it; the owner prompt preferred fast-forward over the runbook's
`--no-ff`; history preserved — no squash). Post-release doc-only commit
`ef8f7c5` (COMPATIBILITY version cell) sits on main after the tag; the tag
itself is immutable at `130c543`.

## 2. LICENSE / NOTICE status

**OWNER-APPROVED: MIT + NOTICE.** Installed at repository root, byte-identical
to the reviewed Gate-3 candidates (`release-hardening/gate-3/license-candidate/`);
standard MIT text, copyright holder `isakli05` (the established public handle;
no invented identity). NOTICE carries exactly the two reviewed courtesy
acknowledgements (Superpowers fixture line provenance; ZCode validator
fetch-at-validation). SPDX `"license": "MIT"` stamped in all three plugin
manifests (zcode `UNLICENSED` → `MIT`); LICENSE + NOTICE copied by
`build-packages.sh` into every package plugin root; GitHub detects the license
as **MIT (MIT License)**. Re-run: license detection ✓, publication safety ✓,
package inclusion ✓, README links ✓, deterministic build with LICENSE/NOTICE
in artifacts ✓. Pre-install check: no repository change since the Gate-3
license review introduced a new third-party obligation (post-review commits
touched only İAA-authored docs).

## 3. Commit-email posture

Repository-local `user.email` = `40129610+isakli05@users.noreply.github.com`
(GitHub API-verified account ID; not guessed). `user.name` = `isakli05`.
All three publication commits attribute to the noreply address. No history
rewritten; the owner's personal address remains in pre-publication history as
disclosed and accepted in Gate-3 09 §3.

## 4. Final version

`0.1.0` everywhere (VERSION, all manifests, all projections, PROVENANCE
markers; parity green at 0.1.0). The applied flip was verified file-for-file
and line-for-line identical to the pre-validated
`prepared-0.1.0-version-flip.diff` (15 files, version stamps only).

## 5. Semantic parity result

**D = NONE.** All five core files byte-identical to the Gate-3 freeze table
before, during, and after publication (`73f7b887…` / `23184f0d…` / `849b769c…`
/ `21964702…` / `5fa9617e…`). All four projections byte-exact; shim parity
green; doctor 13/13; install matrix 14 pass / 0 fail / 2 documented skips.

## 6. v0.1.0 tag SHA

Annotated tag object `993c0df0262e181fd205c071947175c9834823e5` → commit
`130c543a0f75e386f97f7fa70358615d1b414101`. Pushed; verified remotely.
**Deviation disclosed:** the runbook specified `git tag -s` (signed); no GPG
signing key exists on this machine and key creation is an owner-level setup
decision — an **annotated** (`-a`) tag was created instead, satisfying the
authorization prompt's requirement ("annotated tag"). No tag replacement, no
force update; `v0.1.0-rc.1` verified intact (local + remote, still
dereferences `0d4c563…`).

## 7. GitHub visibility

**PUBLIC** (`isakli05/iaa`, default branch `main`). Owner-authorized by the
prompt; executed after all §13 preconditions (main verified, tag verified,
safety scans green, namespace re-check clean, deterministic artifacts
verified). Post-change verification: unauthenticated HTTP 200, README renders
from the public CDN, LICENSE detected as MIT, v0.1.0 tag publicly visible,
263 tracked files — no `dist/`, no credential-shaped files exposed.

## 8. GitHub release URL

**https://github.com/isakli05/iaa/releases/tag/v0.1.0** — title "İAA 0.1.0",
not a draft; notes factual (no unique/best/universal/deterministic/
cost-guarantee claims; ZCode plugin form labeled STRUCTURALLY COMPATIBLE).

## 9. Artifact filenames + SHA256

Built from the `v0.1.0` tag by `scripts/build-release.sh v0.1.0`; two
independent fresh-clone builds + the tag build byte-identical; release
assets download-verified against `SHA256SUMS`:

| Artifact | sha256 |
|---|---|
| `iaa-0.1.0-claude-plugin.tar.gz` | `ab380d3e94287b1e06703b79cca006069c8c68867f5b99ce5000dc709e049ea9` |
| `iaa-0.1.0-codex.tar.gz` | `a81c9a05fd55e0f23d61bd2326f90bd296d217137ab3bc10d8ea013b4c650213` |
| `iaa-0.1.0-src.tar.gz` | `869d4cf363f8246bc753cf100ae1cd70645f264cd68aa7e315d662a64cb3478f` |
| `iaa-0.1.0-zcode.tar.gz` | `db4f418cf9fe2b320cad375eb48ed289883eafac7232823ef28e6b49179ebbf5` |

Package-content verification: one behavioral core (single SKILL.md hash across
all packages + repo), no `/home/isa` paths, no secret material (the only
quick-grep hits were "ta**sk-s**pecific" prose; the authoritative scan is
green), no evals/transient staging, no raw session evidence, LICENSE/NOTICE
present in all three plugin roots, namespace `iaa` in all five manifests,
`orchestrate` entry skill present (claude + zcode packages).

## 10. Claude publication status

**PUBLISHED — LIVE (repo-root marketplace).** `.claude-plugin/marketplace.json`
(owner `isakli05`) went live at visibility change:
`claude plugin marketplace add isakli05/iaa` → `claude plugin install iaa@iaa`.
Clean-install smoke (disposable `CLAUDE_CONFIG_DIR`): marketplace add ✓,
install 0.1.0 ✓, `claude plugin details` shows 2 skills / 0 agents / 0 hooks /
~0 always-on tokens ✓, live `/iaa:orchestrate` trivial probe answered with
zero agents (skill content confirmed loaded from the plugin cache at 0.1.0 in
the session transcript) ✓, uninstall + marketplace remove leave no residue ✓.
**Manual action remaining (optional, per runbook):** submission to the
official `anthropics/claude-plugins-official` directory requires the web form
at https://clau.de/plugin-directory-submission — a user-interactive browser
step not performable from this session.

## 11. Codex publication status

**PUBLISHED — LIVE (GitHub-sourced install paths).** Clean-install smoke
(disposable HOME, only `auth.json` copied in): `codex plugin marketplace add
isakli05/iaa` resolved the public repo and installed `iaa@iaa` **0.1.0**
(Codex consumed the repo-root claude-marketplace shape — consistent with the
Gate-3 registry datum); cached core byte-identical to the authoritative
`iaa/SKILL.md`; live authenticated `$iaa` probe answered correctly with no
agents ("2 + 2 = 4.", 4.1 tokens); plugin + marketplace removal clean.
Per runbook, the universal ChatGPT+Codex directory program (5-pos/3-neg
maintained suite + identity verification) was deliberately **not** entered;
the GitHub-marketplace path is the 0.1.0 channel. Identifier: repo
`isakli05/iaa` (marketplace `iaa`, plugin `iaa@iaa`).

## 12. ZCode publication status

**PUBLISHED — LIVE in the runbook's stable-URL form; plugin-form label
STRUCTURALLY COMPATIBLE (unchanged).** The marketplace JSON is served at the
stable public URL
`https://raw.githubusercontent.com/isakli05/iaa/main/packaging/zcode/marketplace.json`
(`iaa 0.1.0 productivity`, HTTP 200). The `zai-org/zcode-plugins` PR leg was
**not** submitted: their CONTRIBUTING requires `README_CN.md` plus recorded
in-app behavioral exercise with screenshots — exactly the deliberately-unrun
GUI leg (submitting without it would overstate the evidence and violate the
authorization prompt's "Do not call it TESTED"). Manual action recorded below.

## 13. Namespace re-check result

Re-run twice (§3 pre-flight and immediately pre-publication): Claude official
marketplace 0 `iaa` matches; Codex `openai/plugins` no `iaa`; ZCode official
marketplace 0 `iaa` matches; GitHub `isakli05/iaa` is this project. npm `iaa`
occupied and irrelevant (npm not a channel). **CLEAR on every target channel.**

## 14. Clean-install smoke results

Claude: add/install/details/live-invoke/zero-agent/uninstall — all ✓
(disposable config; §10). Codex: add/install/list/byte-parity/live `$iaa`
probe/uninstall — all ✓ (disposable home; §11; one setup misstep disclosed in
§17). The owner's live environment was not mutated (no install performed into
real configs; doctor is read-only).

## 15. iaa doctor results

Repo checkout: "İAA doctor — version 0.1.0 (policy revision v3, commit
130c543)", exit 0, 0 actionable problems. Disposable Codex home: plugin
registration detected, no drift/duplicates, exit 0; `--json` valid JSON with
0 actionable findings. Live machine: single authoritative tree, one managed
block per runtime, no duplicate active copy, legacy-MAO migration guards
verified by doctor test T13 (13/13 suite green).

## 16. Unresolved / manual marketplace actions

1. **Claude official directory** — owner submits via
   https://clau.de/plugin-directory-submission (web form; optional per
   runbook; the repo-root marketplace is the designed 0.1.0 channel and is
   live).
2. **ZCode `zai-org/zcode-plugins` PR** — requires authoring `README_CN.md`
   and executing the ~5-minute GUI checklist (05-zcode §6) to generate the
   evidence their PR checklist demands; doing so would also upgrade the
   plugin-form label to TESTED. Until then the stable-URL marketplace form
   (live) is the published ZCode channel.

## 17. Incidents

None in categories A/C/D/E/F. Two disclosed execution notes, neither
affecting any published artifact or channel:
(a) the first Codex `$iaa` smoke attempt returned 401 because the disposable
`auth.json` was copied to the home root instead of `~/.codex/` — smoke-setup
error, fixed, probe then green;
(b) the v0.1.0 tag is annotated but not GPG-signed (no key on the machine;
runbook's `-s` form unfulfillable without an owner-level key decision) — see §6.

## 18. Rollback actions

None. No force push, no tag mutation, no retraction, no channel failure
requiring rollback.

## 19. Public documentation consistency

All relative doc links resolve; the repo's only current external URL
(`https://github.com/isakli05/iaa`) returns 200. Stale-wording scan after the
one-cell fix (COMPATIBILITY version cell, commit `ef8f7c5`): clean of private/
future-public wording, rc.1-as-current, old URLs, and MAO-as-current-identity
(dated historical/provenance references preserved per the class-A policy).
Install/update/uninstall/invocation/compatibility/legacy-migration pages all
reference the public repo and 0.1.0.

## 20. v0.1.0-rc.1 integrity

Intact throughout: annotated tag still dereferences `0d4c563…`, local and
remote; never moved, never replaced.

## 21. Core semantic change

**NONE.** Zero core-file bytes changed across the entire publication run
(license → LCO generalization → version flip → tag → publish); proven by hash
at every phase boundary (§5).

## 22. Exact public compatibility claims

- Claude Code **2.1.274**: plugin form — install + `/iaa:orchestrate`
  invocation + evals TESTED (matrix row: PARTIALLY TESTED for the plugin
  package per its precise scoping; skills-dir form TESTED).
- Codex CLI **0.156.0**: skills-dir + plugin forms TESTED (lifecycle, live
  discovery/invocation).
- ZCode **3.11.2** skills-dir form TESTED (historical production use);
  plugin form **STRUCTURALLY COMPATIBLE** (validator-passed; no in-app run).
- Superpowers **6.4.1** coexistence boundary TESTED; GSD/BMAD/Agent-Teams/
  other models UNVERIFIED. No universal-compatibility, determinism, or
  cost-guarantee claims anywhere (scope check green).

## 23. JEV roadmap note

Recorded only (no implementation, no architecture change, no dependency):
evaluate Jev by TypeSafe as an OPTIONAL typed decision backend for İAA's
materiality, seat-justification, and topology-selection gates; İAA retains
orchestration authority; native decision mode remains baseline/fallback;
benchmark native-vs-JEV before any adoption (Gate-3 Q26 constraints).

## 24. Recommended first post-release engineering objective

Execute the ~5-minute ZCode GUI checklist (05-zcode §6) on the current ZCode
build: it closes the last honestly-open validation leg, upgrades the
plugin-form claim to TESTED, and unblocks the `zai-org/zcode-plugins` PR —
the only channel where İAA currently has no behavioral evidence.

---

İAA v0.1.0 PUBLICATION:
  COMPLETE

CORE SEMANTIC INTEGRITY:
  PRESERVED
