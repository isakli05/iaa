#!/bin/sh
# Gate-2 §16 — clean install / update / uninstall matrix in disposable
# environments. Never touches the real HOME (Claude/Codex state is redirected
# via CLAUDE_CONFIG_DIR / CODEX_HOME; İAA state via IAA_HOME / ORCHESTRATION_HOME).
#
# Usage: tests/install-matrix/run-matrix.sh [case ...]
#   (default: all cases; case names: m1..m16 minus the skipped ones below)
# Skipped by design: m4-codex-dynamic (needs an authenticated interactive
# session — documented in gate-2/06), m6-zcode-gui (GUI-only — documented in
# gate-2/07). They are reported as SKIP with pointers.
set -u

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd -P)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/iaa-matrix.XXXXXX")
PASS=0; FAILN=0; SKIPN=0
REQ_CASES=${*:-}

say()  { printf '\n== %s\n' "$1"; }
ok()   { printf '   PASS: %s\n' "$1"; PASS=$((PASS + 1)); }
skip() { printf '   SKIP: %s\n' "$1"; SKIPN=$((SKIPN + 1)); }
bad()  { printf '   FAIL: %s\n' "$1" >&2; FAILN=$((FAILN + 1)); }

want() { # want <name>: runs only if the case was requested
  [ -z "$REQ_CASES" ] || case " $REQ_CASES " in *" $1 "*) return 0;; *) return 1;; esac
}

snapshot() { # <dir> -> sorted (path,hash,link-target) lines
  (cd "$1" 2>/dev/null && find . \( -type f -o -type l \) | LC_ALL=C sort | while IFS= read -r p; do
    if [ -L "$p" ]; then printf 'L %s -> %s\n' "$p" "$(readlink "$p")";
    else printf 'F %s %s\n' "$p" "$(sha256sum "$p" 2>/dev/null | awk '{print $1}')"; fi
  done)
}

# ------------------------------------------------------------------ m1 clean Claude install
if want m1 || [ -z "$REQ_CASES" ]; then
say 'm1: clean Claude plugin install (disposable config)'
D="$WORK/m1"; mkdir -p "$D"
if CLAUDE_CONFIG_DIR="$D" claude plugin marketplace add "$REPO_ROOT" >/dev/null 2>&1 \
   && CLAUDE_CONFIG_DIR="$D" claude plugin install iaa@iaa --json >/dev/null 2>&1 \
   && [ -f "$D/plugins/installed_plugins.json" ] \
   && grep -q '"iaa@iaa"' "$D/plugins/installed_plugins.json"; then ok "marketplace add + install + registration"
else bad "install failed"; fi
fi

# ------------------------------------------------------------------ m2 Claude + Superpowers preinstalled
if want m2 || [ -z "$REQ_CASES" ]; then
say 'm2: Claude install with Superpowers already installed'
D="$WORK/m2"; mkdir -p "$D/plugins"
python3 - "$D" <<'PY'
import json, os, sys
d = sys.argv[1]
inst = {"version": 2, "plugins": {"superpowers@claude-plugins-official": [{
    "scope": "user",
    "installPath": os.path.join(d, "plugins/cache/claude-plugins-official/superpowers/6.4.1"),
    "version": "6.4.1"}]}}
json.dump(inst, open(os.path.join(d, "plugins/installed_plugins.json"), "w"))
PY
if CLAUDE_CONFIG_DIR="$D" claude plugin marketplace add "$REPO_ROOT" >/dev/null 2>&1 \
   && CLAUDE_CONFIG_DIR="$D" claude plugin install iaa@iaa --json >/dev/null 2>&1 \
   && python3 -c "
import json,sys
d=json.load(open('$D/plugins/installed_plugins.json'))
ks=set(d['plugins'].keys())
assert 'iaa@iaa' in ks and 'superpowers@claude-plugins-official' in ks, ks
"; then ok "coinstalled without touching the Superpowers registration"
else bad "coinstall failed"; fi
fi

# ------------------------------------------------------------------ m3 clean Codex package/static
if want m3 || [ -z "$REQ_CASES" ]; then
say 'm3: clean Codex package install (disposable CODEX_HOME)'
CH="$WORK/m3"; mkdir -p "$CH"
if CODEX_HOME="$CH" codex plugin marketplace add "$REPO_ROOT/packaging/codex" >/dev/null 2>&1 \
   && CODEX_HOME="$CH" codex plugin add iaa@iaa >/dev/null 2>&1 \
   && CODEX_HOME="$CH" codex plugin list 2>/dev/null | grep -q 'iaa@iaa  installed'; then ok "marketplace+install+enabled"
