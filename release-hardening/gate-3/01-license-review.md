# Gate 3 — 01: License Review (prepare the owner decision; do not make it)

Date: 2026-09-23. Scope: legal-content audit of everything İAA would
distribute publicly, and the exact license choice prepared for owner
approval. **No root LICENSE/NOTICE was added by this Gate** — the candidate
files live under `release-hardening/gate-3/license-candidate/` until the
owner approves.

Research basis (all sources accessed 2026-09-23; this is a research
summary, not legal advice): choosealicense.com/licenses/mit; opensource.org
/licenses/MIT; SPDX MIT page; GitHub licensing-a-repository docs; the
Licensee matching docs; Apache-2.0 §2/§4/§4(d); obra/superpowers LICENSE
and skills/writing-plans/SKILL.md (fetched at their current v6.4.1 state);
openai/codex `plugin-json-spec.md`; code.claude.com plugins-reference;
docs.npmjs.com package.json `license` conventions.

## A. İAA-owned original material

Everything authored for İAA: the behavioral core (`iaa/`), `scripts/`,
`packaging/` templates + generated manifests, `docs/`, `tests/` (except the
fixture line below), `release-hardening/`, `comparison/`, `research/`,
`design/`, `audit/` prose. Single copyright holder (the owner,
`isakli05`); no contributions from anyone else, so no holder-number
question exists today.

## B. Third-party material actually redistributed

Exactly one item, and it is a single functional line:

- `tests/fixtures/generated-PLAN.md` (and its copies inside eval case
  `resources/PLAN.md`) carries the verbatim template directive
  "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
  (recommended) or superpowers:executing-plans…" emitted by Superpowers'
  `writing-plans` skill when the fixture was generated during the 2026-08
  campaigns; the surrounding plan text is campaign-authored.
  - Superpowers is MIT licensed (`Copyright (c) 2025 Jesse Vincent`,
     verified today at the repo root; its Codex manifest also declares
     `"license": "MIT"`; the repo ships **no NOTICE file**).
  - Legal content analysis: MIT's only condition attaches to "all copies or
    substantial portions of the Software". One directive line in one test
    fixture is neither; short functional phrases are also outside copyright
    subject matter (US Copyright Office Circular 33 territory). **No
    license obligation is triggered.** Attribution is courtesy, not duty.
  - Existing in-repo attribution: ADR-0003 documents the fixture's
    provenance already (item E below consolidates the courtesy surface).

No third-party code is vendored. The official ZCode validator
(Apache-2.0, zai-org/zcode-plugins) is **fetched at validation time and
never committed** — Apache-2.0 §4 obligations attach to distribution, and
fetch-and-execute is licensed use under §2 with no attribution duty (item
E notes the courtesy mention that already exists in the ZCode packaging
README and CI workflow).

## C. References to third-party systems without redistributed code

`comparison/`, `research/`, `docs/` quote short factual lines from
Superpowers/GSD/BMAD/Codex/ZCode documentation with citations (e.g. SDD's
cadence lines). Short factual quotation with citation for compatibility
documentation is standard practice; no license condition attaches at this
scale. Keep the citations at public release (already the case).

## D. Historical fixtures/evidence

`audit/`, `historical-notes/`, identity-migration records, and the
campaign-derived fixtures preserve the former MAO name and machine paths by
design (provenance). They contain no third-party code; the only third-party
line is item B. No license implication.

## E. Attribution obligations (binding) vs acknowledgements (courtesy)

| Item | Status | Surface |
|---|---|---|
| MIT notice retention for İAA's own code | binding once MIT is chosen | the LICENSE file itself, carried by downstream copiers |
| Superpowers fixture line | **no binding obligation** (not a substantial portion; short functional phrase) | courtesy: ADR-0003 (exists) + one line in NOTICE (candidate) |
| ZCode validator (fetched, Apache-2.0) | **no binding obligation** (no distribution) | courtesy: packaging/zcode README + CI workflow note (exist) + one line in NOTICE (candidate) |
| NOTICE file | **not legally required for MIT** — the NOTICE mechanism is Apache-2.0 §4(d) doctrine; MIT's single condition is the notice sentence inside the LICENSE | optional; GitHub's Licensee ignores NOTICE entirely — only the LICENSE file drives the displayed license |

## F. The candidate (OPTION A — recommended): MIT + NOTICE

- `LICENSE`: canonical MIT text (choosealicense.com/SPDX-identical body;
  the copyright line is a variable — Licensee ignores it when matching).
  Candidate uses `Copyright (c) 2026 isakli05` (the already-public handle);
  the owner may substitute a legal name before approval with zero legal or
  detection impact.
- `NOTICE`: İAA identification + the two courtesy lines above. Optional,
  carries no legal force under MIT, does not affect GitHub license
  detection; kept because the Gate-2 report promised a NOTICE decision
  surface for the Superpowers-derived fixture line.

Downstream effect of OPTION A: anyone may use, copy, modify, merge,
publish, distribute, sublicense, and sell İAA, commercially or not,
conditioned only on retaining the copyright+permission notice in copies or
substantial portions; they must not use the owner's name for endorsement
(the standard MIT final-paragraph conduct as far as local law allows; the
canonical text's warranty/risk text is unchanged). Patent grant: MIT
contains an implied patent license by majority academic reading, no
explicit grant — for a policy/skill distribution with no patent filings
known, this is immaterial here (noted because the final report must
mention it). Compatibility with the distribution model: exact — all three
target registries accept SPDX `"MIT"` metadata (Claude plugin.json optional
`license` field; Codex plugin.json optional `license` example is literally
`"MIT"`; Superpowers itself ships MIT through all the same channels).

Effect of NO license (the status quo alternative): default copyright —
"nobody may reproduce, distribute, or create derivative works" (GitHub's
own documentation), while GitHub ToS still allow view/fork. Every intended
consumer of a public İAA would be technically unlicensed to use it — the
opposite of the project's purpose. Not viable for publication.

## G. Alternatives considered (none recommended)

- **Apache-2.2/2.0 + NOTICE**: explicit patent grant + mandatory NOTICE
  handling; adds 4–5× longer text and obligations İAA (a skill/policy
  distribution) does not need. No material evidence requires it: the only
  inbound third-party content is item B (MIT-derived) and item none-vendored.
- **BSD-2/ISC**: equivalent in effect to MIT with different wording; no
  advantage; MIT matches the ecosystem neighbor (Superpowers) most cited in
  İAA's evidence.
- **CC0 / Unlicense / public domain**: maximal permissiveness, but patent
  renunciation and jurisdictional patchiness add uncertainty with no
  benefit for this project; also weaker ecosystem convention for code on
  the target registries.
- **OPTION B (only if material evidence requires)**: none found — the
  audit above surfaced zero content that MIT cannot cleanly carry. There is
  no evidence-supported alternative recommendation.

## H. What approval would trigger (runbook step, NOT executed here)

1. Copy `license-candidate/LICENSE` and `license-candidate/NOTICE` to the
   repository root (and add both to the release archive set + web-pack
   manifest note).
2. Stamp `"license": "MIT"` into all three generated manifests (Claude +
   Codex plugin.json gain the field; ZCode's `UNLICENSED` marker flips to
   `MIT`) via `packaging/templates/*`, rebuilt by `scripts/build-packages.sh`.
3. Update README "License: TBD" line + docs cross-links.
All three are mechanical; none exists in this Gate's commits.
