# 02 — Rename Map (identity-only; final decision, not reopenable)

## 1. Identity tokens

| Old token | New token | Notes |
|---|---|---|
| `MAO` (word, prose) | `İAA` | capital dotted Turkish İ (U+0130) |
| `Multi-Agent Orchestration` | `İAA — İştirak-i A‘mâl-i Ajanîye` in titles/first introduction; `İAA` in running prose after first introduction | em dash U+2014; exact Ottoman-derived spelling incl. `A‘mâl` (U+2018) and `Ajanîye` (U+00EE) |
| `Multi-agent orchestration` (managed-block heading) | `İAA orchestration` | matches new shim text in manage.sh + managed blocks |
| `multi-agent-orchestration` (slug) | `iaa` | repo slug, skill name, paths, GitHub URL, invocation name |
| `ai-agent-orchestration` (live-container slug) | `iaa` | `~/.local/share/ai-agent-orchestration` → `~/.local/share/iaa`; `~/.config/ai-agent-orchestration` → `~/.config/iaa` |
| `mao-dev` (dev plugin) | `iaa-dev` | plugin.json name + directory |
| `mao doctor` / `mao-doctor` | `iaa doctor` | future feature name in current docs (not implemented here) |
| `mao-core` (public-distribution sketch) | `iaa-core` | design-doc token only |
| `/mao-<plugin>:multi-agent-orchestration`, `mao@<marketplace>` | `/iaa:orchestrate`, `iaa@<marketplace>` | future public invocation — **reserved for Gate 2**; current standalone invocation is the skill name `iaa` |
| `MAO_REPO` (companion script var) | `IAA_REPO` | ASCII in code identifiers; prose comments use `İAA` |
| `multi-agent-orchestration` in transcript matchers (companion harness, graders) | match `iaa`, **plus** legacy `multi-agent-orchestration` explicitly labeled LEGACY | §14 legacy-detection allowance |

Canonical display string (byte-exact, do not normalize):
`İAA — İştirak-i A‘mâl-i Ajanîye`

History framing for current docs that discuss the past (§4C):
"İAA (formerly MAO / Multi-Agent Orchestration at the time of this historical evidence)".

## 2. Filesystem / hosted-service path map

| Old | New |
|---|---|
| `/home/isa/projects/multi-agent-orchestration` | `/home/isa/projects/iaa` (plain `mv`, same `.git`) |
| `github.com/isakli05/multi-agent-orchestration` | `github.com/isakli05/iaa` (GitHub **rename**, not delete/recreate; old URL redirects) |
| `~/.local/share/ai-agent-orchestration/` | `~/.local/share/iaa/` |
| `~/.local/share/ai-agent-orchestration/multi-agent-orchestration/` | `~/.local/share/iaa/iaa/` (container = product share dir; child = skill dir named by invocation — layout otherwise unchanged) |
| `~/.local/share/ai-agent-orchestration/README.md` | `~/.local/share/iaa/README.md` |
| repo `multi-agent-orchestration/` | repo `iaa/` (`git mv`) |
| repo `docs/MAO-VS-SDD-BOUNDARY.md` | `docs/IAA-VS-SDD-BOUNDARY.md` |
| repo `web-project-sources/01-MAO-PROJECT-BRIEF.md` | `web-project-sources/01-IAA-PROJECT-BRIEF.md` |
| repo `web-project-sources/05-MAO-SDD-BOUNDARY.md` | `web-project-sources/05-IAA-SDD-BOUNDARY.md` |
| repo `release-hardening/evals/mao-dev-plugin/` | `release-hardening/evals/iaa-dev-plugin/` |
| `…/iaa-dev-plugin/skills/multi-agent-orchestration/` | `…/iaa-dev-plugin/skills/iaa/` |
| graders `mao-skill-fired.md`, `mao-not-authority.md`, `mao-not-invoked.md` | `iaa-skill-fired.md`, `iaa-not-authority.md`, `iaa-not-invoked.md` |
| `~/.claude|~/.agents|~/.zcode /skills/multi-agent-orchestration` (symlink) | `…/skills/iaa` → `~/.local/share/iaa/iaa` (atomic temp+rename link swap) |
| `~/.config/ai-agent-orchestration/` (state) | `~/.config/iaa/` (contents preserved) |
| future backups `<file>.multi-agent-orchestration-backup-<stamp>` | `<file>.iaa-backup-<stamp>` |

## 3. Runtime identity map

| Old | New |
|---|---|
| SKILL.md frontmatter `name: multi-agent-orchestration` | `name: iaa` |
| SKILL.md H1 `# Multi-Agent Orchestration` | `# İAA — İştirak-i A‘mâl-i Ajanîye` |
| `Adaptive MAO mode`, `MAO mode`, `In MAO mode` | `Adaptive İAA mode`, `İAA mode`, `In İAA mode` |
| markers `<!-- BEGIN/END managed: multi-agent-orchestration -->` | `<!-- BEGIN/END managed: iaa -->` |
| managed-block heading `## Multi-agent orchestration` | `## İAA orchestration` (body text unchanged except skill name `iaa`) |
| manage.sh `ORCHESTRATION_STATE_DIR=~/.config/ai-agent-orchestration` | `~/.config/iaa` + LEGACY migration from old dir (labeled) |
| manage.sh verify/install link+shim paths `skills/multi-agent-orchestration` | `skills/iaa` (+ LEGACY uninstall recognition, labeled) |
| plugin.json `name: mao-dev`, description | `name: iaa-dev`, description updated (identity only) |
| GitHub repo description | updated to İAA form |

## 4. Per-occurrence decision rules (not blind replace)

1. Sentence/heading describes **current state or forward plans** → new identity.
2. Sentence **narrates a past event** where the old name/path is the factual subject
   (evidence-tree paths `~/mao-*`, audit-era paths inside frozen records, dated
   verification results) → keep old string; qualify with "(at the time)"-style framing
   where ambiguity would otherwise mislead.
3. **Raw/hash-pinned artifacts** (audit/, historical-notes/, release-hardening/01–03,
   fixtures, eval results/) → untouched.
4. **Quoted third-party text** and other products' names → untouched.
5. Every retained old-name occurrence must appear in
   `OLD-NAME-REMAINING-REGISTER.md` as HISTORICALLY REQUIRED; anything else is a
   MISSED RENAME and blocks completion.

## 5. Semantics guard

Behavioral surfaces (SKILL.md policy body, delegation-contract.md, platform adapter
mechanics, manage.sh install/verify/uninstall logic, scenarios A–K, eval prompts/grader
assertions) may change **only** in identity tokens and §14-allowed LEGACY detection.
Proof procedure: normalize identity tokens in pre/post images and diff — see
`03-semantic-immutability.md`.