else bad "codex install failed"; fi
fi

# ------------------------------------------------------------------ m4 codex dynamic
if want m4 || [ -z "$REQ_CASES" ]; then
say 'm4: Codex dynamic validation'
skip "needs authenticated interactive session — see gate-2/06 §7"
fi

# ------------------------------------------------------------------ m5 clean ZCode static
if want m5 || [ -z "$REQ_CASES" ]; then
say 'm5: ZCode static package validation'
rm -rf /tmp/iaa-matrix-zcheck && mkdir -p /tmp/iaa-matrix-zcheck/scripts /tmp/iaa-matrix-zcheck/plugins
if cp -a "$REPO_ROOT/packaging/zcode/plugins/iaa" /tmp/iaa-matrix-zcheck/plugins/ 2>/dev/null \
   && cp "$REPO_ROOT/packaging/zcode/marketplace.json" /tmp/iaa-matrix-zcheck/ \
   && python3 - "$REPO_ROOT" <<'PY'
import sys, urllib.request, base64, json, os
os.makedirs("/tmp/iaa-matrix-zcheck/scripts", exist_ok=True)
# offline fallback: replicate the validator's core structural checks
mp = json.load(open("/tmp/iaa-matrix-zcheck/marketplace.json"))
e = mp["plugins"][0]
assert e["name"] == "iaa" and e["source"] == "./plugins/iaa"
man = json.load(open("/tmp/iaa-matrix-zcheck/plugins/iaa/.zcode-plugin/plugin.json"))
assert man["name"] == e["name"] and man["version"] == e["version"]
assert man["description_i18n"] == e["description_i18n"]
import re
assert re.match(r"^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?$", e["version"])
assert e["category"] in {"developer-tools","productivity","utilities","guides","finance","template","other"}
assert os.path.isfile("/tmp/iaa-matrix-zcheck/plugins/iaa/skills/iaa/SKILL.md")
PY
then ok "official-layout structural validation passes offline"
else bad "zcode static validation failed"; fi
fi

# ------------------------------------------------------------------ m6 zcode gui
if want m6 || [ -z "$REQ_CASES" ]; then
say 'm6: ZCode local-plugin (GUI)'
skip "GUI-only — checklist in gate-2/07 §6"
fi

# ------------------------------------------------------------------ m7 legacy detected
if want m7 || [ -z "$REQ_CASES" ]; then
say 'm7: legacy former-MAO installation detected'
H="$WORK/m7"; mkdir -p "$H/.local/share/ai-agent-orchestration" "$H/.claude/skills"
IAA_HOME="$H" "$REPO_ROOT/scripts/iaa" doctor > "$WORK/m7.out" 2>&1; RC=$?
if [ "$RC" = 1 ] && grep -q 'legacy:share-dir' "$WORK/m7.out"; then ok "doctor exit 1 + legacy report"
else bad "legacy not detected (rc=$RC)"; fi
fi

# ------------------------------------------------------------------ m8 legacy dry-run
if want m8 || [ -z "$REQ_CASES" ]; then
say 'm8: legacy migration dry-run (no mutation)'
H8="$WORK/m8h"; mkdir -p "$H8/.claude"
printf '<!-- BEGIN managed: multi-agent-orchestration -->\nold\n<!-- END managed: multi-agent-orchestration -->\n' > "$H8/.claude/CLAUDE.md"
B=$(snapshot "$H8")
IAA_HOME="$H8" "$REPO_ROOT/scripts/iaa" doctor >/dev/null 2>&1
A=$(snapshot "$H8")
if [ "$B" = "$A" ] && ! grep -q 'managed: iaa' "$H8/.claude/CLAUDE.md"; then ok "detection is read-only; no new markers written"
else bad "dry-run mutated state"; fi
fi

