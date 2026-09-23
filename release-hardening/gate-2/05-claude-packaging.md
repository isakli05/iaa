# Gate 2 — 05: Claude Code Packaging

Date: 2026-09-23. Deliverable: a production-quality **private** plugin
prototype in `packaging/claude/`, generated deterministically from the repo
(`scripts/build-packages.sh`), public identity `iaa` / `/iaa:orchestrate`.

## 1. Package contents (and what is deliberately absent)

```
packaging/claude/
├── .claude-plugin/plugin.json     name "iaa", displayName "İAA — …", version from VERSION
├── skills/iaa/…                   byte-exact behavioral core (+ PROVENANCE)
├── skills/orchestrate/SKILL.md    explicit-only entry point -> /iaa:orchestrate
├── bin/iaa                        the management CLI (doctor/integrate/unintegrate)
├── README.md                      install/update/uninstall for this form
└── PROVENANCE                     generated marker
```

Absent by design: no MCP servers, no custom agents, no hooks (nothing runs at
session events), no daemon, no secrets, no `commands/` (legacy per current
docs), no evals directory in the public package (the eval suites live in the
repository; see §14). `claude plugin details iaa`: Skills (2), Agents (0),
Hooks (0), MCP (0), always-on cost ~0 tokens.

Rationale for `bin/iaa`: the plugin bin directory puts `iaa doctor` on the Bash
tool PATH in-session — the natural diagnostic entry point for plugin users
without any extra machinery. (Note: `bin/` is not distributable via claude.ai
organization settings; the GitHub-marketplace channel — our intended public
channel — supports it.)

## 2. Manifest and validation

- `plugin.json`: `name: iaa` (kebab-case, collision-checked — 02 doc),
  `version` stamped from `VERSION` (0.1.0-rc.1), `displayName` carries the full
  Unicode display name, `author`/`homepage`/`repository`/`keywords`.
- `claude plugin validate packaging/claude --strict` → **passes, zero
  warnings** (2026-09-23).
- Repo-root `.claude-plugin/marketplace.json` makes the repository itself a
  Claude marketplace (`claude plugin marketplace add isakli05/iaa` → install
  `iaa`); validated locally by adding it from the filesystem path.

## 3. Real install + invocation validation (disposable config, 2026-09-23)

Environment: `CLAUDE_CONFIG_DIR=<disposable>` with credentials copied; Claude
Code 2.1.274; provider profile glm-5.3 (model string `opus[1m]` as recorded by
the harness).

| Step | Result |
|---|---|
| `claude plugin marketplace add <repo>` | ok — marketplace `iaa` registered |
| `claude plugin install iaa@iaa` | ok — `installed_plugins.json` gains `iaa@iaa` 0.1.0-rc.1 with install path + **gitCommitSha** |
| `claude plugin details iaa` | 2 skills, nothing else; ~0 always-on tokens |
| live `/iaa:orchestrate` run (trivial typo task, disposable repo) | invocation resolved → **`Skill: iaa:iaa` loaded** → task completed inline, **0 agent spawns** (zero-agent fallback held), $0.10, transcript-verified |

## 4. The shim question — determination B (explicit global integration step)

Gate brief §7 required determining experimentally whether plugin-only
invocation preserves the tested orchestration-ownership boundary (A), or an
explicit global integration step is still required (B).

**Determination: B.** Evidence:

1. **Structural** (verified against current docs + local plugin system): a
   Claude plugin has no instruction-file component; a plugin root CLAUDE.md is
   not loaded; install is file-copy with no post-install write step. The
   instruction channel (`~/.claude/CLAUDE.md` managed block) — the layer every
   boundary campaign's routing rested on (ADR-0001/0002; 6+ samples quoting
   the shim sentence while rejecting embedded redirects) — cannot be
   reproduced by plugin installation.
2. **Behavioral (measured, with an honest correction)**: the plugin-eval
   sandbox has no user CLAUDE.md, so its measurements bound
   description-only/plugin-only routing. Gate-1's pilot measured skill-body
   loading at 1/2 on the positive class; Gate 2's larger characterization
   (10-trigger doc) revises this: on the obvious-positive class the skill
   fired **5/5** plugin-only and 5/5 under the shim simulation —
   description-only *triggering* is not materially weaker on obvious
   positives. What the sandbox cannot measure at all is contest behavior
   (skill-selection vs a co-installed competing orchestration engine), which
   is the property the instruction channel was proven to carry (6+ samples
   quoting the shim sentence while rejecting embedded redirects, ADR-0002).
   "Not weaker where measurable" ≠ "equivalent where it matters"; the
   boundary guarantee remains evidenced only in the shim configuration.
3. **Negative control**: a SessionStart hook injecting İAA text every session
   was already rejected in the baseline (it would run in native-mode sessions
   too — a semantics change; and it is Superpowers' channel, which İAA's
   coexistence posture deliberately does not adopt).

**Therefore the plugin ships with an explicit, user-approved integration
step** (`iaa integrate --runtime claude --mode plugin`), which:

- is never invoked by plugin installation itself (the plugin cannot and does
  not write `CLAUDE.md`);
- is reversible (`iaa unintegrate --mode plugin`, plus plugin uninstall);
- creates backups before every mutation (`.iaa-backup-<stamp>`);
- uses the same marker-delimited ownership (`<!-- BEGIN/END managed: iaa -->`)
  as the tested installer — the managed-block content is byte-identical
  (unit-tested, T6) and CI-enforced against `manage.sh`;
- supports `--dry-run`;
- is detectable by `iaa doctor` (marker presence/health, depth ownership
  state);
- creates **no** personal skill links in plugin mode, so it cannot produce the
  duplicate-activation hazard (and the doctor flags that hazard if a user
  creates it manually).

The routing guarantee is not weakened for packaging convenience: users who
want the tested configuration run one extra explicit command, exactly as the
"plugin distributes, script integrates" pattern predicted
(comparison/04 §4).

## 5. Update / uninstall lifecycle (validated)

- Update: `claude plugin update iaa` swaps the versioned cache dir; the
  integration block (user-owned marker state) is untouched; `iaa doctor`
  compares the cached skill core against the repo/provenance hashes and flags
  stale plugin copies.
- Uninstall: `iaa unintegrate --mode plugin` + `claude plugin uninstall iaa`
  (validated in the disposable config; §16 matrix).

## 6. Residual limits (honest scoping)

- Full SDD-contest boundary behavior under **plugin-mode + shim** (as opposed
  to the historically tested personal-skill + shim) has not been run on the
  real machine with Superpowers co-installed: the eval sandbox cannot co-load
  Superpowers (Gate-1 finding), and mutating the real machine's tested
  configuration just to re-label the channel was rejected as risk without
  corresponding value. The channel carries a byte-identical skill and a
  byte-identical shim; structural parity plus the §17 re-run of the boundary
  on the tested form is the evidence basis. Compatibility matrix carries
  plugin-mode as PARTIALLY TESTED for that reason.
- `skillOverrides` does not reach plugin skills (official): users cannot mute
  a plugin İAA the way they can mute a personal skill — documented in
  COMPATIBILITY/README; the explicit fallback is `disable-model-invocation`
  via editing the packaged skill or uninstalling.
