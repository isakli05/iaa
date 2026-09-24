#!/usr/bin/env python3
"""İAA release pin record tool — archive-content parity (IAA-BL-016).

DEFLATE output is zlib-implementation-dependent: the same plugin tree
compresses to different bytes under stock zlib vs zlib-ng, so a raw-sha
comparison of a freshly built plugin.zip against the published artifact's
pin cannot pass in every environment. What IS zlib-independent is the
archive's *content*: entry names, uncompressed bytes (size, CRC32, sha256),
timestamps, external attributes and compression method.

This tool therefore keeps, per released version, a small authored record
(packaging/release-pins/<version>.json — outside every directory that
scripts/build-packages.sh regenerates) holding:

  - version, canonical release-asset URL, sha256 of the published archive
  - the ordered content manifest: per entry name, file_size, crc32, sha256
    of the uncompressed bytes, date_time, external_attr, compress_type
    (directory entries never occur; the builder writes none)

Modes:

  compare <archive.zip> <record.json>
      Exit 0 iff the archive's content manifest equals the record's.
      Compressed sizes / raw archive bytes are deliberately excluded.

  write <archive.zip> [--out <record.json>]
      Release-only: derive a record from a BUILT archive. Never called by
      build-packages.sh or CI. Refuses to write for a PUBLISHED version —
      v<version> tagged locally or on the canonical remote — on every write,
      whether or not the target file exists (published artifacts are
      immutable). Absence of local tags is never evidence of "unpublished":
      in tag-less clones (CI checkouts, shallow clones) the remote decides.
      Any failure to determine remote publication state (network, missing
      git, non-zero exit) also refuses — fail closed. The remote defaults to
      https://github.com/isakli05/iaa and can be overridden for tests via
      the IAA_RELEASE_PIN_REMOTE environment variable.

Stdlib only.
"""
from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

DEFAULT_REMOTE = "https://github.com/isakli05/iaa"


class PublicationStateUnknown(RuntimeError):
    """Remote publication state could not be determined — callers fail closed."""


def pin_remote() -> str:
    """Canonical remote for publication checks (overridable for tests)."""
    return os.environ.get("IAA_RELEASE_PIN_REMOTE", DEFAULT_REMOTE)

MANIFEST_FIELDS = (
    "name", "file_size", "crc32", "sha256",
    "date_time", "external_attr", "compress_type",
)


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def archive_manifest(zip_path: Path) -> list[dict]:
    """Ordered content manifest of an archive (builder conventions: sorted
    regular files, no directory entries)."""
    out: list[dict] = []
    with zipfile.ZipFile(zip_path) as zf:
        for info in zf.infolist():
            data = zf.read(info.filename)  # verifies CRC32 on read
            out.append({
                "name": info.filename,
                "file_size": info.file_size,
                "crc32": info.CRC,
                "sha256": hashlib.sha256(data).hexdigest(),
                "date_time": list(info.date_time),
                "external_attr": info.external_attr,
                "compress_type": info.compress_type,
            })
    return out


def diff_manifests(actual: list[dict], recorded: list[dict]) -> list[str]:
    """Human-readable content differences between two manifests. Empty list
    == content-identical. Order matters (the builder sorts entries)."""
    diffs: list[str] = []
    a_names = [e["name"] for e in actual]
    r_names = [e["name"] for e in recorded]
    for e in actual:
        if e["name"].endswith("/"):
            diffs.append(f"directory entry present: {e['name']} "
                         "(builder convention forbids directory entries)")
    if a_names != r_names:
        for i, (a, r) in enumerate(zip(a_names, r_names)):
            if a != r:
                diffs.append(f"entry {i}: name {a!r} != recorded {r!r}")
        for n in sorted(set(r_names) - set(a_names)):
            diffs.append(f"missing entry: {n}")
        for n in sorted(set(a_names) - set(r_names)):
            diffs.append(f"extra entry: {n}")
        return diffs
    for a, r in zip(actual, recorded):
        for k in MANIFEST_FIELDS[1:]:
            if a[k] != r[k]:
                diffs.append(f"{a['name']}: {k} {a[k]!r} != recorded {r[k]!r}")
    return diffs


