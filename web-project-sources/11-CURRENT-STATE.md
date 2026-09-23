# 11 — Current State (VOLATILE — the only pack file that goes stale by design)

> **Refreshed:** 2026-09-24 · describes `main` @ `479cea7`.
> **This file is a convenience snapshot. Live GitHub `main` supersedes it
> unconditionally** — check `VERSION`, `README.md`, `docs/COMPATIBILITY.md`,
> and `docs/BACKLOG.md` before relying on any value here. Every other pack
> file is stable and deliberately free of these values.

## Product state

- **Public package version:** `0.1.1` (SemVer; first public release 0.1.0,
  both 2026-09-23). Public repository: https://github.com/isakli05/iaa (MIT +
  NOTICE).
- **Policy revision:** **v3** (unchanged since 2026-08-27; every release so
  far proved D = NONE — core byte-identical across 0.1.0 → 0.1.1).
- **Tags/releases:** `v0.1.0-rc.1` (private era), `v0.1.0`, `v0.1.1`
  (latest). GitHub releases "İAA 0.1.0" and "İAA 0.1.1" with deterministic,
  sha256-pinned artifacts.
- **Release stance:** no next release planned; 0.1.1 left zero defects and no
  v0.1.2 is warranted (publication report §29).
- **Known open internal issue:** `static` CI fails on `main` pushes since the
  0.1.1 merge — the sha-pinned `plugin.zip` was built with zlib-ng and is not
  byte-reproducible on GitHub's stock-zlib runners (content-identical;
  artifacts and the distribution pin unaffected) → **IAA-BL-016**.

## Tested baseline (version-pinned; claim statuses in docs/COMPATIBILITY.md)

| Component | Tested at |
|---|---|
| Claude Code | 2.1.274 (skills-dir TESTED; plugin form PARTIALLY TESTED — live install + invocations + evals; SDD-contest under plugin-mode not re-run on the real machine) |
| Codex CLI | 0.156.0 (skills-dir + plugin forms TESTED, incl. live discovery) |
| ZCode | 3.11.2 skills-dir (TESTED, historical production use) · 3.14.3 plugin form (TESTED — 0.1.1 GUI acceptance) |
| Superpowers | 6.4.1 (coexistence boundary TESTED) |
| Model | GLM-5.3 via z.ai profile (single-model evidence) |

UNVERIFIED: GSD, BMAD, Agent Teams, non-GLM model families.
Upstream-latest context (2026-09-23): Claude Code 2.1.280, Codex 0.156.1,
ZCode 3.14.3, Superpowers 6.4.1 (= tested).

## Distribution forms (both per runtime; never both at once)

- **Claude plugin:** `claude plugin marketplace add isakli05/iaa && claude
  plugin install iaa@iaa`; explicit entry `/iaa:orchestrate`.
- **Skills-dir (all three):** `sh <repo>/iaa/scripts/manage.sh install`;
  health: `iaa doctor`.
- **Codex plugin / ZCode plugin:** via repo packaging; ZCode remote
  marketplace URL serves `packaging/zcode/marketplace.remote.json`
  (sha256-pinned to the v0.1.1 asset); explicit entries `$iaa` and the flat
  `/orchestrate` Command.

## Open external work (see docs/BACKLOG.md for full items)

- **zai-org/zcode-plugins PR #42** (İAA plugin submission): OPEN, no
  maintainer comments yet as of 2026-09-24 → **IAA-BL-001** (waiting on
  upstream review; rebase + re-validate if upstream `main` moves).
- **zai-org/feedback #699** (ZCode 3.14.x provider bug, IPv4-only
  ETIMEDOUT): open upstream, triage pending; İAA's confirming comment drafted
  but NOT posted — owner decision → **IAA-BL-002**.
- No GitHub issues/PRs open on `isakli05/iaa` itself (as of 2026-09-24).

## Backlog snapshot (live authority: docs/BACKLOG.md)

- ACTIVE: IAA-BL-001 (upstream PR #42 monitor) · IAA-BL-016 (CI sha
  reproducibility fix — owner decision on direction).
- NEXT / owner decision: IAA-BL-002 (#699 comment).
- PROPOSED validation: IAA-BL-003/004/005 (scenarios F/H/I; non-plan channels;
  non-SDD yield). RESEARCH: JEV (006), model families (007), topology aids
  (008), Agent Teams (009). STANDING maintenance: 010–012. DEFERRED: 013–015.

## Known environment constraint

ZCode GUI work needs the documented temporary single-IPv4 `api.z.ai` hosts
workaround while #699 is unfixed (TLS-verified, reversible; procedure in
`post-release/zcode-official/`).

---
**How to refresh this file (standing item IAA-BL-012):** update the date/SHA
header and each section from live `main` + `gh` checks; never patch single
values without re-checking the rest; leave all other pack files untouched
unless their stable content actually changed.
