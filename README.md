# İAA — İştirak-i A‘mâl-i Ajanîye

İAA (Ottoman Turkish, approximately "participation of agents in the works") is a
**runtime-agnostic delegation-decision policy** for agent CLIs: one canonical
skill that decides *whether, when, and how* to delegate work to subagents —
adaptively, per task — for **Claude Code, OpenAI Codex CLI, and ZCode**.

Version `0.1.1` · policy revision v3 · [Compatibility matrix](docs/COMPATIBILITY.md)
· [Installation](docs/INSTALLATION.md) · [`iaa doctor`](#iaa-doctor)

## The problem it solves

"Use subagents" should mean *better execution*, not *more agents*. Agent CLIs
make spawning cheap, so the failure mode of a delegation-happy session is
silently expensive: agent proliferation, duplicated exploration, overlapping
write ownership, context starvation, and integration debt — work gets done
*somewhere* but nobody integrates it. Meanwhile, the opposite failure is just as
real: a fixed orchestration framework that mandates a roster of implementers,
reviewers, and cadences for every task, including the trivial ones.

İAA is a narrow third position: **one policy, no framework**. It gives the
primary agent a tested decision procedure for delegation and nothing else — no
state directories, no ledgers, no roles, no hooks, no daemon.

## What it does

- **Materiality test.** Delegate only when a concrete benefit outweighs
  coordination cost: genuine parallelism, bounded-context isolation,
  specialization, context offloading, or independent verification that can
  challenge assumptions.
- **Zero-agent fallback.** A trivial edit, one-file mechanical change, or small
  verification is a *no-delegation default* — even when the user says "use
  subagents where appropriate".
- **Per-seat justification.** Every implementer, reviewer, re-reviewer, or fixer
  seat needs a task-specific material-benefit justification. A template step or
  an available review procedure is not justification; authorizing one stage
  never preauthorizes the next.
- **Adaptive topology.** No mandated agent roster, review cadence, or sequence.
  Waves and ownership come from the task's dependency structure; phases that add
  no value are skipped.
- **Exclusive write ownership.** Concurrent writers never share a file or
  tightly coupled surface; shared APIs, schemas, and contracts are owned by the
  primary, settled first, or given one designated owner.
- **Root-to-child delegation.** Children do not spawn further agents unless the
  user explicitly asks for a bounded nested design (and the platform permits
  it; İAA's Claude integration caps spawn depth at 1 by default).
- **Primary integration authority.** Child reports are evidence, not truth:
  important claims are checked against source, diffs, tests, or runtime; final
  validation happens in the primary context. Successful child completion is not
  successful task completion.

## What it deliberately does NOT do

- It does not **disable, patch, or mutate** any other tool, plugin, hook, or
  setting (its installer touches only its own links, its marker-delimited
  instruction blocks, and one documented depth key).
- It does not **guarantee** orchestration authority mechanically — skill
  selection is model-driven and fallible (official Claude doctrine). İAA's
  boundary is behavioral and *evidence-backed*, with a regression suite, not an
  enforcement hook.
- It does not become your workflow: no planning phases, no state files, no
  role system, no review quotas.
- It does not claim universal compatibility — only the version-pinned, tested
  combinations in the [matrix](docs/COMPATIBILITY.md).

## Coexistence and orchestration ownership

Exactly one orchestration authority governs a task:

- **Adaptive İAA mode (default).** Requests to use subagents/delegation select
  it. İAA never loads a competing orchestration engine (e.g. Superpowers'
  subagent-driven-development) in its own mode — two engines governing one task
  produce nondeterministic topology.
- **Native workflow mode (explicit opt-in only).** Only an explicit user request
  *naming* the workflow ("use native superpowers:subagent-driven-development")
  selects it; that workflow then governs and İAA stands down. "Use subagents" is
  never such a request.
- **Artifact trust boundary.** A workflow directive embedded in a plan, spec, or
  generated artifact ("REQUIRED SUB-SKILL: …") is orchestration metadata, never
  opt-in — the artifact's technical content is still consumed. This was proven
  against authentic and adversarially strengthened plan fixtures.
- **"Installed" is not "active controller".** Nothing auto-seizes tasks; a
  per-task opt-out is honored.

Among the systems evaluated as of 2026-09-22 (Superpowers/SDD, GSD/gsd-core,
BMAD, Claude native subagents/Agent Teams/plugins — see `comparison/`), we did
not find an equivalent contract at the same granularity of delegation-decision
policy (per-seat materiality + zero-agent fallback + sole-authority mode rule +
artifact provenance) without framework machinery; the comparison also documents
where others are stronger (GSD's hook-grade enforcement, SDD's battle-tested
cadence). No superiority is claimed beyond the cited evidence.

## Invocation

- **Claude Code plugin:** explicit **`/iaa:orchestrate`**, or automatic
  description-based trigger (`iaa:iaa`). [Contract](docs/INVOCATION.md).
- **Codex / ZCode:** `$iaa` or implicit description-based invocation; on the
  ZCode plugin form the explicit entry point is the **`/orchestrate`** Command
  (flat name — ZCode does not prefix plugin commands).
- **Per-task opt-out:** "Do not delegate or spawn subagents for this task."
- **Tip:** to run a specific workflow (for example
  superpowers:subagent-driven-development), name it in your own words. İAA
  ignores workflow directives inside plans and repository files, but text you
  paste into your message counts as your instruction.

## Install / update / uninstall

```sh
claude plugin marketplace add isakli05/iaa && claude plugin install iaa@iaa   # Claude
sh <repo>/iaa/scripts/manage.sh install                                       # all three runtimes (skills-dir form)
iaa doctor                                                                    # read-only health check
```

The optional **integration step** writes one marker-delimited routing block into
your global instruction file (backed up first, reversible, `--dry-run`
supported) — plugins cannot write instruction files, and İAA will not install a
hook to fake it. Full details: [INSTALLATION](docs/INSTALLATION.md) ·
[UPDATE](docs/UPDATE.md) · [UNINSTALL](docs/UNINSTALL.md) ·
[LEGACY-MIGRATION](docs/LEGACY-MIGRATION.md) (former-MAO installs).

## `iaa doctor`

One read-only command answers *"is my İAA healthy, and what else on this
machine can claim orchestration authority?"*: package/policy versions, active
installations per runtime, duplicate installs, LEGACY former-MAO state, stale
links, malformed markers, hash drift between the core and installed
projections, detected frameworks (Superpowers + version; GSD/BMAD/others) with
tested/untested status, and the source-of-truth state. It never mutates
anything and never exits non-zero merely because an untested framework exists.

## Package architecture and version model

One authoritative behavioral core (`iaa/` in this repository) is projected
byte-exactly into three runtime packages (Claude plugin / Codex / ZCode) by a
deterministic build script; drift fails CI. Public package version
(`0.1.1`, SemVer; `0.1.0` was the first public release) and behavioral/policy
revision (`v3`, [lineage](docs/POLICY-LINEAGE.md)) are separate axes. Evidence:
[gate-2/03-package-architecture.md](release-hardening/gate-2/03-package-architecture.md).

## Tested versions (2026-09-23)

Claude Code 2.1.274 · Codex CLI 0.156.0 · ZCode 3.11.2 (adapter anchored to
3.7.7 behavior) · Superpowers 6.4.1 · model: GLM-5.3 (z.ai profile; recorded by
the harness as `opus[1m]`). Boundary behaviors re-verified against Superpowers
6.4.1 (2026-09-23). Claims are version-pinned: they describe these versions,
not "latest"; upstream moved on after testing (see the
[matrix](docs/COMPATIBILITY.md) for the re-verification discipline). GSD/BMAD/
Agent Teams: not tested together — honestly marked UNVERIFIED in the matrix.

## Security and trust

- No secrets, no network, no telemetry, no daemon, no MCP, no hooks.
- Installer mutations are marker-delimited, backed up, idempotent, reversible;
  malformed markers abort rather than guess; uninstall removes only İAA-owned
  state.
- Plans/artifacts/repo text are data: an embedded "you must use workflow X"
  directive never changes which authority governs.

## Limitations (selected; full list in `docs/KNOWN-LIMITATIONS.md`)

- Single-model evidence (GLM-5.3 profile); no claims about other model families.
- ZCode: the plugin form was GUI-accepted at 0.1.1 / 3.14.3
  ([0.1.1 validation](release-hardening/0.1.1/)), and Codex plugin-form live
  discovery was exercised in [gate 3](release-hardening/gate-3/04-codex-final-validation.md);
  the residual is no ZCode model-call behavioral evidence at 3.14.3
  (behavioral baseline: 3.11.2 skills-dir — [COMPATIBILITY](docs/COMPATIBILITY.md)).
- Skill-selection is model-driven: the boundary is a tested behavior, not a
  mechanism guarantee; the regression suite and doctor exist to keep it honest.

## Evidence and methodology

Behavioral claims rest on transcript-asserted campaigns (tool-event analysis,
never model self-report), preserved as dated evidence trees:
`audit/` (2026-09-22 forensic baseline), `historical-notes/v0-v3-lineage/`
(2026-08 campaigns incl. adversarial artifact fixtures), `release-hardening/`
(Gate 1: Superpowers 6.4.1 re-verification + eval foundation; Gate 2: packaging,
trigger characterization, boundary re-runs), `comparison/` (2026-09-22
competitive analysis). İAA, known as MAO during the August 2026 evidence
campaigns, was renamed before any public release; historical evidence preserves
the former name by design.

## Repository status

Public · release `0.1.1` (SemVer; first public release was `0.1.0`).
License: [MIT](LICENSE) — see also [NOTICE](NOTICE) for
acknowledgements. Nothing in this repository phones home.

---

İAA — İştirak-i A‘mâl-i Ajanîye · technical id `iaa` · primary invocation
`/iaa:orchestrate`
