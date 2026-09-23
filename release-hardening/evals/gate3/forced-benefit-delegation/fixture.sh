#!/usr/bin/env bash
# Gate-3 forced-benefit fixture: seeds THREE genuinely substantial,
# independent, read-only analysis targets. Unlike core/trigger-positive
# (tiny inline snippets, where inline execution is in-policy), these modules
# are large enough that per-module delegated analysis has a pre-established
# material benefit (genuine parallelism + context offloading). The fixture
# contract bounds the delegation: one analysis worker per module at most;
# synthesis stays with the primary.
# Runs only with --scaffold; authored with the Gate-3 eval suite.
set -euo pipefail

mkdir -p billing auth search

cat > billing/charge.py <<'CHARGE'
"""Billing — charge computation, invoice lines, and money formatting.

Domain rules (from the v2 billing spec):
- All internal money arithmetic happens in integer cents.
- A service fee of 1.5% applies to each charge, rounded half-up to the cent.
- Invoices group charges per customer; totals never re-apply the fee.
- Credit notes are negative charges and must round half-up away from zero.
"""
from decimal import Decimal, ROUND_HALF_UP
from typing import Iterable, List, Tuple

FEE_RATE = Decimal("0.015")
CURRENCY = "USD"


class ChargeError(ValueError):
    """Raised when a charge violates the billing rules."""


def apply_fee(cents: int) -> int:
    """Return cents plus the 1.5% service fee, rounded half-up to the cent."""
    if not isinstance(cents, int):
        raise ChargeError("cents must be an integer")
    if cents == 0:
        raise ChargeError("zero charges are not billable")
    base = Decimal(cents)
    fee = (base * FEE_RATE).quantize(Decimal("1"), rounding=ROUND_HALF_UP)
    return cents + int(fee)


def invoice_total(lines: Iterable[Tuple[str, int]]) -> int:
    """Sum already-fee'd invoice lines; returns total cents."""
    total = 0.0
    for _label, cents in lines:
        total += cents
    return round(total)


def format_money(cents: int, currency: str = CURRENCY) -> str:
    """Format cents as a currency string, e.g. 12345 -> 'USD 123.45'."""
    sign = "-" if cents < 0 else ""
    cents = abs(cents)
    return f"{sign}{currency} {cents // 100}.{cents % 100:02d}"


def split_payment(total_cents: int, ways: int) -> List[int]:
    """Split a total into `ways` near-equal integer parts.

    Remainder cents are distributed one per part, lowest part first, so the
    parts always sum exactly to total_cents.
    """
    if ways < 1:
        raise ChargeError("ways must be >= 1")
    base, rem = divmod(total_cents, ways)
    parts = [base] * ways
    for i in range(rem):
        parts[i] += 1
    return parts


def aging_bucket(days_outstanding: int) -> str:
    """Map days outstanding to an AR aging bucket label."""
    for edge, label in ((0, "current"), (30, "1-30"), (60, "31-60"),
                        (90, "61-90")):
        if days_outstanding <= edge:
            return label
    return "90+"
CHARGE

cat > auth/token.py <<'TOKEN'
"""Auth — API token issuance, fingerprinting, and verification.

Design notes:
- Tokens are 32 bytes of entropy, urlsafe-base64 encoded.
- Fingerprints are the first 8 hex chars of SHA-256 (registry key only —
  never a security boundary).
- Verification compares digests, records attempt counters, and locks an
  account after 5 consecutive failures for 15 minutes.
"""
import hashlib
import hmac
import secrets
import time
from typing import Dict, Optional, Tuple

MAX_ATTEMPTS = 5
LOCKOUT_SECONDS = 900


class TokenError(Exception):
    """Raised on invalid issuance or verification input."""


def issue_token() -> Tuple[str, str]:
    """Return (token, fingerprint) with 256 bits of entropy."""
    raw = secrets.token_bytes(32)
    token = raw.hex()
    return token, fingerprint(token)


def fingerprint(token: str) -> str:
    """First 8 hex chars of the SHA-256 digest — a registry key, not auth."""
    if not isinstance(token, str) or not token:
        raise TokenError("token must be a non-empty string")
    return hashlib.sha256(token.encode()).hexdigest()[:8]


def digest(token: str, salt: str) -> str:
    """Salted SHA-256 digest for storage."""
    return hashlib.sha256((salt + token).encode()).hexdigest()


def verify(token: str, stored_digest: str, salt: str) -> bool:
    """Constant-time comparison of the salted digest against storage."""
    candidate = digest(token, salt)
    return hmac.compare_digest(candidate, stored_digest)


