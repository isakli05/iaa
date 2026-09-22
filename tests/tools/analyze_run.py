#!/usr/bin/env python3
"""Analyze a claude -p run: skill invocations, agent spawns, topology signals."""
import json, os, re, sys

def main(transcript_path, run_json_path):
    skills = []
    agents = []
    with open(transcript_path) as f:
        for line in f:
            try:
                d = json.loads(line)
            except Exception:
                continue
            msg = d.get("message") or {}
            content = msg.get("content")
            if not isinstance(content, list):
                continue
            for b in content:
                if not isinstance(b, dict) or b.get("type") != "tool_use":
                    continue
                name = b.get("name", "")
                inp = b.get("input") or {}
                if name == "Skill":
                    skills.append(inp.get("skill", "?"))
                if name in ("Task", "Agent"):
                    agents.append({
                        "desc": inp.get("description", ""),
                        "type": inp.get("subagent_type", ""),
                        "prompt_head": (inp.get("prompt", "") or "")[:150],
                    })
    print("SKILL INVOCATIONS (in order):")
    for s in skills:
        print(f"  - {s}")
    sdd_loaded = any("subagent-driven-development" in s for s in skills)
    print(f"\nSDD LOADED: {sdd_loaded}")
    print(f"\nAGENT SPAWNS ({len(agents)}):")
    for a in agents:
        print(f"  - [{a['type']}] {a['desc']}")
    if run_json_path and os.path.exists(run_json_path):
        try:
            with open(run_json_path) as f:
                r = json.load(f)
            st = r.get("subagent_stats", {})
            print(f"\nsubagent_stats: spawned={st.get('spawned')} max_depth={st.get('max_depth')} nested={st.get('spawned_by_subagents')} by_type={st.get('by_type')}")
            print(f"cost=${r.get('total_cost_usd')} turns={r.get('num_turns')} api_ms={r.get('duration_api_ms')}")
        except Exception as e:
            print(f"run json parse error: {e}")

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
