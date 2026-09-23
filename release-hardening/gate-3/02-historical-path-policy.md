# Gate 3 — 02: Historical Path / Privacy Normalization Policy

Date: 2026-09-23. Question (Gate brief §5): how are historical absolute
machine paths (`/home/isa/...`) handled in publication-bound material,
given Gate 2 deliberately preserved some?

## The rule (three classes)

**A. IMMUTABLE / HASH-PINNED PROVENANCE MATERIAL — preserve byte-exact.**
Changing these would falsify evidence or break recorded hashes/parity:

- `historical-notes/v0-v3-lineage/*.diff` (6 raw campaign diffs)
- `CANONICAL-README.md` + its byte-exact pack copy
  `web-project-sources/sources/CANONICAL-README.md` (sha256 `204d59b1…`;
  mirrors the deployed historical copy; its own provenance note labels it
  install-era)
- `audit/*` (dated 2026-09-22 forensic baseline documents)
- `identity-migration/*` (dated migration records of machine operations
  that happened at those absolute paths)
- `release-hardening/*` dated Gate-1/Gate-2 reports (records of what was
  observed/done at the time, incl. gate-2/04's normalization diagram)

**B. CURRENT PUBLIC DOCUMENTATION — portable forms only.**
README, docs/*, packaging READMEs, templates: verified (Gate 2 §13 and
re-verified in Gate 3 §09) to use `$HOME`/`~`-relative or `<repo>`-relative
forms exclusively; any new Gate-3 file follows the same rule.

**C. EXPLANATORY HISTORICAL SUMMARIES — normalize where provenance does not
depend on byte identity.**

Applied this Gate (the two non-canonical current-facing docs Gate 2 left
for the owner, per its §3 recommendation):

| File | Change | Occurrences |
|---|---|---|
| `docs/HISTORICAL-EVIDENCE-DISPOSITION.md` | `` `/home/isa/X` `` → `` `~/X` `` | 6 lines (evidence-tree locations) |
| `web-project-sources/07-HISTORY-AND-EVIDENCE.md` | same | 3 lines |

Meaning is unchanged (the same evidence trees, owner-relative); the local
username no longer ships in current-facing docs. These files are not
hash-referenced anywhere (checked: no sha256 of either file exists in any
manifest — the web-pack MANIFEST pins only `sources/` copies, which are
untouched).

## Post-normalization census (2026-09-23, whole tree, excluding .git)

87 remaining `/home/isa` lines, ALL in class-A documents: CANONICAL-README
×28 ×2 byte-exact copies = 56, `audit/` ×17, `identity-migration/` ×6,
`release-hardening/gate-2/04` ×2, `historical-notes` raw diffs ×6 (one
context line each). (A further 3 lines quoting these paths exist in this
policy document itself.) Each is an intentional historical/provenance
record.

## Exposure assessment (unchanged from Gate 2, re-stated)

The paths reveal only the local username (`isa`) — already implied by the
public GitHub handle `isakli05` — and local directory names of evidence
trees. No secrets, no other users, no sensitive locations. The owner may
still choose to accept them as-is (class-A default) or commission a
targeted redaction of specific documents later; nothing in class A blocks
publication.

## What was NOT done

- No raw diff, audit, migration record, or dated gate report was edited.
- No file whose hash is pinned in provenance/MANIFEST/parity records was
  touched (verified by `scripts/check-parity.sh` after the edit).
- No path was altered "for aesthetics" in historical artifacts.
