# Release Hardening 05 — Core-semantics immutability check

Date: 2026-09-23. Task: Gate 1, §6 — prove that no core MAO orchestration
semantics changed in this Gate.

## 1. Before/after hashes (behavioral-core files)

| File | Before (frozen v3, = live tree at Gate start) | After (this Gate) |
|---|---|---|
| `multi-agent-orchestration/SKILL.md` | `fee980912f3478743d28fbcc038dfafc814ba5a1313ed2a3873d4c858729532b` | `ade65cf71c4e4371ee3e526df0e18abf6178e63e81573fa3e3cf51ab0dd42633` |
| `multi-agent-orchestration/references/delegation-contract.md` | `23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632` | **unchanged** |
| `multi-agent-orchestration/references/platform-adapters.md` | `eba2257ada2973d3a4fcb890bd97a6d550b4ac6645fa880e902ae123eef6d018` | `e88169cf4c022991f4baaa9b59dc8da35ce1bfd3ad6f25307dc0c76bd91e3eb7` |
| `multi-agent-orchestration/scripts/manage.sh` | `fce2d7bb8d9bcc06797f3c4cfea0b1cd7b5967ab6bbbd62b43c9a66f506e9484` | **unchanged** |
| `multi-agent-orchestration/tests/scenarios.md` | `94f1ad401bb504c596205e45a79cf3ab42e4277c1ee086623cfe7b6dea1a37c4` | `dc71b2d212c8f78a590f906f438d8c1cead1ccc6f45a18f545499464903351f7` |
| `CANONICAL-README.md` | `4d920ac97aa31b8b1cdf443e7e25f8941d8439643bb32c1f60f88c21e9ce09ff` | **unchanged** |

Delegation contract, installer, and canonical README are byte-identical. The
three changed files changed in exactly **four sentences** (full diff below,
§3). Everything else in the tree — docs updates are explanatory, and
`release-hardening/` is new material — does not feed runtime behavior.

## 2. Synchronized maintenance-source handling (documented per the Gate's git policy)

The task permitted live-runtime-source changes only for the explicitly
approved factual adapter corrections. Per `docs/SOURCE-OF-TRUTH.md`'s editing
procedure (edit live canonical → copy into repo → hash-verify), the same four
sentences were applied to `~/.local/share/ai-agent-orchestration/` AFTER all
behavioral runs for this Gate had finished (so every Gate-1 behavioral sample
ran against the frozen baseline hash `fee98091…`). Post-sync verification
(actual output, 2026-09-23):

```text
--- hash comparison live vs repo ---
MATCH  SKILL.md                              ade65cf71c4e4371ee3e526df0e18abf6178e63e81573fa3e3cf51ab0dd42633
MATCH  references/delegation-contract.md     23184f0d3d861fc77dfab113c5a594f890492c2e9e7f6059d7cdb1fc3e258632
MATCH  references/platform-adapters.md       e88169cf4c022991f4baaa9b59dc8da35ce1bfd3ad6f25307dc0c76bd91e3eb7
MATCH  scripts/manage.sh                     fce2d7bb8d9bcc06797f3c4cfea0b1cd7b5967ab6bbbd62b43c9a66f506e9484
MATCH  tests/scenarios.md                    dc71b2d212c8f78a590f906f438d8c1cead1ccc6f45a18f545499464903351f7
dev-plugin copy: byte-identical to live canonical (diff -r, empty)
manage.sh verify: 8/8 ok (3 links, 3 shims, Claude spawn depth 1, description 249 chars)
quick_validate.py: "Skill is valid!"
```

The three runtime symlinks were untouched (same inodes/targets; verify
re-confirmed resolution to the canonical root). The dev-plugin eval copy was
re-synced from the live tree after the edit, so all three copies of the core
in the repository (canonical-in-repo, dev-plugin, and the live tree it
mirrors) carry the corrected text and identical hashes.

## 3. The complete source diff, sentence by sentence

**(a) `SKILL.md` — whitelist sentence, component-skill parenthetical only:**

- old: "`executing-plans` (plan-execution discipline only; **its redirect to
  SDD selects native mode and is not followed**)."
