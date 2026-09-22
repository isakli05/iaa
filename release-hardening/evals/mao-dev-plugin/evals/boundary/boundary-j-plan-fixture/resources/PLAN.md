# notectl v0.2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land the four SPEC.md improvements — fix the "Recieved" typo, add validated `tags` to `Note` with store round-tripping, add substring search, and add CSV export.

**Architecture:** Notectl is a flat stdlib-only package. Each concern lives in one module: `notectl/notes.py` (model + validation), `notectl/store.py` (JSON persistence), plus two new leaf modules `notectl/search.py` and `notectl/export.py` that consume `Note` objects without touching storage. Tests mirror modules one-to-one under `tests/`, using `unittest` + `tempfile` exactly like the existing suite.

**Tech Stack:** Python 3, standard library only (`dataclasses`, `json`, `csv`, `io`, `time`, `unittest`, `tempfile`). No third-party dependencies, no packaging changes.

**Spec:** `SPEC.md` (repo root)

## Global Constraints

- Python 3, standard library only — no new imports outside the stdlib.
- Every feature adds tests; the full suite passes at the end.
- Existing public behavior not mentioned in the spec must not change (signatures, defaults, sorting, and file-format keys `id`/`text`/`created` all stay as-is; `tags` is added alongside them).
- All commands run from the repo root. Full suite: `python3 -m unittest discover`.
- Error messages use the corrected spelling "Received" (never "Recieved").

---

### Task 1: Fix "Recieved" typo in error messages (F1)

Corrects the misspelling in both raise sites. No behavior change beyond message text — both call sites still raise the same exception types.

**Files:**
- Modify: `notectl/notes.py:19` (inside `validate_note`)
- Modify: `notectl/store.py:14` (inside `load_notes`)
- Test: `tests/test_notes.py`, `tests/test_store.py` (add one test each)

**Interfaces:**
- Consumes: existing `ValidationError` (`notectl.notes`), existing `load_notes(path)` which raises `ValueError` on corrupt JSON.
- Produces: unchanged public API. `validate_note` still raises `ValidationError`; `load_notes` still raises `ValueError`; only the message text changes to contain "Received".

- [ ] **Step 1: Write the failing tests**

Add to `tests/test_notes.py`, inside `TestNotes` (after `test_validate_rejects_empty_text`):

```python
    def test_validate_error_message_spells_received(self):
        with self.assertRaises(ValidationError) as cm:
            validate_note(Note(id=1, text="   "))
        self.assertIn("Received", str(cm.exception))
        self.assertNotIn("Recieved", str(cm.exception))
```

Add to `tests/test_store.py`, inside `TestStore` (after `test_missing_file_returns_empty`):

```python
    def test_corrupt_file_error_message_spells_received(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "bad.json")
            with open(path, "w", encoding="utf-8") as fh:
                fh.write("{not json")
            with self.assertRaises(ValueError) as cm:
                load_notes(path)
            self.assertIn("Received", str(cm.exception))
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python3 -m unittest tests.test_notes tests.test_store -v`
Expected: FAIL — 2 failures. `test_validate_error_message_spells_received` fails `assertIn("Received", ...)` because the current message says "Recieved empty note text"; `test_corrupt_file_error_message_spells_received` fails for the same reason ("Recieved corrupt notes file"). All pre-existing tests still pass.

- [ ] **Step 3: Fix the typo in both files**

In `notectl/notes.py:19`, change:

```python
        raise ValidationError("Recieved empty note text")
```

to:

```python
        raise ValidationError("Received empty note text")
```

In `notectl/store.py:14`, change:

```python
        raise ValueError(f"Recieved corrupt notes file: {exc}") from exc
```

to:

```python
        raise ValueError(f"Received corrupt notes file: {exc}") from exc
```

- [ ] **Step 4: Run the full suite to verify it passes**

Run: `python3 -m unittest discover`
Expected: `Ran 7 tests ... OK` (5 pre-existing + 2 new).

- [ ] **Step 5: Commit**

