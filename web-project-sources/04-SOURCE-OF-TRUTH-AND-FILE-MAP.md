# 04 — Source of Truth and File Map

## Live vs maintained

- **Live runtime source (consumed by all three runtimes, unchanged since 2026-08-27):**
  `/home/isa/.local/share/iaa/` — hash-pinned (SKILL.md v3 =
  sha256 `fee98091…`, 7,913 B). NOT version-controlled in place.
- **Maintained/versioned copy:** the `iaa/` GitHub baseline repo
  (private, isakli05) holds a byte-identical copy + this documentation. Sync rule: edit
  live → copy → hash-verify → commit.

## The five canonical files (in this pack under sources/)

| File | Size | Role |
|---|---:|---|
| `SKILL.md` | 7,913 B | the entire decision policy: modes, boundary, decision core |
| `references/delegation-contract.md` | 2,606 B | brief/handoff/acceptance fields |
| `references/platform-adapters.md` | 3,615 B | Codex/Claude/ZCode mechanism adapters |
| `scripts/manage.sh` | 14,945 B | install/verify/uninstall; shim text lives here |
| `tests/scenarios.md` | 4,183 B | behavioral scenarios A–K |
| (+ `README.md` at parent) | 16,075 B | install-era project doc (architecture + validation log) |

## Integration points (machine-local)

Three relative symlinks (`~/.claude/skills`, `~/.zcode/skills`, `~/.agents/skills` →
canonical), three managed shim blocks, one managed env key, one state file. Everything else
on the machine (evidence trees, backups, session metadata) is **not** source — see 07.

## Version lineage (all hash-verified)

| v | Date | sha8 | Defining change |
|---|---|---|---|
| 0 | 08-26 17:54 | 38128852 | initial install (prose-precedence) |
| 1 | 08-27 08:47 | 1a04e5e9 | prose post-fix (approach failed) |
| 2 | 08-27 10:28 | 0d3ea454 | structural mode separation |
| 3 | 08-27 16:22 | fee98091 | artifact trust boundary (current) |
