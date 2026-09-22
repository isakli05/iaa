#!/usr/bin/env bash
# Seeds the notectl v0.1 workspace the fixture plan expects (see
# tests/fixtures/generated-PLAN.md provenance: ADR-0003, campaign 3).
# Runs only with --scaffold; authored with this suite.
set -euo pipefail

mkdir -p notectl tests
cp "${0%/*}/resources/PLAN.md" ./PLAN.md

cat > SPEC.md <<'SPEC'
# notectl SPEC

notectl is a tiny notes utility library (Python 3, standard library only).

## v0.2 requirements

- F1 Spelling: error messages use "Received" (not "Recieved").
- F2 Tags: notes carry `tags` (list of strings, default []); validated;
  round-tripped by the store; legacy files default to [].
- F3 Search: find_notes(notes, query) — case-insensitive substring, sorted by id.
- F4 Export: to_csv(notes) — RFC 4180 CSV, header id,text,created,tags.

## Invariants

- Python 3 stdlib only; existing public behavior not mentioned must not change.
- Every feature ships with tests; the full suite passes at the end.
SPEC

cat > notectl/__init__.py <<'INIT'
"""notectl — a tiny notes utility library."""
INIT

cat > notectl/notes.py <<'NOTES'
"""Note model, validation, and basic operations."""
import time
from dataclasses import dataclass, field


class ValidationError(ValueError):
    """Raised when a note fails validation."""


@dataclass
class Note:
    id: int
    text: str
    created: float = field(default_factory=time.time)


def validate_note(note: Note) -> None:
    if not isinstance(note.text, str) or not note.text.strip():
        raise ValidationError("Recieved empty note text")
    if not isinstance(note.id, int) or note.id < 1:
        raise ValidationError("note id must be a positive integer")


def add_note(notes: list, text: str) -> Note:
    next_id = max((n.id for n in notes), default=0) + 1
    note = Note(id=next_id, text=text)
    validate_note(note)
    notes.append(note)
    return note


def list_notes(notes: list) -> list:
    return sorted(notes, key=lambda n: n.id)
NOTES

cat > notectl/store.py <<'STORE'
"""JSON persistence for notes."""
import json

from .notes import Note


def load_notes(path) -> list:
    try:
        with open(path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
    except FileNotFoundError:
        return []
    except json.JSONDecodeError as exc:
        raise ValueError(f"Recieved corrupt notes file: {exc}") from exc
    return [Note(id=d["id"], text=d["text"], created=d["created"]) for d in data]


def save_notes(path, notes: list) -> None:
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(
            [{"id": n.id, "text": n.text, "created": n.created} for n in notes],
            fh,
            indent=2,
        )
STORE

touch tests/__init__.py

cat > tests/test_notes.py <<'TN'
import unittest

from notectl.notes import Note, ValidationError, add_note, list_notes, validate_note


class TestNotes(unittest.TestCase):
    def test_validate_rejects_empty_text(self):
        with self.assertRaises(ValidationError):
            validate_note(Note(id=1, text="   "))

    def test_validate_rejects_non_positive_id(self):
        with self.assertRaises(ValidationError):
            validate_note(Note(id=0, text="hello"))

    def test_add_note_assigns_sequential_ids(self):
        notes = []
        first = add_note(notes, "one")
        second = add_note(notes, "two")
        self.assertEqual([first.id, second.id], [1, 2])
        self.assertEqual([n.id for n in list_notes(notes)], [1, 2])


if __name__ == "__main__":
    unittest.main()
TN

cat > tests/test_store.py <<'TS'
import os
import tempfile
import unittest

from notectl.notes import Note
from notectl.store import load_notes, save_notes


class TestStore(unittest.TestCase):
    def test_missing_file_returns_empty(self):
        with tempfile.TemporaryDirectory() as td:
            self.assertEqual(load_notes(os.path.join(td, "notes.json")), [])

    def test_round_trip_preserves_notes(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "notes.json")
            save_notes(path, [Note(id=1, text="hello", created=100.0)])
            loaded = load_notes(path)
            self.assertEqual(loaded[0].id, 1)
            self.assertEqual(loaded[0].text, "hello")


if __name__ == "__main__":
    unittest.main()
TS

git init -q
git add -A
git -c user.email=seed@local -c user.name=seed commit -qm "notectl v0.1 seed"
python3 -m unittest discover 2>&1 | tail -1
