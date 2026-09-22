# Source of Truth and File Map

## Verdict (2026-09-22, full evidence in `audit/03`)

- **Runtime source of truth (live, consumed by all three runtimes):**
  `~/.local/share/ai-agent-orchestration/` — README.md + `multi-agent-orchestration/` skill
  directory (SKILL.md v3, sha256 `fee98091…`). Unchanged since 2026-08-27 16:22.
- **Maintained/versioned source of truth (this repository):** `multi-agent-orchestration/`
  in the repo root is a **byte-identical copy** (hash-verified at migration; re-verify with
  `sha256sum` against the live tree) plus `CANONICAL-README.md` (copy of the install-era
  project README). The live directory is intentionally NOT modified by this baseline project.

## Why both, and how they stay in sync

The live tree has no version control; its only history was the evidence trees. Rather than
risk the sole live integration surface, the baseline project captures history *alongside*
the live tree. **Editing procedure until a future decision changes it:** edit the live
canonical file (README §"Edit once, refresh everywhere"), then copy into the repo and commit
(hash-verify). The repo's `multi-agent-orchestration/` subtree must always hash-match the
live tree; a mismatch means uncommitted drift.

## File map (repo)

| Path | What it is | Authority |
|---|---|---|
| `multi-agent-orchestration/SKILL.md` | the policy (modes, boundary, decision core) | **canonical** |
| `multi-agent-orchestration/references/delegation-contract.md` | brief/handoff/acceptance contract | **canonical** |
| `multi-agent-orchestration/references/platform-adapters.md` | Claude/Codex/ZCode adapters | **canonical** |
| `multi-agent-orchestration/scripts/manage.sh` | install/verify/uninstall | **canonical** |
| `multi-agent-orchestration/tests/scenarios.md` | behavioral contract A–K (manual scenarios) | **canonical** |
| `CANONICAL-README.md` | install-era project README (architecture, validation log, uninstall) | canonical-doc (copy) |
| `README.md` | repo readme | explanatory |
| `docs/CURRENT-ARCHITECTURE.md`, `docs/BEHAVIORAL-CONTRACT.md` | reconstruction (this audit) | explanatory, source-cited |
| `docs/adr/0000–0003` | condensed decisions from the evidence campaigns | historical-summary |
| `historical-notes/v0-v3-lineage/` | v0/v1 SKILL snapshots + all campaign diffs | historical-primary |
| `tests/fixtures/generated-PLAN.md` | authentic adversarial plan fixture (ADR-0003) | fixture |
| `tests/tools/analyze_run.py` | transcript→skill/spawn extractor (promoted from campaigns) | tooling |
| `audit/`, `research/`, `design/` | this baseline audit's working documents | audit records |

## Machine-local material deliberately NOT in this repo

All raw evidence trees stay in place under `/home/isa` (disposition:
`docs/HISTORICAL-EVIDENCE-DISPOSITION.md`): campaign transcripts/runs/repos, the collision
`.zip`, the 10 MAO-named config backups, session-transcript dirs, the Codex diagnostics raw
audit. Nothing was deleted or moved in producing this baseline.
