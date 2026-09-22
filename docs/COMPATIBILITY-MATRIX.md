# Compatibility Matrix

Scored per collision class (research/02): **I**nstallation, **N**amespace, **T**rigger,
**O**rchestration-policy. Values: OK / RISK / N-A / unknown. "Tested" = behavioral evidence
exists; "Documented" = policy text only. Local evidence base: audit/04, campaigns 1–3,
research/01. Machine context (labels corrected 2026-09-23 — original snapshot said
"Superpowers 6.3.0 installed … ZCode 3.7.7"; see comparison/00 Erratum E-1 and
release-hardening/01): Claude Code 2.1.274; Superpowers **6.4.1** installed
(upgraded from 6.3.0 on 2026-09-22 for the Gate-1 upgrade check — the campaign-era
behavioral evidence below was gathered against 6.3.0, the 6.4.1 revalidation against
6.4.1); Codex 0.154.0; ZCode **3.11.2** (adapter text anchored to 3.7.7 behavior);
GSD/BMAD absent.

| Combination | I | N | T | O | Tested? | Documented? | Safe? | Notes |
|---|---|---|---|---|---|---|---|---|
| MAO alone | OK | OK | OK | OK | YES (install smoke A–E; campaigns; LCO prod) | YES | YES | baseline; all three runtimes |
| MAO + Superpowers installed (idle) | OK | OK | RISK (mild) | OK | YES (every campaign ran with plugin enabled + SessionStart hook active) | YES | YES | distinct names; plugin namespaced; only shared surface = description contest + bootstrap pressure |
| MAO + SDD explicitly invoked (user names SDD) | OK | OK | OK | OK | YES (archfix B: 15 agents; boundary C: 11 agents; MAO absent both) | YES | YES | mutual exclusion by user selection |
| MAO explicitly invoked while Superpowers installed | OK | OK | RISK→controlled | OK | YES (A1/A2, boundary B/D: SDD never loaded, 6 samples + adversarial) | YES | YES-with-caveat | residual: model could mis-route (official doctrine: selection is fallible); scenario J tripwire |
| MAO + GSD installed | unknown (GSD npm installer mutates config/hooks; overlap unassessed) | OK (`/gsd-*`, `/gsd-core:*` namespaced) | unknown (GSD hooks: prompt/workflow guards may gate MAO's own dispatches!) | unknown (GSD guards are mechanism-grade; MAO prose) | NO | NO | **unknown** | GSD's PreToolUse workflow guards could constrain any agent activity inside GSD-managed repos; nothing tested |
| Explicit `/gsd-*` workflow while MAO installed | OK | OK | OK | OK-by-policy (generic by-name yield rule) | NO | partially (generic wording) | presumed-yes, unproven | P4 gap (ownership doc) |
| MAO + Claude native subagents (built-ins) | OK | OK | N-A | OK | YES (all Claude runs used Explore/general-purpose) | YES | YES | mechanism, not authority |
| MAO + Claude Agent Teams | unknown (teams flag-gated, off locally) | OK | unknown | unknown (a teammate is a full instance; lead's MAO vs teammate instruction drift untested) | NO | NO | **unknown** | experimental upstream; no project-level team config exists officially |
| MAO + multiple unrelated skills | OK | OK | RISK (any broad-description skill) | OK | partially (TDD/verification/finishing/executing-plans co-invoked in runs; graphify, audit-council coexist locally) | YES | YES-with-caveat | whitelist governs seat-prescribing components |
| MAO + unknown orchestration framework | unknown | OK (namespacing where plugin) | unknown | unknown | NO | generic wording only | **unknown by design** | degradation rule: no compatibility claimed; `mao doctor` (design/) would surface detection |

## Reading notes

1. "Safe" never means "installation succeeds"; it means no known incompatible execution
   policy with evidence or well-founded mechanism reasoning.
2. The two **unknown** rows that matter most for public release: **GSD** (hook-grade guards
   interacting with MAO's dispatches inside GSD-managed repos — untested, and GSD is the
   one surveyed system with *stronger* than prose enforcement) and **Agent Teams**
   (experimental, multi-instance). Both belong in the comparison/test phase before any
   "works alongside X" public claim.
3. Trigger class is MAO's permanently open flank in every row: by design MAO is
   model-invocable, so every new proactive neighbor re-opens T. Mitigations are the narrow
   description + sole-authority routing + scenario J (documented upgrade discipline).
4. No combination tested on non-glm-5.3 models (KNOWN-LIMITATIONS #7).
