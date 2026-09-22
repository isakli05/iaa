# Comparison 08 — Owner Decision Register

Date: 2026-09-22. Only decisions that genuinely require product-owner choice. Where
evidence clearly favors one option technically, the recommendation is given and the item
is flagged; nothing here is manufactured — options that are plainly inferior are not
offered as equals.

---

## D1 — Trigger model for public İAA

**OPTION A — Explicit-only** (Claude `disable-model-invocation`; Codex
`allow_implicit_invocation: false`; ZCode: no flag — description discouragement only)
- Consequence: Class-3 trigger collisions vanish; users must know the name.
- Advantages: strongest coexistence posture available (audit-council precedent); zero
  trigger-listing footprint.
- Disadvantages: defeats the proactive half of the policy ("when a complex task
  concretely benefits" — install-time scenario E proved implicit benefit real); per-
  runtime asymmetry (ZCode can't do it natively); contradicts the shim's current wording
  (semantics change).

**OPTION B — Hybrid, status quo** (model-invocable + narrow description + anti-trigger
clause + instruction-channel shim)
- Consequence: the collision surface stays open permanently; discipline required
  (upgrade tripwires).
- Advantages: matches the product's purpose; 6+ samples incl. adversarial show it wins
  the contests that matter; now measurable cheaply (plugin eval trigger arms).
- Disadvantages: doctrinally "a request, not a guarantee"; every new broad neighbor
  re-opens risk.

**OPTION C — Hybrid with runtime-tuned dampeners** (per-runtime knobs: Codex yaml, Claude
`when_to_use` split, ZCode description-only)
- Advantages: marginal coexistence gains.
- Disadvantages: begins forking trigger *meaning* per runtime — against the core
  invariant.

**Technical recommendation: B**, with A documented as the emergency fallback, and the
decision *revisited against data* once E7's eval harness produces trigger-rate numbers
(false-positive/false-negative rates make this debate empirical for the first time). New
evidence since baseline: vendor convergence (Codex Ultra template gates proactive
delegation on "materially improve" — the same trigger philosophy) strengthens B's
viability; the official skillOverrides-plugin knob gap removes one mitigation A/B/C all
assumed available.

## D2 — Degree of runtime enforcement

**A — Pure prose (status quo).** Cheapest, portable, non-invasive; variance and
observability gaps remain (02 §4).
**B — Prose + opt-in read-only instrumentation** (`iaa doctor` + optional local logging
of İAA-relevant events; REPORT never mutate).
**C — Enforcement mechanisms** (SessionStart İAA-context injection every session;
PreToolUse guards on foreign skills).
- C breaks C11/P7 non-invasiveness or turns İAA into GSD; the analysis (02 §6) shows
  authority is not mechanically enforceable anyway — C buys the wrong thing at the
  highest price.

**Technical recommendation: B.** It closes the real gap (observability) without touching
authority semantics or non-invasiveness. A remains acceptable if even opt-in hooks are
unwanted; C is recommended against.

## D3 — Product scope: narrow policy vs growing toward a framework

**A — Remain a narrow policy layer** (current purpose; gaps C1–C3 solved only additively).
**B — Grow** (state/ledger, roles, phases, per-runtime adapters-as-code — i.e., become a
GSD/BMAD-class system).
- Evidence: every capability İAA lacks that frameworks have (ledger, roles, resume,
  guards) arrives bundled with framework costs İAA was created to avoid (02 §5, 06 C2–
  C4); İAA's confirmed differentiators (H2, H4, H8, H10) are all *features of narrowness*.

**Technical recommendation: A — remain narrow.** This is the clearest call in the
register: the comparison found zero evidence that growth increases differentiation and
strong evidence it erodes it.

## D4 — Foreign-orchestrator compatibility promise

**A — Best-effort, explicitly version-pinned** ("tested against Superpowers 6.3.0/6.4.1
on Claude Code + glm-5.3; unknown for others; doctor reports what it sees").
**B — Broad guarantee** ("works alongside any framework").
- B is unfalsifiable today: no competitor reciprocates awareness (03 §4); GSD/BMAD/
  Agent-Teams pairs have zero behavioral evidence.

**Technical recommendation: A.** Not a close call — B would be the only dishonest option
on the table. Owner's real choice is only how prominently to surface the untested list.

## D5 — Public identity / plugin name (**DECIDED 2026-09-23**: `İAA` / `iaa`)

**Decision (owner, final):** display name `İAA — İştirak-i A‘mâl-i Ajanîye`; short name
`İAA`; technical identifier / public plugin namespace `iaa`; primary public invocation
`/iaa:orchestrate` (reserved for Gate-2 packaging). Executed in
`identity-migration/` (same day). The marketplace-collision name search remains a
Gate-2 prerequisite.

Historical note — candidates evaluated before the decision (kept for the record):
`mao-orchestration` · `iaa` (chosen; collision-risky only as a user-scope name,
plugin-namespaced it is fine) · `adaptive-delegation` (category-descriptive). Original
open framing: kebab-case, unique across claude-plugins-official +
obra/superpowers-marketplace + ZCode public catalog + Codex directory; short enough to
keep `/iaa:orchestrate` usable; must not read as claiming authority
over other tools. Also decide: versioning scheme start (recommend 3.x to reflect
internal lineage v3).

## D6 — Public distribution form and sequence

**A — Script-primary first** (current manage.sh flow, publicized; plugin forms later).
**B — Plugin-primary** (marketplaces first; script still required for the shim — "plugin
distributes, script integrates").
**C — Dual-channel simultaneously.**
- Evidence: plugins cannot carry the shim (04 §4) — every form still needs the script;
  plugin form solves A1 namespacing + A3 evals + reach; dual doubles the duplicate-
  install surface until doctor ships; Codex universal directory requires 5+3 maintained
  test cases + identity verification (effort gate).

**Technical recommendation: B, staged** — Claude plugin prototype + eval suite first
(E7), doctor + duplicate checks before any marketplace listing, ZCode via the same
artifact (E12), Codex stays skills-dir+script until the eval suite is stable enough to
satisfy portal requirements. (A is acceptable but forfeits the namespacing fix; C is
premature before the doctor exists.)

---

## Decisions deliberately NOT in this register (technically clear, no owner choice)

- Adopt `claude plugin eval` for scenario regression (clearly superior; blocker A3).
- Fix adapter wording per Erratum E-2 (factual correction; blocker A5).
- Run the Superpowers 6.4.1 upgrade-check (E1) — already mandated by the frozen README's
  own discipline.
- Ship the compatibility matrix with version pins (A4) — the only honest form.
- Keep the shim under any plugin distribution (04 §4) — removal is contradicted by
  evidence.
- DO-NOT-ADOPT items of task §11 (framework machinery) — see FINAL report §17 table.
