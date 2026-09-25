# Compatibility Matrix (public)

Every claim below is version-pinned and dated. Statuses:
**TESTED** (behavioral evidence exists at these versions) ·
**PARTIALLY TESTED** (core path evidence + structural parity, one channel unexercised) ·
**STRUCTURALLY COMPATIBLE** (mechanism-level reasoning only, no behavioral run) ·
**UNVERIFIED** (no evidence; nothing claimed) · **KNOWN CONFLICT** · **NOT APPLICABLE**.

Nothing on this page claims universal compatibility. "Safe" always means "no
known incompatible execution policy with evidence or well-founded mechanism
reasoning" — never "installation succeeds".

## Tested environment baseline (2026-09-23)

| Component | Version |
|---|---|
| Claude Code | 2.1.274 |
| OpenAI Codex CLI | 0.156.0 |
| ZCode | 3.11.2 — skills-dir behavioral baseline (TESTED evidence); auto-updated to 3.14.3 on 2026-09-23 (plugin-form GUI observation only — no model-call evidence at 3.14.3; post-release/zcode-official/) |
| Superpowers plugin | 6.4.1 |
| Model (all behavioral evidence) | GLM-5.3 via z.ai provider profile (recorded by the harness as `opus[1m]`) |
| İAA | package 0.1.1, policy revision v3 |

## Combinations

| Combination | Status | Evidence / note |
|---|---|---|
| İAA alone (skills-dir form, all 3 runtimes) | **TESTED** | install smoke A–E; 2026-08 campaigns; production usage; E9 live probe (Codex, 2026-09-23) |
| İAA + Superpowers installed (idle) | **TESTED** | every campaign ran with the plugin enabled + SessionStart bootstrap active |
| İAA governing while Superpowers installed (delegation-flavored task; artifact-embedded directives) | **TESTED** | runs J/D ×2 eras (6.3.0, 6.4.1): SDD never loaded, directives treated as metadata; Gate-2 §17 re-run |
| Explicit SDD request while İAA installed | **TESTED** | run K both eras: SDD governs full cadence, İAA never loads |
| İAA Claude **plugin** package (skill + `/iaa:orchestrate`) | **PARTIALLY TESTED** | live install + explicit invocation + trigger/anti-overdelegation evals (2026-09-23); SDD-contest under plugin-mode specifically not re-run on the real machine (channel carries byte-identical skill+shim; see gate-2/05 §6) |
| İAA Codex plugin form | **TESTED** | full lifecycle validated locally (0.156.0, Gate 2); live authenticated session discovers `iaa:iaa` from the plugin cache and explicit `$iaa` invocation loads the core (2026-09-23, Gate 3, gate-3/04); behavioral delegation evidence carried by the byte-identical core via the skills-dir form (campaigns + E9) |
| İAA ZCode plugin form | **TESTED** (0.1.1 package, 3.14.3, 2026-09-23) | owner-executed GUI acceptance with filesystem byte corroboration (`release-hardening/0.1.1/`): remote `url/zip/sha256/path` marketplace install of 0.1.1 (downloaded archive sha256 == pinned `621bdd1f…`), exactly one `iaa` Skill + one `/orchestrate` Command (0 agents/hooks/MCP), `$iaa` and `/orchestrate` trivial runs with zero delegated agents, disable removes both from discovery, uninstall clean. History: the 0.1.0 package at 3.14.3 failed the one-skill contract (`orchestrate` exposed as a second skill — ZCode documents `disable-model-invocation` for Command frontmatter, not Skills) and its raw-URL marketplace could not resolve remotely (post-release/zcode-official/); both corrected in 0.1.1. The GUI window used the documented temporary single-IPv4 `api.z.ai` hosts workaround for the unrelated ZCode 3.14.x provider issue (zai-org/feedback#699) |
| Former-MAO (LEGACY) installation → İAA migration | **TESTED** | identity migration 2026-09-23 on the real machine + unit tests T3/T13 |
| Claude native subagents (Explore/Plan/general-purpose) | **TESTED** | all Claude runs use them (mechanism, not authority) |
| Codex native MultiAgentV2 (`spawn_agent`, `fork_turns` none/all/"N") | **TESTED** | 2026-08 campaigns + E9 numeric probe 2026-09-23 |
| GSD / gsd-core | **UNVERIFIED** | not installed here; hook-grade guards untested against İAA dispatches; no compatibility claimed either way |
| BMAD | **UNVERIFIED** | absent; no evidence |
| Claude Agent Teams | **UNVERIFIED** | experimental, flag-gated, off locally; `iaa doctor` detects the effective flag state read-only across observable settings sources (detection, not tested behavior — IAA-BL-009/BL-020) |
| warp codex plugin (`orchestration`) | **UNVERIFIED** | detected by `iaa doctor`; Oz/cloud-focused; not exercised together |
| Other/unknown orchestration plugins | **UNVERIFIED** | by design: no compatibility claimed for unknowns; doctor reports what it detects; İAA's degradation rule is prose-level (sole-authority + yield) |
| Non-GLM model families | **UNVERIFIED** | all behavioral evidence is single-model (KNOWN-LIMITATIONS #7) |

## Known frictions (not conflicts)

- Same-named **personal skill + plugin skill both load** on Claude (official
  behavior): İAA treats installing both forms of itself as a duplicate-install
  error — `iaa doctor` flags it; docs forbid it.
- `skillOverrides` does not reach plugin skills (official): a plugin İAA cannot
  be muted per-skill from user settings the way a personal skill can.
- Trigger overlap with any future broad proactive neighbor is İAA's permanently
  open flank (model-driven selection is fallible per official doctrine);
  mitigations: narrow description, sole-authority routing, scenario-J tripwire
  regression, `iaa doctor` Class-3 awareness.
- Backup **symlinks left inside a skills directory** are discoverable as extra
  skills (observed live 2026-09-23): the doctor reports them as a duplicate
  hazard with a removal hint.

## Re-verification discipline

Any version movement in the left column (Claude Code, Codex, ZCode, Superpowers,
model) invalidates the affected TESTED rows until the boundary regression
(`release-hardening/evals/iaa-dev-plugin/evals/companion/`) and doctor are
re-run. That discipline is the price of honest version-pinned claims.

Upstream-latest context (re-checked 2026-09-23, gate-3/07): Claude Code
2.1.280, Codex CLI 0.156.1, ZCode 3.14.3, Superpowers 6.4.1 (current — the
tested version). The table above describes the **tested** versions only; it
is not a claim about latest upstream releases.