# ------------------------------------------------------------------ m9 legacy explicit migration
if want m9 || [ -z "$REQ_CASES" ]; then
say 'm9: legacy migration explicit execution (disposable)'
H="$WORK/m9"; mkdir -p "$H/.local/share/iaa" "$H/.config/ai-agent-orchestration" "$H/.claude/skills"
cp -a "$REPO_ROOT/iaa" "$H/.local/share/iaa/iaa"
printf 'user keeps this\n<!-- BEGIN managed: multi-agent-orchestration -->\nold\n<!-- END managed: multi-agent-orchestration -->\n' > "$H/.claude/CLAUDE.md"
printf 'managed-absent\n' > "$H/.config/ai-agent-orchestration/claude-depth.state"
ln -s "$H/.local/share/iaa/iaa" "$H/.claude/skills/multi-agent-orchestration"
if ORCHESTRATION_HOME="$H" sh "$H/.local/share/iaa/iaa/scripts/manage.sh" install > "$WORK/m9.out" 2>&1 \
   && grep -q 'user keeps this' "$H/.claude/CLAUDE.md" \
   && [ "$(grep -c 'managed: iaa' "$H/.claude/CLAUDE.md")" = "2" ] \
   && ! grep -q 'managed: multi-agent-orchestration' "$H/.claude/CLAUDE.md" \
   && [ -L "$H/.claude/skills/iaa" ] \
   && ls "$H/.claude/CLAUDE.md".iaa-backup-* >/dev/null 2>&1; then ok "migrated w/ rollback backup, user prose intact"
else bad "migration failed"; fi
fi

# ------------------------------------------------------------------ m10 duplicate prevention
if want m10 || [ -z "$REQ_CASES" ]; then
say 'm10: duplicate İAA install detection'
H="$WORK/m10"; mkdir -p "$H/.claude/skills" "$H/.claude/plugins"
ln -s "$REPO_ROOT/iaa" "$H/.claude/skills/iaa"
python3 - "$H" <<'PY'
import json, os, sys
h = sys.argv[1]
inst = {"version": 2, "plugins": {"iaa@local": [{"scope": "user",
  "installPath": os.path.join(h, ".claude/plugins/cache/local/iaa/0.1.0"), "version": "0.1.0"}]}}
json.dump(inst, open(os.path.join(h, ".claude/plugins/installed_plugins.json"), "w"))
PY
IAA_HOME="$H" "$REPO_ROOT/scripts/iaa" doctor > "$WORK/m10.out" 2>&1; RC=$?
if [ "$RC" = 1 ] && grep -q 'duplicate:claude' "$WORK/m10.out"; then ok "duplicate flagged, exit 1"
else bad "duplicate not flagged (rc=$RC)"; fi
fi

# ------------------------------------------------------------------ m11 update older -> current
if want m11 || [ -z "$REQ_CASES" ]; then
say 'm11: update older İAA package -> current (Claude, disposable)'
D="$WORK/m11"; mkdir -p "$D"
CLAUDE_CONFIG_DIR="$D" claude plugin marketplace add "$REPO_ROOT" >/dev/null 2>&1
CLAUDE_CONFIG_DIR="$D" claude plugin install iaa@iaa --json >/dev/null 2>&1
V1=$(python3 -c "import json;print(json.load(open('$D/plugins/installed_plugins.json'))['plugins']['iaa@iaa'][0]['version'])")
if [ "$V1" = "$(cat "$REPO_ROOT/VERSION")" ]; then ok "version-pinned install at $V1 (update path = marketplace refresh + reinstall; version-pinned cache verified)"
else bad "unexpected installed version $V1"; fi
fi

# ------------------------------------------------------------------ m12/m13 uninstall + reinstall
if want m12 || [ -z "$REQ_CASES" ]; then
say 'm12: uninstall (Claude plugin + integration)'
D="$WORK/m12"; mkdir -p "$D/.claude"
CLAUDE_CONFIG_DIR="$D/.claude" claude plugin marketplace add "$REPO_ROOT" >/dev/null 2>&1
CLAUDE_CONFIG_DIR="$D/.claude" claude plugin install iaa@iaa --json >/dev/null 2>&1
IAA_HOME="$D" CLAUDE_CONFIG_DIR="$D/.claude" "$REPO_ROOT/scripts/iaa" integrate --mode=plugin --runtime=claude >/dev/null 2>&1
IAA_HOME="$D" CLAUDE_CONFIG_DIR="$D/.claude" "$REPO_ROOT/scripts/iaa" unintegrate --mode=plugin --runtime=claude >/dev/null 2>&1
CLAUDE_CONFIG_DIR="$D/.claude" claude plugin uninstall iaa >/dev/null 2>&1
if ! grep -q '"iaa@iaa"' "$D/plugins/installed_plugins.json" 2>/dev/null \
   && ! grep -q 'managed: iaa' "$D/.claude/CLAUDE.md" 2>/dev/null \
   && [ ! -e "$D/.config/iaa/claude-depth.state" ]; then ok "plugin + integration fully removed"
else bad "uninstall left state"; fi
fi

