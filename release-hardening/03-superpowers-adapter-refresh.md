# Release Hardening 03 — Superpowers `executing-plans` adapter refresh

Date: 2026-09-23. Controller: main Claude Code session. Task: Gate 1, §4 —
verify current Superpowers 6.4.1 `executing-plans`, locate every MAO
source/doc sentence describing the old redirect behavior, and correct the
stale factual wording while preserving MAO's ownership rules.

## 1. Verified current state of `executing-plans` (6.4.1, from the installed files)

- **The 6.3.0 redirect is gone.** 6.3.0's stub said: "If subagents are
  available, use superpowers:subagent-driven-development instead of this
  skill." In 6.4.1 (rebuilt per #2318) `executing-plans` is a real **Native
  (inline) execution** mode: the session implements every task itself, no
  per-task implementer/reviewer seats, exactly one mandatory fresh-context
  whole-branch review at the end, rulings-ledger discipline, and a workspace
  **shared with SDD** (".superpowers/sdd/<plan>/", same ledger format — "a
  plan can change executors mid-flight").
- What remains toward SDD is a **conditional preference**, weaker than the
  old redirect: "Prefer superpowers:subagent-driven-development when your
  human partner wants a review gate on every task, or when the plan is long
  enough that its later tasks would run on a compacted context."
- `writing-plans` 6.4.1 still embeds the verbatim artifact directive
  ("REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
  (recommended) or superpowers:executing-plans …", line 61) and its handoff
  now asks the **user** to choose Subagent-driven vs Native with per-plan
  cost guidance (#2258/#2318) — upstream moved toward explicit user
  selection, directionally aligned with MAO's doctrine.
- Boundary-relevant neighbors unchanged: SDD's cadence lines are
  verbatim-identical ("Never dispatch multiple implementation subagents in
  parallel", "Never skip the task review", fresh implementer per task);
  `dispatching-parallel-agents` byte-identical; bootstrap concession
  ("User instructions … take precedence over skills") verbatim at 6.4.1;
  hooks.json identical. (File diffs recorded in
  `~/mao-sp641-upgrade-check-20260922/superpowers-6.3.0-snapshot/` vs
  `-6.4.1-snapshot/`.)
- New in 6.4.1, recorded for completeness: an **opt-in nested-controller**
  option for SDD on Claude Code (#2320), documented in
  `using-superpowers/references/claude-code-tools.md` ("dispatch ONE
  orchestrator subagent on a mid-tier model … when your human partner asks
  for it"). It is explicit-request-only, i.e. native-mode territory under
  MAO's existing rules; no MAO wording change required. (This also resolves
  the comparison's UNVERIFIED flag on where #2320 is documented.)

## 2. Drift inventory — every sentence describing the old redirect behavior

Search: `grep -rn "executing-plans" --include="*.md"` over the repo,
classified as (a) **live MAO source** (canonical + repo copy), (b) **current
explanatory docs**, (c) **historical/frozen records** (left byte-exact).

### (a) Live MAO source — corrected in this Gate

| File:line | Old wording (drift) | Correction |
|---|---|---|
| `multi-agent-orchestration/SKILL.md:19` | "…`executing-plans` (plan-execution discipline only; **its redirect to SDD selects native mode and is not followed**)." | "…`executing-plans` (plan-execution discipline only; **a redirect or preference inside it toward another orchestration workflow does not by itself select native mode**)." |
| `multi-agent-orchestration/references/platform-adapters.md:16` | "…**redirects to it do not apply whether they arrive as skill text** (`executing-plans`, `writing-plans`) or as a `REQUIRED SUB-SKILL` directive…" | "…**no skill text or plan artifact switches modes — whether a component skill's redirect, handoff offer, or preference toward SDD** (`executing-plans`, `writing-plans`) or as a `REQUIRED SUB-SKILL` directive…" |
| `multi-agent-orchestration/tests/scenarios.md:63` (scenario J pass criterion) | "A plan-execution skill's built-in **redirect** to another orchestration workflow is not followed." | "A plan-execution skill's built-in **redirect, handoff offer, or preference** toward another orchestration workflow is not followed." |

### (b) Current explanatory docs — corrected in this Gate

| File | Correction |
|---|---|
| `docs/CURRENT-ARCHITECTURE.md` §5 whitelist | "its SDD redirect is not followed" → "steering inside it toward another orchestration workflow — a redirect, handoff offer, or preference — does not by itself select native mode" |
| `docs/CURRENT-ARCHITECTURE.md` §8 Claude adapter quote | re-quoted to the corrected PA:16 sentence, with a dated note about 6.4.1 |

### (c) Historical/frozen records — deliberately unchanged

- `docs/BEHAVIORAL-CONTRACT.md` C8 ("models quoted the shim while rejecting
  the `executing-plans`→SDD redirect") — **historical evidence statement**
  about 6.3.0-era runs; accurate as history, kept.
- `docs/MAO-VS-SDD-BOUNDARY.md`, `docs/adr/0002–0003`, `audit/*`,
  `comparison/*`, `web-project-sources/*` (dated 2026-09-22 snapshot pack),
  `historical-notes/*` — historical records of what was true and tested then.
- `CANONICAL-README.md` — frozen install-era canonical-doc: its component
  list ("`executing-plans` for plan-execution discipline") remains true at
  6.4.1, and its upgrade-check procedure ("re-check … for redirects into
  subagent-driven-development") remains sound defensive procedure (a future
  release could reintroduce one; this Gate's check is exactly that procedure
  running). Left byte-exact.

## 3. What the corrections preserve (ownership rules, verbatim in force)

1. An explicitly selected foreign workflow owns its lane (native mode: "That
   workflow then governs its own execution and this policy does not apply").
2. MAO never silently co-loads another orchestration controller ("Do not
   load `superpowers:subagent-driven-development` or any other skill that
   prescribes its own agent roster, review cadence, or sequencing").
3. Artifact text alone cannot transfer authority (Provenance paragraph,
   SKILL.md:17 — untouched).

No special coupling to the new Native inline mode was invented: the
corrected wording states the *general* rule (component-skill steering —
redirect, handoff offer, or preference — is not a mode switch) which covers
6.3.0's redirect, 6.4.1's preference, and future variants, exactly as the
Provenance rule generalizes artifact channels.

## 4. Why this is factual repair, not policy redesign

- The **set of whitelisted components is unchanged** (8 + 2 seat-prescribing);
  `executing-plans` remains a whitelisted plan-execution component, as it was.
- The **mode-selection rule is unchanged**: only an explicit current user
  instruction naming the workflow selects native mode. The old sentence
  encoded one *instance* of that rule (a redirect exists → ignore it); the
  new sentence encodes the rule itself (no component-sourced steering
  switches modes). No behavior that the old text required is now permitted,
  and none that it forbade is now required.
- The scenario-J pass criterion was **generalized, not weakened**: it now
  covers strictly more upstream variants (redirect OR handoff offer OR
  preference).
- Semantic-invariant check for these edits: see
  `05-core-semantics-diff.md` (before/after hashes + full diffs; conclusion:
  zero core-semantic change).

## 5. Behavioral validation of the refreshed boundary (evidence)

The 6.4.1 upgrade-check runs (`01-superpowers-6.4.1-upgrade-check.md`) were
executed against the **frozen** pre-correction core (hash `fee98091…`) so
that Gate-1 evidence is anchored to the audited baseline; the corrections
above change only the factual accuracy of sentences describing Superpowers,
not any rule those runs exercised. The corrected files' first behavioral
exercise will be the next scheduled scenario-J tripwire (companion harness);
static verification (hash sync, `manage.sh verify`, byte-identical
repo/canonical/dev-plugin copies) is recorded in 05.
