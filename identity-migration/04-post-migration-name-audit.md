# 04 — Post-Migration Name Audit (2026-09-23, after all renames)

Re-ran the full old-name search (`multi-agent-orchestration`, `Multi-Agent Orchestration`,
`Multi-agent orchestration`, `ai-agent-orchestration`, word `MAO`/`mao`, `mao-dev`,
old GitHub URL, old maintained path, old active runtime path) across the repo, the live
canonical tree, `~/.claude`, `~/.agents`, `~/.codex`, `~/.zcode`, `~/.config`, git remotes,
and GitHub. Result: **no remaining occurrence represents the current product**. All hits
fall in the permitted classes:

## Repository — see `OLD-NAME-REMAINING-REGISTER.md`
Frozen evidence trees (audit/, historical-notes/, release-hardening/01–03, fixtures,
eval results/), §4C provenance framings, foreign-repo filenames, labeled LEGACY code,
and this audit set itself.

## Live canonical tree (`~/.local/share/iaa/`)

| Hit | Class |
|---|---|
| `iaa/scripts/manage.sh` LEGACY literals | C — legacy-migration detection code |
| `README.md`: `~/mao-sdd-archfix-20260827/` path + "known as MAO … at install time" | A/B — historical evidence path + provenance framing |

## `~/.claude`

| Hit | Class |
|---|---|
| `projects/**` (661 files), `history.jsonl`, `file-history/**`, `paste-cache/**`, `shell-snapshots/**`, `sessions/**`, `todos/**` | B — session/conversation history (includes this migration's own pasted task text); never rewritten |
| `security/log.txt`, `security/security_warnings_state_*.json` | B — harness-generated session logs referencing the pre-rename working path |
| `CLAUDE.md.multi-agent-orchestration-backup-*` (3), `settings.json.multi-agent-orchestration-backup-*` (1), `CLAUDE.md.iaa-backup-20260923T014115+0300[-1]` (2) | A/E — historical backups (filenames document what was backed up when) |
| `skills/iaa` symlink | current identity ✓ |

## `~/.agents`, `~/.zcode`

| Hit | Class |
|---|---|
| `~/.zcode/cli/agents/sess_*/…/transcript.jsonl` | B — historical ZCode agent transcripts |
| `AGENTS.md.multi-agent-orchestration-backup-*` (3 each) + new `AGENTS.md.iaa-backup-20260923T014115+0300[-1]` | A/E — historical backups |
| `skills/iaa` symlinks | current identity ✓ |

## `~/.codex`

| Hit | Class |
|---|---|
| `config.toml` `[projects."/tmp/multi-agent-orchestration-test-*.kHHQnF"]` | C/E — stale Codex-internal trust entries for deleted /tmp test repos from the 2026-08 campaigns; editing Codex-owned config beyond identity scope was deliberately avoided |
| `sessions/**`, `history.jsonl`, `logs_*.sqlite` | B — conversation history |
| `AGENTS.md.multi-agent-orchestration-backup-*` (3) + new `.iaa-backup-*` (2) | A/E — historical backups |
| `AGENTS.md` managed block | current identity ✓ (1 marker pair, `managed: iaa`) |

## `~/.config`

| Hit | Class |
|---|---|
| dolphin session cache; browser-extension bundles | unrelated third-party text (substring coincidence) |
| `iaa/claude-depth.state` | current identity ✓ (migrated from `ai-agent-orchestration/`) |

## Git / GitHub

- Local: repo at `/home/isa/projects/iaa`; `origin` → `https://github.com/isakli05/iaa.git`;
  no old-name remotes. GitHub: renamed repository, **PRIVATE**, old URL redirects.
- Home top-level: `~/mao-sdd-archfix-20260827/`, `~/mao-sdd-artifact-boundary-20260827/`,
  `~/mao-sp641-upgrade-check-20260922/` — A — machine-local historical evidence trees,
  retained by the evidence-disposition policy.
- `~/iaa-identity-migration-rollback-20260923T014102+0300/` — this migration's rollback
  backup (contains pre-rename copies by design).

## Verdict

Success criterion met: zero MISSED RENAME findings. Every remaining old-name occurrence
is HISTORICALLY REQUIRED (evidence, backups, transcripts, foreign filenames, provenance
framing) or explicitly-labeled LEGACY detection code.