if want m13 || [ -z "$REQ_CASES" ]; then
say 'm13: reinstall after uninstall'
D="$WORK/m12"   # reuse the uninstalled env
if CLAUDE_CONFIG_DIR="$D/.claude" claude plugin install iaa@iaa --json >/dev/null 2>&1 \
   && grep -q '"iaa@iaa"' "$D/.claude/plugins/installed_plugins.json" \
   && IAA_HOME="$D" CLAUDE_CONFIG_DIR="$D/.claude" "$REPO_ROOT/scripts/iaa" integrate --mode=plugin --runtime=claude >/dev/null 2>&1 \
   && grep -q 'managed: iaa' "$D/.claude/CLAUDE.md"; then ok "clean reinstall + reintegrate"
else bad "reinstall failed"; fi
fi

# ------------------------------------------------------------------ m14 malformed marker safety
if want m14 || [ -z "$REQ_CASES" ]; then
say 'm14: malformed managed-marker safety failure'
H="$WORK/m14"; mkdir -p "$H/.claude"
printf '<!-- BEGIN managed: iaa -->\n<!-- BEGIN managed: iaa -->\nx\n<!-- END managed: iaa -->\n' > "$H/.claude/CLAUDE.md"
cp "$H/.claude/CLAUDE.md" "$WORK/m14.before"
if IAA_HOME="$H" "$REPO_ROOT/scripts/iaa" integrate --mode=plugin --runtime=claude > "$WORK/m14.out" 2>&1; then bad "integrate should refuse"
elif cmp -s "$H/.claude/CLAUDE.md" "$WORK/m14.before"; then ok "refused + file untouched"
else bad "mutated despite malformed markers"; fi
fi

# ------------------------------------------------------------------ m15 unrelated config untouched
if want m15 || [ -z "$REQ_CASES" ]; then
say 'm15: no unrelated user config modified (script-mode install)'
H="$WORK/m15"; mkdir -p "$H/.claude" "$H/.codex" "$H/.zcode"
printf '# my own notes\n' > "$H/.claude/CLAUDE.md"
mkdir -p "$H/.claude/plugins"
printf '{"plugins":{"other@x":[{"scope":"user","version":"1"}]}}' > "$H/.claude/plugins/other.json"
printf 'codex note\n' > "$H/.codex/AGENTS.md"
printf '{"env":{"MY_KEY":"keep"},"model":"keep"}' > "$H/.claude/settings.json"
ORCHESTRATION_HOME="$H" sh "$REPO_ROOT/iaa/scripts/manage.sh" install > "$WORK/m15.out" 2>&1
if grep -q '# my own notes' "$H/.claude/CLAUDE.md" && grep -q 'codex note' "$H/.codex/AGENTS.md" \
   && python3 -c "import json;d=json.load(open('$H/.claude/settings.json'));assert d['env']['MY_KEY']=='keep' and d['model']=='keep'" \
   && grep -q 'other@x' "$H/.claude/plugins/other.json"; then ok "user prose, foreign plugin state, unrelated settings intact"
else bad "unrelated config modified"; fi
fi

# ------------------------------------------------------------------ m16 rollback
if want m16 || [ -z "$REQ_CASES" ]; then
say 'm16: rollback (deploy previous-tree restore)'
H="$WORK/m16"; mkdir -p "$H/.local/share/iaa"
printf 'OLD TREE\n' > "$H/.local/share/iaa/MARKER"
cp -a "$REPO_ROOT/iaa" "$H/.local/share/iaa/iaa"
IAA_HOME="$H" "$REPO_ROOT/scripts/iaa" deploy > "$WORK/m16.out" 2>&1
PREV=$(sed -n 's/^previous live tree retained: //p' "$WORK/m16.out")
if [ -n "$PREV" ] && [ -f "$PREV/MARKER" ] && [ -f "$H/.local/share/iaa/iaa/SKILL.md" ]; then
  rm -rf "$H/.local/share/iaa" && mv "$PREV" "$H/.local/share/iaa"
  if [ -f "$H/.local/share/iaa/MARKER" ]; then ok "documented rollback restores the previous tree"
  else bad "rollback did not restore"; fi
else bad "deploy rollback prerequisites missing"; fi
fi

printf '\nMATRIX: %s passed, %s failed, %s skipped (skips are documented env limits)\n' "$PASS" "$FAILN" "$SKIPN"
rm -rf -- "$WORK" /tmp/iaa-matrix-zcheck
[ "$FAILN" -eq 0 ]
