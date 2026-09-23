# 01 — İAA Project Charter

## Product identity

İAA (Ottoman Turkish, "participation of agents in the works"; technical id
`iaa`) is a **runtime-agnostic delegation-decision policy** for agent CLIs —
currently Claude Code, OpenAI Codex CLI, and ZCode. One canonical skill
(~35 KB: SKILL.md + 2 references + installer + scenario contract) decides
*whether, when, and how* to delegate work to subagents. No code runs at
delegation time; no daemon, state, hooks, or agents of its own; it rides each
runtime's native subagent mechanism. Public and MIT-licensed since 2026-09-23.

## Product purpose

"Use subagents" should mean *better execution*, not *more agents*. Two failure
modes bracket the field: delegation-happy sessions (agent proliferation,
duplicated exploration, overlapping writes, integration debt) and fixed
orchestration frameworks (mandated rosters, cadences, and ceremony for every
task, including trivial ones). İAA is the narrow third position: **one policy,
no framework** — a tested decision procedure for the primary agent and nothing
else.

## The defining rules (behavioral core, policy revision v3)

1. **Materiality test** — delegate only when a concrete benefit (parallelism,
   bounded isolation, specialization, context offloading, independent
   verification) outweighs coordination cost.
2. **Zero-agent fallback** — trivial/coupled work stays primary *even when the
   user asks for subagents*. Zero agents is a valid, sanctioned outcome.
3. **Per-seat justification** — every implementer/reviewer/fixer seat needs a
   task-specific material-benefit justification; stages never preauthorize
   successors.
4. **Adaptive topology** — waves and ownership from task structure; no
   mandated roster, cadence, or sequence.
5. **Exclusive write ownership; shared contracts primary-owned.**
6. **Root-to-child delegation** — nesting only on explicit user request with a
   bounded benefit.
7. **Primary = final integration authority** — child reports are evidence, not
   truth; final validation in the primary context.
8. **Sole orchestration authority per task** — Adaptive İAA mode (default)
   never loads a competing engine; a native workflow runs only on an explicit
   by-name user request, and then İAA stands down.
9. **Artifact trust boundary** — workflow directives embedded in
   plans/specs/artifacts are metadata, never opt-in.
10. **Non-invasiveness** — İAA never mutates another framework, plugin,
    setting, or hook.

The full frozen invariant list: `release-hardening/gate-2/00-semantic-freeze.md`
(18 invariants, hash-anchored to the core).

## Non-goals (what İAA will not become)

- Not a workflow engine, methodology, agent framework, or execution runtime.
- No persistent task state, ledgers, roles, review quotas, schedulers,
  daemons, or hooks over foreign tools.
- No enforcement hooks — the boundary is behavioral and evidence-backed, not
  mechanism-guaranteed (a documented, honest residual risk).
- No universal compatibility claims — only version-pinned, tested combinations
  (`docs/COMPATIBILITY.md`).
- No per-runtime semantic forks — one byte-exact core projects into every
  package form.

## Scope

A policy layer over the subagent mechanisms of three runtimes (Claude Code,
Codex CLI, ZCode), distributed both as skills-dir installs and as plugin
packages. Anything below the policy (mechanisms) or above it (project
methodology) is out of scope by charter.

## Long-term direction (version-free)

Stay narrow; make each orchestration decision more reliable rather than the
system larger. Every capability is judged by one question (governance §3):
*does this make İAA's orchestration decision more reliable or effective, or
does it merely make İAA a larger framework?* Growth happens through evidence
(more model families, more validated runtimes, better regression coverage),
not through feature accumulation. Competitor ideas are adopted only under the
recorded KEEP/ADOPT/EXPERIMENT/DO-NOT-ADOPT discipline
(`comparison/FINAL-COMPARISON-REPORT.md` §17).

**Stable file** — no version-specific values (they live in `11-CURRENT-STATE.md`).