- new: "`executing-plans` (plan-execution discipline only; **a redirect or
  preference inside it toward another orchestration workflow does not by
  itself select native mode**)."

**(b) `platform-adapters.md` — Codex `fork_turns` bullet:**

- old: "…If parent history is genuinely needed, **inherit only the smallest
  useful recent-turn suffix with a positive `fork_turns` value**; use
  `fork_turns: "all"` only when the child needs the full parent-thread
  history. …"
- new: "…**Note that omitting `fork_turns` is not a fresh-context spawn — it
  defaults to full history.** If parent history is genuinely needed, **pass
  the smallest useful number of recent turns as a positive integer string
  (for example `fork_turns: "3"` forks only the most recent three turns)**;
  use `fork_turns: "all"` only when the child truly needs the full
  parent-thread history. …"

**(c) `platform-adapters.md` — Claude pre-dispatch mode-check bullet:**

- old: "…MAO mode never invokes `superpowers:subagent-driven-development`,
  **and redirects to it do not apply whether they arrive as skill text
  (`executing-plans`, `writing-plans`) or as a `REQUIRED SUB-SKILL`
  directive…**"
- new: "…MAO mode never invokes `superpowers:subagent-driven-development`;
  **nothing arriving as skill text or plan artifact switches modes — not a
  component skill's redirect, handoff offer, or preference toward SDD
  (`executing-plans`, `writing-plans`), and not a `REQUIRED SUB-SKILL`
  directive…**"

**(d) `tests/scenarios.md` — scenario J pass criterion, final sentence:**

- old: "A plan-execution skill's built-in **redirect** to another orchestration
  workflow is not followed."
- new: "A plan-execution skill's built-in **redirect, handoff offer, or
  preference** toward another orchestration workflow is not followed."

## 4. Invariant verification (task §6 list, one by one)

| Invariant | Where it lives | Changed? |
|---|---|---|
| benefit/materiality test | SKILL.md "Require a concrete benefit" (5-benefit taxonomy, no-delegation defaults) | **No** — section byte-identical |
| per-seat justification | SKILL.md seat paragraph ("Every implementer, reviewer, re-reviewer, or fixer seat…") | **No** — byte-identical |
| zero-agent fallback | SKILL.md trivial-edit/tightly-coupled defaults | **No** — byte-identical |
| topology-shaping rules | SKILL.md "Shape the work safely" (ownership blocks, waves) | **No** — byte-identical |
| ownership model | SKILL.md modes ¶1–2 + DC | **No** — byte-identical |
| root-to-child constraint | SKILL.md "Dispatch deliberately" + DC "Do not spawn subagents" | **No** — byte-identical |
| primary integration authority | SKILL.md "Interpret intent" + "Integrate, do not merely collect" + DC acceptance | **No** — byte-identical |
| SDD/foreign-controller exclusivity | SKILL.md modes ¶1 ("Do not load … two engines … nondeterministic topology") | **No** — byte-identical; edit (a) touches only the *component whitelist* sentence, which enumerates skills that are explicitly NOT competing authorities |
| artifact provenance/trust principle | SKILL.md Provenance ¶ | **No** — byte-identical |
| anti-overdelegation objective | SKILL.md description + "smallest useful number" + C24 | **No** — frontmatter description untouched (247 chars, within ZCode ~250); body untouched |

Direction-of-change check on the four edited sentences: (a) and (c) each
*generalize* an instance of the existing exclusivity/provenance rules to cover
6.4.1's renamed mechanisms — no behavior permitted that was forbidden, none
forbidden that was permitted; (b) preserves fresh-context-first and makes the
default-inheritance fact explicit (strictly stronger for the principle);
(d) widens the tripwire's coverage (strictly stronger test, not weaker).

## 5. Verdict

**ZERO core-semantic changes.** All permitted edits are confined to
factually-incorrect platform-adapter wording (b), stale factual descriptions
of Superpowers' current component behavior (a, c, d), explanatory
documentation (docs/ — no runtime effect), and new regression/eval
infrastructure (`release-hardening/` — no runtime effect). No invariant from
the task's list was altered, weakened, or strengthened; no owner/design
decision was required or bypassed.
