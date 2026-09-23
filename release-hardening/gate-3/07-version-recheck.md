# Gate 3 — 07: Current Upstream Version Re-check

Date: 2026-09-23 (all sources live this date: npm registry, GitHub
releases/API, official changelogs, official docs). Distinguishing, per the
Gate brief: **locally tested** / **latest upstream** / **covered by
behavioral evidence**. No historical test record was changed.

## Results

| Component | Locally tested (evidence basis) | Latest upstream (2026-09-23) | Gap / action |
|---|---|---|---|
| Claude Code | **2.1.274** (all Gate-1/2/3 plugin, eval, install evidence) | **2.1.280** (npm `latest`/`next`, released 2026-09-22; npm `stable` dist-tag lags at 2.1.267) | 5 published versions behind (275–280; 279 never published). Claims remain pinned to 2.1.274. Notable per-feature floor: `CLAUDE_CODE_PLUGIN_DIRS` needs 2.1.280 — İAA uses nothing that new. No claim affected. |
| OpenAI Codex CLI | **0.156.0** (Gate-2 lifecycle + E9; Gate-3 dynamic probe) | **0.156.1** (released 2026-09-23T02:45Z; `alpha` channel 0.157.0-alpha.11) | one patch behind; claims stay pinned to 0.156.0 |
| ZCode | **3.11.2 installed** (adapter text anchored to 3.7.7 behavior; plugin baseline 3.7.1+) | **3.14.3** (2026-09-22; sequence 3.11.2→3.12.3→3.14.0→3.14.1→3.14.3; no GitHub releases — Z.ai CDN distribution) | 4+ releases behind; STRUCTURALLY COMPATIBLE claim is version-pinned to the validator + schema, which the 3.14 line has not changed (no engine/min-host field exists in the public schemas). GUI checklist should ideally run on a current version. |
| Superpowers | **6.4.1** (Gate-1 + Gate-2 §17 boundary evidence) | **v6.4.1** — CURRENT (latest release 2026-09-19) | none — tested version IS the latest |
| GLM-5.3 (z.ai profile) | all behavioral evidence | current model of record | single-model evidence discipline unchanged |

## Documented minimum-version floors checked (none affects İAA)

- Claude Code: no overall plugin-system minimum documented; per-feature
  floors all ≤ 2.1.274 except `CLAUDE_CODE_PLUGIN_DIRS` (2.1.280, unused).
  Plugin-eval needs ≥ 2.1.269 — satisfied.
- Codex: no plugin/marketplace CLI version floor documented publicly.
- ZCode: no host-version minimum documented anywhere public; the public
  plugin schemas carry no engine/min-host/compatibility field.

## Claims handling

1. `docs/COMPATIBILITY.md` "Tested environment baseline" stays exactly as
   is (version-pinned to the tested set above) — updated only with a dated
   re-verification note and the current-upstream context, not by moving
   any tested version.
2. The re-verification discipline (any version movement invalidates
   affected TESTED rows until boundary regression + doctor re-run) is
   unchanged and is the mechanism that handles the 2.1.280 / 0.156.1 /
   3.14.3 gaps honestly.
3. Superpowers 6.4.1 being the current latest means the boundary evidence
   needs no refresh for 0.1.0.
4. Known upstream quirk recorded: `obra/superpowers-marketplace` metadata
  still says 6.3.0 while the repo tag is 6.4.1 — irrelevant to İAA's own
   claims (we cite the release tag), noted for anyone cross-checking.