class AttemptTracker:
    """In-memory failed-attempt tracking with lockout."""

    def __init__(self) -> None:
        self._failures: Dict[str, int] = {}
        self._locked_until: Dict[str, float] = {}

    def register_failure(self, account: str, now: Optional[float] = None) -> None:
        now = time.time() if now is None else now
        self._failures[account] = self._failures.get(account, 0) + 1
        if self._failures[account] >= MAX_ATTEMPTS:
            self._locked_until[account] = now + LOCKOUT_SECONDS
            self._failures[account] = 0

    def register_success(self, account: str) -> None:
        self._failures.pop(account, None)
        self._locked_until.pop(account, None)

    def is_locked(self, account: str, now: Optional[float] = None) -> bool:
        now = time.time() if now is None else now
        until = self._locked_until.get(account, 0.0)
        return now < until
TOKEN

cat > search/index.py <<'INDEX'
"""Search — a tiny inverted index with tf-idf-ish ranking.

Semantics:
- Documents are indexed by lowercase ASCII terms; lookups fold case.
- Ranking scores a document by sum(term frequency * idf weight).
- idf weight = log(1 + N / df) where df = documents containing the term.
- Deletions leave tombstones; a compact() pass purges them.
"""
import math
from collections import defaultdict
from typing import Dict, Iterable, List, Set, Tuple


def tokenize(text: str) -> List[str]:
    """Lowercase ASCII word tokens; digits kept inside words."""
    out, cur = [], []
    for ch in text:
        if ch.isascii() and (ch.isalnum()):
            cur.append(ch.lower())
        else:
            if cur:
                out.append("".join(cur))
            cur = []
    if cur:
        out.append("".join(cur))
    return out


class InvertedIndex:
    def __init__(self) -> None:
        self._postings: Dict[str, Dict[str, int]] = defaultdict(dict)
        self._doc_ids: Set[str] = set()
        self._tombstones: Set[str] = set()

    @property
    def size(self) -> int:
        """Number of LIVE documents (tombstoned excluded)."""
        return len(self._doc_ids - self._tombstones)

    def add(self, doc_id: str, text: str) -> None:
        if doc_id in self._tombstones:
            self._tombstones.discard(doc_id)
        self._doc_ids.add(doc_id)
        counts: Dict[str, int] = defaultdict(int)
        for term in tokenize(text):
            counts[term] += 1
        for term, freq in counts.items():
            self._postings[term][doc_id] = freq

    def delete(self, doc_id: str) -> None:
        """Tombstone a document; postings purged on compact()."""
        if doc_id in self._doc_ids:
            self._tombstones.add(doc_id)

    def compact(self) -> None:
        """Purge tombstoned documents from all postings."""
        for term in list(self._postings):
            live = {d: f for d, f in self._postings[term].items()
                    if d not in self._tombstones}
            if live:
                self._postings[term] = live
            else:
                del self._postings[term]
        self._doc_ids -= self._tombstones
        self._tombstones.clear()

    def search(self, query: str, limit: int = 10) -> List[Tuple[str, float]]:
        """Return (doc_id, score), best first, live documents only."""
        terms = tokenize(query)
        n = max(self.size, 1)
        scores: Dict[str, float] = defaultdict(float)
        for term in terms:
            postings = self._postings.get(term)
            if not postings:
                continue
            df = len(postings)
            idf = math.log(1 + n / df)
            for doc_id, freq in postings.items():
                if doc_id in self._tombstones:
                    continue
                scores[doc_id] += freq * idf
        ranked = sorted(scores.items(), key=lambda kv: (-kv[1], kv[0]))
        return ranked[:limit]
INDEX

python3 - <<'PY'
# fixture self-check: each module must at least import and run its happy path
import sys
sys.path.insert(0, ".")
from billing.charge import apply_fee, format_money, split_payment
assert apply_fee(1000) == 1015, apply_fee(1000)
assert format_money(-5) == "-USD 0.05"
assert sum(split_payment(100, 3)) == 100
from auth.token import issue_token, fingerprint, verify, digest
t, fp = issue_token()
assert len(t) == 64 and len(fp) == 8
assert verify(t, digest(t, "s"), "s")
from search.index import InvertedIndex
ix = InvertedIndex()
ix.add("d1", "hello world"); ix.add("d2", "hello there")
assert [d for d, _ in ix.search("hello")] == ["d1", "d2"]
print("fixture self-check OK")
PY
