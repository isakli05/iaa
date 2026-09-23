# Claude Project Setup — İAA

Exact values for creating the persistent Claude Web Project. This file is
owner-facing setup material — it is **not** part of the upload set.

## Project name (copy/paste)

```text
İAA — Product Development & Governance
```

## "What are you trying to achieve?" (copy/paste, evergreen)

This text deliberately names no version, no single work item, and no current
external dependency — those live in the backlog and current-state file, not in
the project's purpose:

```text
Run the long-term development and governance of İAA (İştirak-i A‘mâl-i
Ajanîye), my public, MIT-licensed delegation-decision policy for agent CLIs
(Claude Code, Codex CLI, ZCode). This project is permanent: across versions,
it orients to the product's charter and invariants, tracks the canonical
backlog and its evidence, supports research and architectural decisions under
a lightweight owner-gated lifecycle, and keeps release/validation claims
honest and version-pinned. Current work (an upstream plugin submission, an
upstream ZCode bug, validation and research candidates) is managed through
the repository backlog — docs/BACKLOG.md — never treated as the project's
identity. GitHub main, read live from the public repository, is the only
source of current state; the uploaded knowledge pack (and any connected
GitHub snapshot) is orientation only.
```

## Repository (live-read target)

```text
isakli05/iaa
```

(https://github.com/isakli05/iaa — public.) The assistant reads current
state from this repository **live over the public network** (procedure in
`00-READ-ME-FIRST.md`). Uploaded context = orientation; live GitHub =
current operational truth.

**Connecting it through the Project's GitHub integration is optional.** The
integration only adds a copy of selected files as of the last manual
"Sync now"; it carries no PRs, issues, releases, tags, or CI. If you connect
it: select only small canonical files (`VERSION`, `README.md`, `docs/`,
`iaa/`), never the large evidence trees; there is **no sync obligation**;
the assistant never treats its contents as current and always lets a live
read override it. Disconnecting it changes nothing.

**Assumption this setup depends on:** the repository stays public. If it is
ever made private, live public reads stop working and this access model
must be revisited before relying on the project for current state.

## Knowledge upload

Upload exactly the files listed in `MANIFEST.md` (REQUIRED → RECOMMENDED →
OPTIONAL order). A ready-to-upload copy of the full set, in order, is
exported locally at `.claude-web-project-upload/` with
`UPLOAD-MANIFEST.txt`; upload that directory's contents as-is. The set
deliberately contains **no current-state snapshot** — current state is
always read live from the public repository.

## First prompt to send inside the new project (copy/paste)

```text
Orient yourself: read the uploaded pack (start with CLAUDE-PROJECT-INSTRUCTIONS
and 00-READ-ME-FIRST) — it is durable orientation only and deliberately
contains no current-state snapshot. Then read CURRENT state live from the
public GitHub repository (not from Project Knowledge or any GitHub-integration
snapshot), following the live-read procedure in 00-READ-ME-FIRST: pin main's
HEAD SHA, then read VERSION, README.md, docs/BACKLOG.md,
docs/COMPATIBILITY.md, docs/KNOWN-LIMITATIONS.md, the current releases/tags,
CI state, and the live state of any open PRs/issues the backlog names. Name
the SHA you read. Then answer,
without starting any implementation: (1) the current state of İAA in two
sentences; (2) what the backlog says we should work on next, split into
maintenance / research / product development / owner decisions; (3) which of
those are actually blocked vs merely waiting on external parties; (4) the
first decision you would put in front of me, with the evidence for it.
```

## After creation

- Do not upload `sources/` snapshots, `MANIFEST.md`, this file, or
  `11-CURRENT-STATE.md` (a dated repo-side provenance record) — the public
  repository serves all current and canonical material live.
- The pack is durable: no post-release refresh or re-upload is required, and
  no GitHub-integration "Sync now" is ever required. Current operational
  state is always read live from the public repository.
  Update a pack file only when its durable content itself changes (charter,
  architecture, governance, history) — never to chase versions, PRs,
  releases, or backlog status.
