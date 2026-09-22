#!/bin/sh
# Unit tests for scripts/iaa (doctor / integrate / unintegrate).
# Runs entirely inside disposable IAA_HOME sandboxes; never touches the real HOME.
# Usage: tests/doctor/run-tests.sh  — exits non-zero on the first failure.
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd -P)
IAA="$REPO_ROOT/scripts/iaa"
MANAGE="$REPO_ROOT/iaa/scripts/manage.sh"
WORK=$(mktemp -d "${TMPDIR:-/tmp}/iaa-doctor-tests.XXXXXX")
PASS=0

say()  { printf '\n== %s\n' "$1"; }
ok()   { printf '   PASS: %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '   FAIL: %s\n' "$1" >&2; exit 1; }

fresh_home() { # prints path; seeds a minimal live source copy for links
  iaa_th_home="$WORK/h$1"
  rm -rf -- "$iaa_th_home"
  mkdir -p -- "$iaa_th_home"
  printf '%s\n' "$iaa_th_home"
}

# ---------------------------------------------------------------- T1 clean env
say 'T1: doctor on an empty environment → 0 problems, exit 0, read-only'
H1=$(fresh_home 1)
IAA_HOME="$H1" "$IAA" doctor > "$WORK/t1.out" 2>&1 || bad "doctor exited non-zero on empty env"
grep -q 'summary: 0 actionable' "$WORK/t1.out" || bad "expected 0 problems"
grep -q 'no iaa plugin registered' "$WORK/t1.out" || bad "expected no-plugin info"
ok "empty environment is healthy"

# ---------------------------------------------------------------- T2 read-only
say 'T2: doctor mutates nothing'
H2=$(fresh_home 2)
mkdir -p "$H2/.claude" "$H2/.codex" "$H2/.zcode" "$H2/.agents/skills"
printf 'user content\n' > "$H2/.claude/CLAUDE.md"
printf '{}\n' > "$H2/.claude/settings.json"
printf 'codex user\n' > "$H2/.codex/AGENTS.md"
BEFORE=$(cd "$H2" && find . -type f -o -type l | LC_ALL=C sort | xargs sha256sum 2>/dev/null | sha256sum)
IAA_HOME="$H2" "$IAA" doctor > "$WORK/t2.out" 2>&1 || bad "doctor non-zero on plain files"
AFTER=$(cd "$H2" && find . -type f -o -type l | LC_ALL=C sort | xargs sha256sum 2>/dev/null | sha256sum)
[ "$BEFORE" = "$AFTER" ] || bad "doctor modified the environment"
ok "read-only confirmed (tree hash unchanged)"

# ---------------------------------------------------------------- T3 legacy detection
say 'T3: doctor detects LEGACY former-MAO state'
H3=$(fresh_home 3)
mkdir -p "$H3/.local/share/ai-agent-orchestration" "$H3/.config/ai-agent-orchestration" \
         "$H3/.claude/skills" "$H3/.zcode/skills"
ln -s "$H3/.local/share/ai-agent-orchestration" "$H3/.claude/skills/multi-agent-orchestration"
printf 'x\n<!-- BEGIN managed: multi-agent-orchestration -->\nold\n<!-- END managed: multi-agent-orchestration -->\n' > "$H3/.claude/CLAUDE.md"
IAA_HOME="$H3" "$IAA" doctor > "$WORK/t3.out" 2>&1 && bad "doctor should exit 1 with legacy problems"
grep -q 'legacy:share-dir' "$WORK/t3.out" || bad "legacy share dir not reported"
grep -q 'legacy:state-dir' "$WORK/t3.out" || bad "legacy state dir not reported"
grep -q 'legacy-shim:claude' "$WORK/t3.out" || bad "legacy shim not reported"
grep -q 'legacy-skill:claude' "$WORK/t3.out" || bad "legacy skill link not reported"
ok "all four legacy classes detected, exit 1"

# ---------------------------------------------------------------- T4 malformed markers
say 'T4: doctor flags malformed/duplicated markers; integrate refuses them'
H4=$(fresh_home 4)
mkdir -p "$H4/.claude"
printf '<!-- BEGIN managed: iaa -->\n<!-- BEGIN managed: iaa -->\nx\n<!-- END managed: iaa -->\n' > "$H4/.claude/CLAUDE.md"
IAA_HOME="$H4" "$IAA" doctor > "$WORK/t4.out" 2>&1 && bad "doctor should exit 1 on duplicated markers"
grep -q 'marker-malformed:claude' "$WORK/t4.out" || bad "malformed marker not reported"
IAA_HOME="$H4" "$IAA" integrate --mode=plugin --runtime=claude > "$WORK/t4b.out" 2>&1 && bad "integrate must refuse malformed markers"
grep -q 'refusing malformed' "$WORK/t4b.out" || bad "refusal message missing"
[ "$(grep -c 'BEGIN managed: iaa' "$H4/.claude/CLAUDE.md")" = "2" ] || bad "file was modified despite refusal"
ok "malformed markers: detected + mutation refused"

# ---------------------------------------------------------------- T5 integrate plugin mode
say 'T5: integrate --mode plugin (dry-run then real): shim + depth, no links'
H5=$(fresh_home 5)
IAA_HOME="$H5" "$IAA" integrate --mode=plugin --runtime=claude --dry-run > "$WORK/t5a.out" 2>&1
[ ! -e "$H5/.claude" ] || bad "dry-run created files"
IAA_HOME="$H5" "$IAA" integrate --mode=plugin --runtime=claude > "$WORK/t5b.out" 2>&1
[ -f "$H5/.claude/CLAUDE.md" ] || bad "CLAUDE.md not created"
[ "$(grep -c 'BEGIN managed: iaa' "$H5/.claude/CLAUDE.md")" = "1" ] || bad "marker count wrong"
[ "$(jq -r '.env.CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH // ""' "$H5/.claude/settings.json")" = "1" ] || bad "depth not set"
[ ! -e "$H5/.claude/skills/iaa" ] && [ ! -L "$H5/.claude/skills/iaa" ] || bad "plugin mode must not create skill links"
grep -q 'Interpret "use subagents" as permission' "$H5/.claude/CLAUDE.md" || bad "shim paragraph missing"
ok "plugin-mode integration: block + depth, no links"

# ---------------------------------------------------------------- T6 shim parity functional
say 'T6: managed block byte-parity between manage.sh and scripts/iaa'
H6=$(fresh_home 6)
H6B=$(fresh_home 6b)
# script-mode install from the repo core (manage.sh derives its root from its own
# location; ORCHESTRATION_HOME pins all consumer paths to the sandbox)
ORCHESTRATION_HOME="$H6" sh "$MANAGE" install > "$WORK/t6a.out" 2>&1 || bad "manage.sh install failed"
IAA_HOME="$H6B" "$IAA" integrate --mode=plugin --runtime=all > "$WORK/t6b.out" 2>&1 || bad "iaa integrate failed"
for f in .codex/AGENTS.md .claude/CLAUDE.md .zcode/AGENTS.md; do
  a=$(sed -n '/BEGIN managed: iaa/,/END managed: iaa/p' "$H6/$f")
  b=$(sed -n '/BEGIN managed: iaa/,/END managed: iaa/p' "$H6B/$f")
  [ "$a" = "$b" ] || bad "managed block differs between manage.sh and scripts/iaa for $f"
done
ok "managed blocks byte-identical across both writers (3 runtimes)"

# ---------------------------------------------------------------- T7 unintegrate restores
say 'T7: unintegrate removes only the managed block and owned depth value'
IAA_HOME="$H6B" "$IAA" unintegrate --mode=plugin --runtime=all > "$WORK/t7.out" 2>&1
for f in .codex/AGENTS.md .claude/CLAUDE.md .zcode/AGENTS.md; do
  grep -q 'managed: iaa' "$H6B/$f" 2>/dev/null && bad "$f still carries the block"
done
[ ! -e "$H6B/.config/iaa/claude-depth.state" ] || bad "depth state file left behind"
if jq -e '.env.CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH != null' "$H6B/.claude/settings.json" >/dev/null 2>&1; then
  bad "depth value not removed"
fi
ok "unintegrate reverses everything it owns"

# ---------------------------------------------------------------- T8 duplicate detection
say 'T8: doctor flags plugin + personal-skill duplicate'
H8=$(fresh_home 8)
mkdir -p "$H8/.claude/skills" "$H8/.claude/plugins"
ln -s "$REPO_ROOT/iaa" "$H8/.claude/skills/iaa"
python3 - "$H8" <<'PY'
import json, os, sys
h = sys.argv[1]
inst = {"version": 2, "plugins": {"iaa@local": [{
    "scope": "user",
    "installPath": os.path.join(h, ".claude/plugins/cache/local/iaa/0.1.0"),
    "version": "0.1.0"}]}}
os.makedirs(os.path.dirname(os.path.join(h, ".claude/plugins/installed_plugins.json")), exist_ok=True)
json.dump(inst, open(os.path.join(h, ".claude/plugins/installed_plugins.json"), "w"))
PY
IAA_HOME="$H8" "$IAA" doctor > "$WORK/t8.out" 2>&1 && bad "doctor should exit 1 on duplicate"
grep -q 'duplicate:claude' "$WORK/t8.out" || bad "duplicate not reported"
ok "duplicate plugin+personal detected"

# ---------------------------------------------------------------- T9 stale link
say 'T9: doctor flags dangling skill symlink'
H9=$(fresh_home 9)
mkdir -p "$H9/.claude/skills" "$H9/.agents/skills" "$H9/.zcode/skills"
ln -s "$H9/.local/share/does-not-exist" "$H9/.claude/skills/iaa"
IAA_HOME="$H9" "$IAA" doctor > "$WORK/t9.out" 2>&1 && bad "doctor should exit 1 on stale link"
grep -q 'stale-link:claude' "$WORK/t9.out" || bad "stale link not reported"
ok "stale symlink detected"

# ---------------------------------------------------------------- T10 script-mode refusal from package
say 'T10: integrate --mode script refuses from a packaged copy'
PKG="$WORK/fake-plugin"
mkdir -p "$PKG/bin"
cp "$REPO_ROOT/packaging/claude/bin/iaa" "$PKG/bin/iaa"
printf 'İAA generated projection — DO NOT EDIT BY HAND\nsource-of-truth: iaa/ (repository root)\nversion: 0.1.0-rc.1\n' > "$PKG/PROVENANCE"
IAA_HOME="$WORK/h10" "$PKG/bin/iaa" integrate --mode=script > "$WORK/t10.out" 2>&1 && bad "packaged copy must refuse script mode"
grep -q 'refusing --mode script' "$WORK/t10.out" || bad "refusal message missing"
ok "packaged copy refuses script-mode integration"

# ---------------------------------------------------------------- T11 json output
say 'T11: doctor --json is valid JSON with expected fields'
IAA_HOME="$H1" "$IAA" doctor --json > "$WORK/t11.json" 2>&1
jq -e '.iaa_version and .policy_revision and (.findings | type == "array")' "$WORK/t11.json" >/dev/null || bad "JSON structure wrong"
ok "doctor --json valid"

# ---------------------------------------------------------------- T12 hash drift
say 'T12: doctor detects live-tree hash drift against provenance'
H12=$(fresh_home 12)
mkdir -p "$H12/.local/share/iaa"
cp -a "$REPO_ROOT/iaa" "$H12/.local/share/iaa/"
ORCHESTRATION_HOME="$H12" sh "$MANAGE" install > "$WORK/t12a.out" 2>&1 || bad "install failed"
# fabricate provenance with a wrong hash for SKILL.md
python3 - "$H12" <<'PY'
import json, os, sys
h = sys.argv[1]
d = os.path.join(h, ".config/iaa")
os.makedirs(d, exist_ok=True)
json.dump({"version": "0.1.0", "core_hashes": {"SKILL.md": "0" * 64}}, open(os.path.join(d, "provenance.json"), "w"))
PY
IAA_HOME="$H12" "$IAA" doctor > "$WORK/t12.out" 2>&1 && bad "doctor should exit 1 on drift"
grep -q 'hash-drift:live-tree' "$WORK/t12.out" || bad "drift not reported"
ok "hash drift detected"

printf '\nALL %s DOCTOR TESTS PASSED\n' "$PASS"
rm -rf -- "$WORK"
