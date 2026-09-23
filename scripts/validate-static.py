#!/usr/bin/env python3
"""İAA static validation (CI layer A, no model calls).

Checks:
  1. SKILL.md frontmatter (name/description present; description <= 1024 spec
     limit; <= 250 ZCode injection budget for the core skill) for the core and
     every projection, plus the orchestrate entry skill.
  2. Relative markdown links and referenced files in docs/ + README.md exist.
  3. ASCII filesystem names for paths intended to be ASCII (repo content dirs);
     Unicode display names allowed in prose and generated display fields only.
  4. Secret scan over repository text (keys, tokens, bearer headers, cookies,
     private keys, .env assignments) with an allowlist for test fixtures that
     deliberately contain marker strings.
  5. No active former-MAO identity outside LEGACY/history/allowlisted scopes.

Stdlib only. Exit 0 = pass, 1 = fail.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FAIL: list[str] = []


def fail(msg: str) -> None:
    FAIL.append(msg)


# ---------------------------------------------------------------- frontmatter
def frontmatter(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        fail(f"{path}: no frontmatter")
        return {}
    out = {}
    for line in m.group(1).splitlines():
        mm = re.match(r"^([A-Za-z_-]+):\s*(.*)$", line)
        if mm and mm.group(2).startswith('"') and mm.group(2).endswith('"'):
            out[mm.group(1)] = mm.group(2)[1:-1]
        elif mm:
            out[mm.group(1)] = mm.group(2)
    return out


def check_skill(path: Path, expect_name: str, core: bool) -> None:
    fm = frontmatter(path)
    if fm.get("name") != expect_name:
        fail(f"{path}: frontmatter name {fm.get('name')!r} != {expect_name!r}")
    desc = fm.get("description", "")
    if not desc:
        fail(f"{path}: missing description")
    if len(desc.encode()) > 1024:
        fail(f"{path}: description exceeds 1024-byte spec limit")
    if core and len(desc.encode()) > 250:
        fail(f"{path}: core description exceeds the 250-byte ZCode injection budget")


for proj in [
    ROOT / "iaa",
    ROOT / "packaging/claude/skills/iaa",
    ROOT / "packaging/codex/plugin/skills/iaa",
    ROOT / "packaging/zcode/plugins/iaa/skills/iaa",
    ROOT / "release-hardening/evals/iaa-dev-plugin/skills/iaa",
]:
    check_skill(proj / "SKILL.md", "iaa", core=True)
check_skill(ROOT / "packaging/claude/skills/orchestrate/SKILL.md", "orchestrate", core=False)
check_skill(ROOT / "packaging/zcode/plugins/iaa/skills/orchestrate/SKILL.md", "orchestrate", core=False)

# ---------------------------------------------------------------- docs links
def check_md_links(base: Path, files: list[Path]) -> None:
    for f in files:
        text = f.read_text(encoding="utf-8")
        for m in re.finditer(r"\]\(([^)#\s]+)(?:#[^)\s]*)?\)", text):
            target = m.group(1)
            if target.startswith(("http://", "https://", "mailto:", "/")):
                continue
            resolved = (f.parent / target).resolve()
            if not resolved.exists():
                fail(f"{f.relative_to(ROOT)}: dangling relative link -> {target}")


md_files = sorted((ROOT / "docs").rglob("*.md"))
check_md_links(ROOT / "docs", md_files)
readme = ROOT / "README.md"
if readme.exists():
    check_md_links(ROOT / ".", [readme])

# ---------------------------------------------------------------- ASCII paths
NONASCII_PATHS = []
for p in ROOT.rglob("*"):
    if p.is_file() and p.suffix in {".md", ".sh", ".py", ".json", ""}:
        rel = p.relative_to(ROOT).as_posix()
        if any(ord(c) > 127 for c in rel):
            NONASCII_PATHS.append(rel)
if NONASCII_PATHS:
    fail(f"non-ASCII filesystem names (expected ASCII): {NONASCII_PATHS}")

# ---------------------------------------------------------------- secret scan
SECRET_PATTERNS = [
    (re.compile(r"sk-[A-Za-z0-9]{20,}"), "OpenAI-style key"),
    (re.compile(r"sk-ant-[A-Za-z0-9-]{20,}"), "Anthropic key"),
    (re.compile(r"gh[pousr]_[A-Za-z0-9]{30,}"), "GitHub token"),
    (re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |PGP )?PRIVATE KEY-----"), "private key"),
    (re.compile(r"(?i)authorization:\s*bearer\s+[A-Za-z0-9._-]{20,}"), "bearer header"),
    (re.compile(r"(?i)(?:api_?key|secret|password|passwd|token)\s*[:=]\s*['\"][A-Za-z0-9+/=_-]{24,}['\"]"), "credential assignment"),
    (re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}"), "Slack token"),
    (re.compile(r"(?i)aws_access_key_id\s*=\s*AKIA[0-9A-Z]{16}"), "AWS key"),
]
SCAN_DIRS = ["docs", "packaging", "scripts", "tests", "iaa", "."]
SCAN_SUFFIX = {".md", ".sh", ".py", ".json", ".txt", ""}
for d in SCAN_DIRS:
    base = ROOT / d
    if not base.is_dir():
        continue
    for p in base.rglob("*") if d != "." else base.iterdir():
        if not p.is_file() or p.suffix not in SCAN_SUFFIX:
            continue
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for rx, label in SECRET_PATTERNS:
            for m in rx.finditer(text):
                frag = text[max(0, m.start() - 40) : m.end() + 20].replace("\n", " ")
                fail(f"{p.relative_to(ROOT)}: possible {label}: …{frag[:100]}…")

# ---------------------------------------------------------------- old identity scan
# Active product surfaces must carry no former-MAO identity. Allowed scopes:
# historical/evidence trees, LEGACY-labeled code, migration/audit documents.
ALLOWED_OLDNAME_DIRS = {
    "audit", "historical-notes", "research", "design", "comparison",
    "identity-migration", "release-hardening", "web-project-sources",
    "tests/fixtures", "docs/HISTORY.md", "docs/HISTORICAL-EVIDENCE-DISPOSITION.md",
    "docs/LEGACY-MIGRATION.md", "docs/POLICY-LINEAGE.md", "CANONICAL-README.md",
}
OLD_TOKENS = re.compile(r"multi-agent-orchestration|Multi-Agent Orchestration|ai-agent-orchestration|\bMAO\b")


def allowed(rel: str) -> bool:
    rel = rel.removeprefix("./")
    for a in ALLOWED_OLDNAME_DIRS:
        if rel.startswith(a):
            return True
    # LEGACY-labeled source lines are permitted in installer/doctor code
    if rel in {"iaa/scripts/manage.sh", "scripts/iaa", "scripts/validate-static.py", "tests/doctor/run-tests.sh",
               "release-hardening/evals/iaa-dev-plugin/skills/iaa/scripts/manage.sh",
               "packaging/claude/skills/iaa/scripts/manage.sh",
               "packaging/codex/plugin/skills/iaa/scripts/manage.sh",
               "packaging/zcode/plugins/iaa/skills/iaa/scripts/manage.sh"}:
        return True
    return False


ACTIVE_SCAN = ["iaa", "packaging", "scripts", "docs", "tests", ".github"]
for d in ACTIVE_SCAN:
    base = ROOT / d
    if not base.exists():
        continue
    for p in base.rglob("*"):
        if not p.is_file():
            continue
        rel = p.relative_to(ROOT).as_posix()
        if allowed(rel):
            continue
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for i, line in enumerate(text.splitlines(), 1):
            if OLD_TOKENS.search(line) and "LEGACY" not in line:
                fail(f"{rel}:{i}: former-product identity outside allowed scope: {line.strip()[:90]}")

# ---------------------------------------------------------------- report
if FAIL:
    print(f"validate-static: FAIL ({len(FAIL)})")
    for f in FAIL:
        print(f"  - {f}")
    sys.exit(1)
print("validate-static: OK (frontmatter, links, ascii paths, secrets, identity scopes)")