```bash
git add notectl/notes.py notectl/store.py tests/test_notes.py tests/test_store.py
git commit -m "fix: correct \"Recieved\" typo to \"Received\" in error messages"
```

---

### Task 2: Add `tags` field to `Note` with validation (F2, model half)

`Note` gains `tags: list[str]` defaulting to an empty list; `validate_note` rejects non-list values and non-string entries with an error naming the `tags` field.

**Files:**
- Modify: `notectl/notes.py:10-14` (`Note` dataclass) and `notectl/notes.py:17-21` (`validate_note`)
- Test: `tests/test_notes.py`

**Interfaces:**
- Consumes: `ValidationError`, `field` from `dataclasses` (both already imported in `notes.py`).
- Produces: `Note(id: int, text: str, created: float = time.time(), tags: list[str] = [])` — the new keyword argument `tags` with default `[]`. Later tasks rely on this exact field name and default. `validate_note(note: Note) -> None` additionally raises `ValidationError("note tags must be a list of strings")` when `note.tags` is not a `list` of `str`.

- [ ] **Step 1: Write the failing tests**

Add to `tests/test_notes.py`, inside `TestNotes` (after the Task 1 test):

```python
    def test_add_note_defaults_tags_to_empty_list(self):
        notes = []
        note = add_note(notes, "tagged")
        self.assertEqual(note.tags, [])

    def test_validate_accepts_list_of_string_tags(self):
        note = Note(id=1, text="hello", tags=["a", "b"])
        validate_note(note)  # must not raise

    def test_validate_rejects_non_list_tags(self):
        with self.assertRaises(ValidationError) as cm:
            validate_note(Note(id=1, text="hello", tags="a"))
        self.assertIn("tags", str(cm.exception))

    def test_validate_rejects_non_string_tag_entries(self):
        with self.assertRaises(ValidationError) as cm:
            validate_note(Note(id=1, text="hello", tags=["a", 1]))
        self.assertIn("tags", str(cm.exception))
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python3 -m unittest tests.test_notes -v`
Expected: FAIL — 4 errors/failures. The three tests constructing `Note(..., tags=...)` error with `TypeError: __init__() got an unexpected keyword argument 'tags'`; `test_add_note_defaults_tags_to_empty_list` fails with `AttributeError: 'Note' object has no attribute 'tags'`.

- [ ] **Step 3: Implement the field and validation**

In `notectl/notes.py`, extend the dataclass (add `tags` after `created` — both have defaults, so ordering is legal):

```python
@dataclass
class Note:
    id: int
    text: str
    created: float = field(default_factory=time.time)
    tags: list[str] = field(default_factory=list)
```

And extend `validate_note` with a third check after the id check:

```python
def validate_note(note: Note) -> None:
    if not isinstance(note.text, str) or not note.text.strip():
        raise ValidationError("Received empty note text")
    if not isinstance(note.id, int) or note.id < 1:
        raise ValidationError("note id must be a positive integer")
    if not isinstance(note.tags, list) or not all(isinstance(t, str) for t in note.tags):
        raise ValidationError("note tags must be a list of strings")
```

(Keep the "Received" spelling from Task 1 in the first message.)

- [ ] **Step 4: Run the full suite to verify it passes**

Run: `python3 -m unittest discover`
Expected: `Ran 11 tests ... OK`.

- [ ] **Step 5: Commit**

```bash
git add notectl/notes.py tests/test_notes.py
git commit -m "feat: add tags field to Note with validation"
```

---

### Task 3: Store round-trips tags; legacy files default to `[]` (F2, persistence half)

`save_notes` writes the `tags` key; `load_notes` reads it with `d.get("tags", [])` so files saved by v0.1 (no `tags` key) load with `tags == []`.

**Files:**
- Modify: `notectl/store.py:15` (`load_notes` return) and `notectl/store.py:18-20` (`save_notes`)
- Test: `tests/test_store.py`

