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
identity. GitHub main is the live source of truth; the uploaded knowledge
pack is orientation only.
```

## GitHub repository to connect

```text
isakli05/iaa
```

(https://github.com/isakli05/iaa — public. Uploaded context = orientation;
GitHub = current operational truth.)

## Knowledge upload

Upload exactly the files listed in `MANIFEST.md` (REQUIRED → RECOMMENDED →
OPTIONAL order). A ready-to-upload copy of the full set, in order, is
exported locally at `.claude-web-project-upload/` with
`UPLOAD-MANIFEST.txt`; upload that directory's contents as-is. The set
deliberately contains **no current-state snapshot** — with GitHub connected,
current state is always read live.

## First prompt to send inside the new project (copy/paste)

```text
Orient yourself: read the uploaded pack (start with CLAUDE-PROJECT-INSTRUCTIONS
and 00-READ-ME-FIRST) — it is durable orientation only and deliberately
contains no current-state snapshot. Then read CURRENT state live from the
connected GitHub repository: VERSION, README.md, docs/BACKLOG.md,
docs/COMPATIBILITY.md, docs/KNOWN-LIMITATIONS.md, the current releases/tags,
and the live state of any open PRs/issues the backlog names. Then answer,
without starting any implementation: (1) the current state of İAA in two
sentences; (2) what the backlog says we should work on next, split into
maintenance / research / product development / owner decisions; (3) which of
those are actually blocked vs merely waiting on external parties; (4) the
first decision you would put in front of me, with the evidence for it.
```

## After creation

- Do not upload `sources/` snapshots, `MANIFEST.md`, this file, or
  `11-CURRENT-STATE.md` (a dated repo-side provenance record) — GitHub
  serves all current and canonical material live.
- The pack is durable: no post-release refresh or re-upload is required.
  Current operational state is always read from the connected repository.
  Update a pack file only when its durable content itself changes (charter,
  architecture, governance, history) — never to chase versions, PRs,
  releases, or backlog status.
