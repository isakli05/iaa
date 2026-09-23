#!/usr/bin/env python3
"""İAA deterministic ZCode plugin.zip builder (0.1.1).

Produces the ZCode remote-distribution artifact for the plugin directory
(default: packaging/zcode/plugins/iaa in this repository), mirroring the
official zai-org/zcode-plugins scripts/build_dist.py zip discipline exactly:

  - regular files only; a symlink anywhere in the tree is refused outright
  - entries sorted by path, no directory entries, no Python bytecode
  - every entry under a single top-level directory named after the plugin
    (the marketplace ``path`` identifies that directory inside the archive)
  - fixed entry timestamp (2026-01-01 00:00:00, same constant as upstream)
  - uniform 0644 external attributes, deflate compression

Two builds from the same tree are byte-identical; the sha256 therefore only
changes when plugin content changes. Byte parity with the official builder is
enforced by the release checks (staged-contribution run of upstream
build_dist.py must produce the identical archive).

Usage: scripts/build-plugin-zip.py [plugin_dir] [out.zip]
Prints the sha256 of the written archive on stdout (progress on stderr), so
callers can capture it directly under `set -e`.
Exits non-zero on any unsafe input (symlink, missing manifest).
"""
from __future__ import annotations

import hashlib
import json
import sys
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Same fixed timestamp as the official builder (zcode-plugins build_dist.py).
ZIP_DATE = (2026, 1, 1, 0, 0, 0)

BYTECODE_DIR = "__pycache__"
BYTECODE_SUFFIXES = frozenset({".pyc", ".pyo"})


class UnsafeTree(RuntimeError):
    """A packaged tree contains something that must never be distributed."""


def is_bytecode(path: Path, root: Path) -> bool:
    rel = path.relative_to(root)
    return BYTECODE_DIR in rel.parts or path.suffix in BYTECODE_SUFFIXES


def regular_files(root: Path) -> list[Path]:
    """Every regular file under *root*, refusing symlinks anywhere in the tree
    (same fail-closed policy as the official builder)."""
    if root.is_symlink():
        raise UnsafeTree(f"{root} is a symlink")
    out: list[Path] = []
    for path in sorted(root.rglob("*")):
        if path.is_symlink():
            rel = path.relative_to(root).as_posix()
            raise UnsafeTree(f"refusing to package symlink {rel} in {root.name}")
        if path.is_file() and not is_bytecode(path, root):
            out.append(path)
    return out


def build_zip(plugin_dir: Path, out_path: Path) -> None:
    files = regular_files(plugin_dir)
    if not files:
        raise UnsafeTree(f"{plugin_dir} contains no files")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for f in files:
            arcname = f"{plugin_dir.name}/{f.relative_to(plugin_dir).as_posix()}"
            info = zipfile.ZipInfo(arcname, date_time=ZIP_DATE)
            info.external_attr = 0o644 << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            zf.writestr(info, f.read_bytes())


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    plugin_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else (
        REPO_ROOT / "packaging" / "zcode" / "plugins" / "iaa"
    )
    plugin_dir = plugin_dir.resolve()
    manifest = plugin_dir / ".zcode-plugin" / "plugin.json"
    if not manifest.is_file():
        print(f"build-plugin-zip: missing manifest {manifest}", file=sys.stderr)
        return 1
    meta = json.loads(manifest.read_text(encoding="utf-8"))
    name, version = meta["name"], meta.get("version", "0.0.0")
    if len(sys.argv) > 2:
        out_path = Path(sys.argv[2])
    else:
        out_path = REPO_ROOT / "dist" / f"{name}-{version}-plugin.zip"

    try:
        build_zip(plugin_dir, out_path)
    except UnsafeTree as e:
        print(f"build-plugin-zip: {e}", file=sys.stderr)
        return 1
    print(f"built {out_path} ({name} {version}, {out_path.stat().st_size} bytes)",
          file=sys.stderr)
    print(sha256_of(out_path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