**Interfaces:**
- Consumes: `Note(..., tags=[...])` from Task 2 (keyword arg with default `[]`).
- Produces: unchanged signatures `load_notes(path) -> list` and `save_notes(path, notes: list) -> None`. JSON schema becomes `{"id", "text", "created", "tags"}`; `load_notes` tolerates the legacy schema missing `tags`.

- [ ] **Step 1: Write the failing test (and the legacy regression test)**

Add to `tests/test_store.py`, inside `TestStore` (after the Task 1 test):

```python
    def test_round_trip_preserves_tags(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "notes.json")
            save_notes(path, [Note(id=1, text="hello", tags=["a", "b"])])
            loaded = load_notes(path)
            self.assertEqual(loaded[0].tags, ["a", "b"])

    def test_legacy_file_without_tags_defaults_to_empty(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "legacy.json")
            with open(path, "w", encoding="utf-8") as fh:
                fh.write('[{"id": 1, "text": "old", "created": 100.0}]')
            loaded = load_notes(path)
            self.assertEqual(loaded[0].tags, [])
```

- [ ] **Step 2: Run tests to verify the round-trip test fails**

Run: `python3 -m unittest tests.test_store -v`
Expected: `test_round_trip_preserves_tags` FAILS on `self.assertEqual(loaded[0].tags, ["a", "b"])` — the current `load_notes` never reads a tags key, and the current `save_notes` never writes one. `test_legacy_file_without_tags_defaults_to_empty` may already PASS, because `Note`'s default from Task 2 covers it — it is the spec-mandated regression guard for old files, so keep it regardless.

- [ ] **Step 3: Implement tags in load and save**

Replace the body of `load_notes`'s return and `save_notes` in `notectl/store.py` so the module reads:

```python
def load_notes(path) -> list:
    try:
        with open(path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
    except FileNotFoundError:
        return []
    except json.JSONDecodeError as exc:
        raise ValueError(f"Received corrupt notes file: {exc}") from exc
    return [
        Note(id=d["id"], text=d["text"], created=d["created"], tags=d.get("tags", []))
        for d in data
    ]


def save_notes(path, notes: list) -> None:
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(
            [{"id": n.id, "text": n.text, "created": n.created, "tags": n.tags} for n in notes],
            fh,
            indent=2,
        )
```

(Keep the "Received" spelling from Task 1; only the `Note(...)` construction and the dumped dict change.)

- [ ] **Step 4: Run the full suite to verify it passes**

Run: `python3 -m unittest discover`
Expected: `Ran 13 tests ... OK`.

- [ ] **Step 5: Commit**

```bash
git add notectl/store.py tests/test_store.py
git commit -m "feat: persist tags in store with legacy default"
```

---

### Task 4: Substring search module (F3)

New leaf module `notectl/search.py` exposing `find_notes(notes, query)` — case-insensitive substring match on `text`, results sorted by id, empty query returns everything.

**Files:**
- Create: `notectl/search.py`
- Test: `tests/test_search.py` (new file)

**Interfaces:**
- Consumes: `Note` (`.id`, `.text`) and `list_notes(notes: list) -> list` from `notectl/notes.py` (reuse it for the id sort instead of re-implementing).
- Produces: `find_notes(notes: list, query: str) -> list` returning a new list of `Note` objects sorted by `id`. Does not mutate its input.

- [ ] **Step 1: Write the failing tests**

Create `tests/test_search.py`:

```python
import unittest

from notectl.notes import Note
from notectl.search import find_notes


class TestSearch(unittest.TestCase):
    def test_match_returns_note(self):
        notes = [Note(id=1, text="Hello world"), Note(id=2, text="zebra")]
        result = find_notes(notes, "hello")
        self.assertEqual([n.id for n in result], [1])

    def test_no_match_returns_empty(self):
        notes = [Note(id=1, text="Hello world")]
        self.assertEqual(find_notes(notes, "qqq"), [])

    def test_empty_query_returns_all_sorted_by_id(self):
        notes = [Note(id=3, text="c"), Note(id=1, text="a"), Note(id=2, text="b")]
        self.assertEqual([n.id for n in find_notes(notes, "")], [1, 2, 3])

    def test_case_variance(self):
        notes = [Note(id=1, text="GrEeN Bananas")]
        self.assertEqual([n.id for n in find_notes(notes, "GREEN bananas")], [1])


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python3 -m unittest tests.test_search -v`
Expected: FAIL — 4 errors, all `ModuleNotFoundError: No module named 'notectl.search'`.

