#!/usr/bin/env bash
# Gate-3 eval-methodology validation (brief §6) — validates the corrected
# grader design on the REAL package namespace (packaging/claude), cheaply:
# single arm (--ablation none) + n=3 per case. Cases staged:
#   - trigger-positive (class A trigger indicator + class B materiality:
#     the corrected min:0 cap grader must now score the in-policy
#     zero-agent runs as PASS)
#   - forced-benefit-delegation (class C: NEW case; benefit pre-established
#     by fixture; expects >=1 delegated worker, fixture-bounded max 3)
# The eval tree is staged TEMPORARILY into packaging/claude/evals/ (claude
# plugin eval only reads eval dirs below the plugin) and removed afterwards;
# the public RC package ships without an evals/ directory.
#
# Usage: run-gate3-eval-validation.sh <results-dir> [--case <glob>]...
# Requires: claude CLI (2.1.269+), the local provider profile; costs real money.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd -P)"
PKG="$REPO_ROOT/packaging/claude"
GATE3="$REPO_ROOT/release-hardening/evals/gate3"
DEV="$REPO_ROOT/release-hardening/evals/iaa-dev-plugin/evals/core"
EV="${1:?usage: $0 <results-dir> [--case <glob>]...}"
shift

mkdir -p "$EV"

rm -rf "$PKG/evals"
mkdir -p "$PKG/evals"
# corrected class-B case (grader fix: explicit min: 0)
cp -r "$DEV/trigger-positive" "$PKG/evals/trigger-positive"
# new class-C case (scaffolded fixture pre-establishes the benefit)
cp -r "$GATE3/forced-benefit-delegation" "$PKG/evals/forced-benefit-delegation"
sed -i 's/^runs: 2$/runs: 3/' "$PKG/evals/trigger-positive/prompt.md" \
                          "$PKG/evals/forced-benefit-delegation/prompt.md"

restore() { rm -rf "$PKG/evals"; }
trap restore EXIT

echo "[$(date -Is)] running gate3 eval validation against $PKG"
echo "cases staged:"; ls "$PKG/evals"

cd "$REPO_ROOT"
claude plugin eval "$PKG" --trust-plugin \
  ${*:+"$@"} \
  --ablation none --scaffold \
  --allow-tools Write Edit \
  --json "$EV/aggregate.json" > "$EV/eval-stdout.log" 2>&1 || {
    echo "eval exited non-zero; see $EV/eval-stdout.log" >&2
    exit 1
  }

echo "[$(date -Is)] done — results in $EV"
python3 - "$EV/aggregate.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(json.dumps({
    "model": d.get("model"), "claudeVersion": d.get("claudeVersion"),
    "generatedAt": d.get("generatedAt"), "costUsd": d.get("costUsd"),
    "partial": d.get("partial"),
    "cases": [
        {"case": c.get("name"), "score": c.get("score"),
         "cost": c.get("costUsd"), "passed": c.get("passed")}
        for c in d.get("cases", [])
    ]}, indent=1))
PY
