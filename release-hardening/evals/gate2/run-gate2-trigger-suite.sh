#!/usr/bin/env bash
# Gate-2 trigger characterization (§15) — runs the gate2 eval cases plus the
# reused core cases against the REAL package (packaging/claude), so the
# namespace (iaa:iaa, /iaa:orchestrate) under test is the public one.
#
# The eval tree is staged TEMPORARILY into packaging/claude/evals/ (claude
# plugin eval only reads eval dirs below the plugin) and removed afterwards;
# the public RC package itself ships without an evals/ directory.
#
# Usage: run-gate2-trigger-suite.sh <results-dir> [--case <glob>]...
# Requires: claude CLI (2.1.274+), the local provider profile; costs real money.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd -P)"
PKG="$REPO_ROOT/packaging/claude"
GATE2="$REPO_ROOT/release-hardening/evals/gate2"
DEV="$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/evals/core"
EV="${1:?usage: $0 <results-dir> [--case <glob>]...}"
shift

mkdir -p "$EV"

# stage: gate2 cases + reused core cases (with bumped run counts)
rm -rf "$PKG/evals"
mkdir -p "$PKG/evals"
for c in "$GATE2"/*/; do
  cp -r "$c" "$PKG/evals/$(basename "$c")"
done
for c in trigger-positive anti-overdelegation-trivial ordinary-task-no-overclaim; do
  cp -r "$DEV/$c" "$PKG/evals/$c"
done
sed -i 's/^runs: 2$/runs: 5/' "$PKG/evals/trigger-positive/prompt.md" \
                          "$PKG/evals/anti-overdelegation-trivial/prompt.md" \
                          "$PKG/evals/ordinary-task-no-overclaim/prompt.md"
# shim-sim runs single-arm (the baseline arm cannot carry the shim simulation)
cp -r "$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/evals/core/shim-sim-trigger" "$PKG/evals/shim-sim-trigger"
sed -i 's/^runs: 2$/runs: 5/' "$PKG/evals/shim-sim-trigger/prompt.md"

restore() { rm -rf "$PKG/evals"; }
trap restore EXIT

echo "[$(date -Is)] running gate2 trigger suite against $PKG"
echo "cases staged:"; ls "$PKG/evals"

cd "$REPO_ROOT"
claude plugin eval "$PKG" --trust-plugin \
  ${*:+"$@"} \
  --allow-tools Write Edit Bash \
  --json "$EV/aggregate.json" > "$EV/eval-stdout.log" 2>&1 || {
    echo "eval exited non-zero; see $EV/eval-stdout.log" >&2
    exit 1
  }

echo "[$(date -Is)] done — results in $EV"
python3 - "$EV/aggregate.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(json.dumps({
    "model": d.get("model"),
    "generatedAt": d.get("generatedAt"),
    "cases": [
        {"case": c.get("name"), "score": c.get("score"), "cost": c.get("costUsd"),
         "passed": c.get("passed"), "pluginRuns": c.get("pluginRuns"),
         "baselineRuns": c.get("baselineRuns")}
        for c in d.get("cases", [])
    ]}, indent=1))
PY