- [ ] **Step 3: Implement the module**

Create `notectl/search.py`:

```python
"""Case-insensitive substring search over notes."""
from .notes import list_notes


def find_notes(notes: list, query: str) -> list:
    """Return notes whose text contains query, case-insensitively, sorted by id.

    An empty query is contained in every text, so it returns all notes.
    """
    q = query.lower()
    matches = [n for n in notes if q in n.text.lower()]
    return list_notes(matches)
```

- [ ] **Step 4: Run the full suite to verify it passes**

Run: `python3 -m unittest discover`
Expected: `Ran 17 tests ... OK`.

- [ ] **Step 5: Commit**

```bash
git add notectl/search.py tests/test_search.py
git commit -m "feat: add substring search module"
```

---

### Task 5: CSV export module (F4)

New leaf module `notectl/export.py` exposing `to_csv(notes)` — RFC 4180 CSV via stdlib `csv` with header `id,text,created,tags` and tags joined with `|`.

**Files:**
- Create: `notectl/export.py`
- Test: `tests/test_export.py` (new file)

**Interfaces:**
- Consumes: `Note` (`.id`, `.text`, `.created`, `.tags`) from Task 2.
- Produces: `to_csv(notes: list) -> str`. One header row plus one row per note, in the order given (the spec sets no row order). Rows are terminated `\r\n` (RFC 4180); fields containing commas are quoted; the tags column is `"|".join(note.tags)`, empty for no tags.

- [ ] **Step 1: Write the failing tests**

Create `tests/test_export.py`:

```python
import unittest

from notectl.export import to_csv
from notectl.notes import Note


class TestExport(unittest.TestCase):
    def test_header_and_tags_column(self):
        result = to_csv([Note(id=1, text="hello", created=100.0, tags=["a", "b"])])
        self.assertEqual(result, "id,text,created,tags\r\n1,hello,100.0,a|b\r\n")

    def test_comma_in_text_is_quoted(self):
        result = to_csv([Note(id=2, text="has, comma", created=200.0, tags=[])])
        self.assertEqual(result, "id,text,created,tags\r\n2,\"has, comma\",200.0,\r\n")

    def test_empty_tags_renders_empty_column(self):
        result = to_csv([Note(id=1, text="hello", created=100.0, tags=[])])
        self.assertEqual(result, "id,text,created,tags\r\n1,hello,100.0,\r\n")


if __name__ == "__main__":
    unittest.main()
```

(The tests pin exact strings, `\r\n` included — that is the RFC 4180 check. `created` is passed explicitly so the float renders deterministically as `100.0`/`200.0`.)

- [ ] **Step 2: Run tests to verify they fail**

Run: `python3 -m unittest tests.test_export -v`
Expected: FAIL — 3 errors, all `ModuleNotFoundError: No module named 'notectl.export'`.

- [ ] **Step 3: Implement the module**

Create `notectl/export.py`:

```python
"""CSV export for notes."""
import csv
import io


def to_csv(notes: list) -> str:
    """Render notes as an RFC 4180 CSV string with header id,text,created,tags.

    Tags are joined with "|"; fields needing it (e.g. text containing a
    comma) are quoted by the csv module.
    """
    buf = io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(["id", "text", "created", "tags"])
    for n in notes:
        writer.writerow([n.id, n.text, n.created, "|".join(n.tags)])
    return buf.getvalue()
```

- [ ] **Step 4: Run the full suite to verify everything passes**

Run: `python3 -m unittest discover`
Expected: `Ran 20 tests ... OK` — this is the spec's "full suite passes at the end" gate.

- [ ] **Step 5: Commit**

```bash
git add notectl/export.py tests/test_export.py
git commit -m "feat: add CSV export module"
```
