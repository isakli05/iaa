# Research 02 — Collision Taxonomy

Four distinct collision classes for coexisting orchestration systems. "Conflict" is never
used unqualified. Local evidence (audit/04) grounds each class; the compatibility matrix
(docs/COMPATIBILITY-MATRIX.md) scores combinations per class.

## Class 1 — Installation / filesystem collision

Two systems fighting over the same files: install directory, symlink target, settings
mutation, hook replacement, installer overwrites.

- **MAO today:** installs only its own canonical dir + 3 self-owned symlink paths + 3
  marker-delimited shim blocks + 1 marker-owned env key. `manage.sh` refuses malformed
  markers, refuses to replace symlinks that don't resolve to canonical (M:120–152),
  preserves pre-existing depth values (`preserve-existing`), and never touches another
  framework's files (verified by mtime sweeps in all campaigns).
- **Residual local Class-1 facts:** graphify and MAO both edit the *same* global instruction
  files (different sections, both preserved — proven coexistence); ZCode's stale Superpowers
  6.2.0 cache with a broken /tmp symlink is an upstream/plugin-manager artifact, not an MAO
  collision.
- **Risk profile for public distribution:** LOW by construction, but any future packaging
  change (plugin install vs raw skills dir) reopens it (two MAO copies installed twice =
  duplicate canonical candidates).

## Class 2 — Invocation / namespace collision

Two systems registering the same command/name, or scope precedence resolving ambiguously
(personal vs project vs plugin; command vs skill; agent-name equality).

- **MAO today:** one un-namespaced user-scope skill name `multi-agent-orchestration`; no
  commands; no agents. No other installed system claims that name (verified). Superpowers
  skills are plugin-namespaced (`superpowers:*`), so SDD vs MAO is *not* a Class-2 collision
  locally.
- **Public risk:** REAL — any other user's plugin/skill named `multi-agent-orchestration`
  (or a second MAO installed at both personal scope and plugin scope) creates shadowing.
  Claude Code resolution order between scopes becomes load-bearing (see research/01).

## Class 3 — Trigger collision

Two model-invocable skills whose descriptions match the same request, so the model's skill
*selection* is contested — independently of names or files.

- **Local instance:** MAO ("use subagents, delegate, divide, parallelize…") vs Superpowers
  `subagent-driven-development` ("executing implementation plans with independent tasks") vs
  `dispatching-parallel-agents` ("2+ independent tasks") — all three match "execute this plan
  with subagents in parallel". Campaign 1 proved the model sometimes loads both; the archfix
  moved the contest from *in-context precedence* to *selection-time routing* (MAO's
  description now declares sole authority; the shim instructs not to combine).
- **Structural asymmetry:** Superpowers' SessionStart hook injects a must-invoke-skills
  bootstrap every session; MAO has no hook. MAO's counter is riding the user-instruction
  channel (CLAUDE.md/AGENTS.md), which Superpowers' own bootstrap defers to.
- **Public risk:** HIGH — this is the class that actually produced the historical failure,
  and any new orchestration plugin with a broad proactive description re-creates it. MAO's
  own proactive trigger ("when a complex task concretely benefits") is itself broad; its
  description's anti-trigger clause ("Not for small or tightly coupled work") is the current
  mitigation.

## Class 4 — Orchestration authority collision

Two correctly-installed, correctly-namespaced systems issuing **incompatible execution
policies for the same task** (agent count, review cadence, sequencing, ownership, nesting).

- This is the class campaigns 1–3 lived in: MAO says "adaptive, 3 implementers, 0-2
  reviewers by materiality, parallel where independent"; SDD says "fresh implementer per
  task, never skip task review, no parallel implementers, final whole-branch review".
  Both were installed fine, namespaced fine — and yet one task cannot obey both.
- **Resolution implemented:** per-task mutual exclusion by mode (user-explicit selection
  only), enforced at skill-selection time + artifact-provenance rule. Not composition, not
  precedence prose — *exclusion*.
- **Public risk:** INHERENT — any two authoritative workflow systems collide in this class
  whenever both claim a task. The only durable mitigations are (a) explicit user selection
  semantics, (b) never auto-loading a second authority, (c) artifacts cannot transfer
  authority. These are exactly MAO's three current rules (SKILL.md:12–21); the open question
  for public release is whether *other* systems reciprocate (SDD does not know MAO exists).

## Non-collision interactions (for completeness)

- **Mechanism vs policy:** Codex MultiAgentV2 / Claude subagents are mechanisms MAO *uses* —
  no policy conflict by construction (audit/04).
- **Bounded opt-in systems:** audit-council (`disable-model-invocation: true`) cannot be
  trigger-collided by the model at all; the strongest coexistence posture available in
  Claude Code today.
- **Retrieval layers:** graphify overlaps triggers with everything codebase-related but
  claims no execution authority; MAO explicitly defers to project orientation policies first
  (SKILL.md:33).
