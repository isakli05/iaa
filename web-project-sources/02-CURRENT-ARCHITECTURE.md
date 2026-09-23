# 02 — Architecture and Invariants

Two architectures exist: the **repository/package architecture** (how one core
becomes many distributions) and the **policy architecture** (how the primary
agent decides). Deep versions on GitHub: `docs/SOURCE-OF-TRUTH.md`,
`docs/CURRENT-ARCHITECTURE.md`, `docs/BEHAVIORAL-CONTRACT.md`.

## Repository / package architecture (stable)

```text
GitHub main  (isakli05/iaa)
└── iaa/                        THE behavioral core (all edits happen here)
    ├── SKILL.md                policy v3 — modes, boundary, decision core
    ├── references/             delegation-contract.md + platform-adapters.md
    ├── scripts/manage.sh       install / verify / uninstall (skills-dir form)
    └── tests/scenarios.md      behavioral contract, scenarios A–K
        │ deterministic build (scripts/build-packages.sh; parity CI-enforced)
        ├── packaging/claude    Claude plugin (skill iaa + /iaa:orchestrate entry)
        ├── packaging/codex     Codex plugin
        └── packaging/zcode     ZCode plugin (skill + /orchestrate Command)
        │ scripts/iaa deploy (stage → byte-verify → swap → provenance)
        └── ~/.local/share/iaa  deployed runtime source → symlinks into
                                ~/.claude|~/.agents|~/.zcode skills dirs
```

- **One authoritative core**, byte-projected everywhere; drift fails CI
  (`scripts/check-parity.sh`). A user must never get different İAA semantics
  from different channels.
- **Two version axes:** package `VERSION` (SemVer — which artifact) vs policy
  revision (which semantics; v3 since 2026-08-27). See `docs/POLICY-LINEAGE.md`.
- **Instruction-channel integration:** plugins cannot write user instruction
  files, so an explicit, reversible, marker-delimited "shim" step installs the
  load-on-trigger routing block — "plugin distributes, script integrates"
  (validated in Gate 2).
- `iaa doctor` (read-only) reports package/policy versions, installations,
  duplicate hazards, detected frameworks with tested/untested status.

## Policy architecture (what the primary agent does)

1. **Mode gate (first).** Delegation-flavored request → Adaptive İAA mode.
   Explicit by-name workflow request → that workflow governs; İAA stands down.
   Artifacts can never switch modes (provenance rule). In İAA mode no competing
   orchestration engine loads; 8 whitelisted Superpowers component skills stay
   individually usable; 2 seat-prescribing components only execute
   pre-authorized lanes.
2. **Interpret intent** — "use subagents" = apply the policy, not maximize agents.
3. **Orient proportionately** before delegating (obey project retrieval policies).
4. **Benefit test** — ≥1 of the five benefits, else stay primary (trivial +
   coupled work stays primary even on explicit delegation requests).
5. **Shape safely** — read-heavy = safest (Explore roles); write-heavy = disjoint
   exclusive write sets, shared contracts primary-owned/settled first;
   dependency-aware waves; skip valueless phases.
6. **Dispatch deliberately** — brief per the delegation contract (objective /
   scope / non-scope / context / dependencies / ownership / deliverable /
   validation / constraints + "Do not spawn subagents"); root-to-child;
   capability classes, never hardcoded model names; primary works meanwhile.
7. **Integrate, don't collect** — verify load-bearing claims against source /
   diffs / tests / runtime; resolve contradictions centrally; final validation
   in the primary. "Successful child completion is not successful task
   completion."

## Behavioral invariants

The normative contract is C1–C41 with verification labels (PROVEN /
DOCUMENTED / PLATFORM) in `docs/BEHAVIORAL-CONTRACT.md`; the frozen
semantic-invariant list (18) is `release-hardening/gate-2/00-semantic-freeze.md`.
Any semantic change must bump the policy revision and justify itself against
that list before shipping (governance rule, `docs/GOVERNANCE.md` §2).

## Platform adapters (mechanism mapping only)

- **Claude Code** — Explore/Plan/general-purpose; pre-dispatch mode check;
  Explore/Plan don't inherit CLAUDE.md → restate constraints in briefs; spawn
  depth harness-capped at 1 (managed key).
- **Codex** — explorer/worker/default built-ins; fresh-context spawns
  (`fork_turns: "none"`) preferred; nesting guard is policy-only.
- **ZCode** — Explore (no AGENTS.md injection → restate) / general-purpose;
  nesting platform-impossible.

**Stable file** — current versions and claim statuses live in
`11-CURRENT-STATE.md` / GitHub `docs/COMPATIBILITY.md`.
