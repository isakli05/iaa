# Audit 05 — Publication Safety (Phase 8)

Scope: every file staged for the repository (canonical copies, lineage, fixture, tooling,
all audit/docs/research/web-pack files). Content-level scans, not filename-level.

## Scans performed (2026-09-22)

1. Secret patterns: API-key shapes (`sk-…`, `gho_`, `ghp_`, `github_pat_`, `AKIA…`,
   `AIza…`, `xox…`), PEM headers, bearer/authorization headers, `api_key=`/`password=`/
   `token=` assignments → **only false positives** (English phrase "ta**sk-specific**"
   matching `sk-[a-zA-Z0-9]{8,}`). No real credential material.
2. Emails → one `git@github.com` (the owner's own LCO repo SSH URL in audit/01; public
   information). No personal emails.
3. IP addresses → none (loopback mentions excluded; none besides).
4. Transcript/history leakage → no `.jsonl`, no `history*`, no sqlite anywhere in the repo.
5. Machine paths → `/home/isa/…` paths appear **only where architecturally relevant**
   (install locations, evidence-tree paths, sync procedures) per the task's allowance.
   No unrelated machine state (no other project names beyond the directly relevant LCO
   usage record, no home-dir inventory).
6. Promoted artifacts inspected line-level: `tests/tools/analyze_run.py` (no hardcoded
   private paths; generic transcript analyzer), `tests/fixtures/generated-PLAN.md` (toy
   "notectl" plan; carries the SDD directive header **by design** — that is its purpose as
   the adversarial fixture), lineage snapshots/diffs (policy text only).
7. Raw evidence **not included**: all campaign transcripts/runs/repos, evidence `.zip`,
   config backups, session metadata — remain local per docs/HISTORICAL-EVIDENCE-DISPOSITION.
8. Cost/model identifiers (glm-5.3, dollar figures) appear in docs as analytical evidence —
   intentional and non-sensitive (provider tier/account details never included; the Codex
   diagnostics doc's plan-tier line was already self-redacted upstream and only its
   condensed ADR ships).

## Residual items flagged for the future PUBLIC release (not blockers for private repo)

- audit/00 names both GitHub accounts (`isakli05` active, `isakayadev` inactive) — owner's
  own identifiers; consider whether the second belongs in a public doc (low sensitivity;
  owner's call at public-release time).
- Absolute home paths (`/home/isa`) — relevant now; a public README should additionally
  show `$HOME`-relative forms (packaging doc already does).
- The web-project-sources pack mirrors the same content and passes the same scans.

## Verdict

**PASS for private-repo publication.** No secrets, no raw transcripts, no credentials, no
unrelated personal data. Public-visibility change additionally gated by final-report §15
(PUBLIC RELEASE READINESS), which lists the non-secret blockers that remain (packaging,
coexistence testing, etc.).