def load_record(record_path: Path) -> dict:
    record = json.loads(record_path.read_text(encoding="utf-8"))
    if "version" not in record or "sha256" not in record or "manifest" not in record:
        raise ValueError(f"{record_path}: not a release-pin record "
                         "(needs version, sha256, manifest)")
    return record


def cmd_compare(archive: Path, record_path: Path) -> int:
    record = load_record(record_path)
    diffs = diff_manifests(archive_manifest(archive), record["manifest"])
    if diffs:
        print(f"release-pin: FAIL: archive content does not match the "
              f"published v{record['version']} artifact "
              f"({record_path.name}, {len(diffs)} difference(s); "
              "compressed bytes are not compared):", file=sys.stderr)
        for d in diffs:
            print(f"  - {d}", file=sys.stderr)
        return 1
    print(f"release-pin: OK: {len(record['manifest'])} entries content-identical "
          f"to record v{record['version']} (compressed bytes not compared)")
    return 0


def archive_version(archive: Path) -> str:
    """Version from the plugin manifest inside the archive
    (<top-level-dir>/.zcode-plugin/plugin.json)."""
    with zipfile.ZipFile(archive) as zf:
        first = zf.infolist()[0].filename
        top = first.split("/")[0]
        meta = json.loads(zf.read(f"{top}/.zcode-plugin/plugin.json"))
    return str(meta["version"])


def version_is_published(version: str, remote: str) -> bool:
    """True iff v<version> is tagged locally or on *remote*.

    A local tag is sufficient evidence (it exists in this clone). Absence of
    local tags proves nothing — CI checkouts and shallow clones carry none —
    so without a local tag the remote decides via `git ls-remote`. Any
    failure to determine the remote's state raises PublicationStateUnknown;
    callers must refuse (fail closed).
    """
    try:
        res = subprocess.run(
            ["git", "-C", str(REPO_ROOT), "tag", "-l", f"v{version}"],
            capture_output=True, text=True)
        if res.returncode == 0 and res.stdout.strip():
            return True
    except OSError:
        pass  # no local evidence; the remote check below is the authority
    try:
        res = subprocess.run(
            ["git", "ls-remote", "--tags", remote, f"refs/tags/v{version}"],
            capture_output=True, text=True)
    except OSError as e:
        raise PublicationStateUnknown(f"cannot run git ls-remote: {e}") from e
    if res.returncode != 0:
        raise PublicationStateUnknown(
            f"git ls-remote --tags {remote} refs/tags/v{version} failed "
            f"(exit {res.returncode}): {res.stderr.strip() or 'no output'}")
    return bool(res.stdout.strip())


def cmd_write(archive: Path, out: Path | None) -> int:
    version = archive_version(archive)
    remote = pin_remote()
    try:
        published = version_is_published(version, remote)
    except PublicationStateUnknown as e:
        print(f"release-pin: refusing to write for v{version}: publication "
              f"state cannot be determined — {e}", file=sys.stderr)
        return 1
    if published:
        print(f"release-pin: refusing to write for v{version}: version is "
              f"published (tag v{version} exists locally or on {remote}); "
              "published artifacts are immutable", file=sys.stderr)
        return 1
    record = {
        "version": version,
        "asset_url": (f"https://github.com/isakli05/iaa/releases/download/"
                      f"v{version}/iaa-{version}-plugin.zip"),
        "sha256": sha256_of(archive),
        "manifest": archive_manifest(archive),
    }
    target = out or (REPO_ROOT / "packaging" / "release-pins" / f"{version}.json")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8")
    print(f"release-pin: wrote {target} (v{version}, {len(record['manifest'])} entries)")
    return 0


def main() -> int:
    args = sys.argv[1:]
    if len(args) >= 3 and args[0] == "compare":
        return cmd_compare(Path(args[1]), Path(args[2]))
    if len(args) >= 2 and args[0] == "write":
        out = None
        rest = args[2:]
        if len(rest) == 2 and rest[0] == "--out":
            out = Path(rest[1])
        elif rest:
            print(__doc__, file=sys.stderr)
            return 2
        return cmd_write(Path(args[1]), out)
    print(__doc__, file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main())
