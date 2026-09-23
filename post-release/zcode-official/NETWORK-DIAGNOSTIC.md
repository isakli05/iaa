# ZCode 3.14.3 Provider Connection Failure — Controlled Diagnostic Record

Date: 2026-09-23 (second pass, owner-authorized). All tests process-local;
no system networking, credentials, or account state were modified; no API
keys are reproduced here. ZCode GUI was closed cleanly before testing
(verified: no processes) and no GUI instance was left running afterward.

## Status

**CONFIRMED at the embedded-runtime level** (single-variable A/B inside
ZCode's own Node runtime, below), **corroborated by matching upstream issue
[zai-org/feedback#699]**(https://github.com/zai-org/feedback/issues/699),
which additionally confirms the same mechanism on the real in-app path and
a working app-level workaround. **Not a Z.ai backend failure** — the
backend answers HTTP 200 from this machine via curl.

## Baseline (2026-09-23T21:28+03:00)

- ZCode **3.14.3** (AppImage `3.14.3.7762`); embedded runtime: Electron
  (packaged), **Node 24.14.0**, undici 7.21.0, `autoSelectFamily` default
  **true**, `autoSelectFamilyAttemptTimeout` default **250 ms**.
- IPv4: default route via 192.168.1.1 (wlan0) — working.
- IPv6: **no global address, no default route** — egress dead; `curl -6`
  → connect failure in ~2 ms.
- DNS `api.z.ai`: A `8.217.100.151` (+`8.217.233.95`), AAAA `240b:4001:…` ×2.
- `/etc/gai.conf` exists but contains only comments → glibc default
  ordering; `dns.lookup('api.z.ai')` returns **IPv4-first** on this machine
  (no v6 source address → RFC 6724 source selection sorts v4 first).
- `curl -4 https://api.z.ai/api/anthropic` → **HTTP 200** (~1.0–1.3 s);
  `curl -6` → instant failure.
- No desktop/system proxy anywhere (KDE/gsettings/env/ports all clear).
- App-log signature (owner GUI window): `model.request.failed` /
  `model.network.failed` `reason: timeout`, `errorPhase: connect`, 74×,
  both `builtin:zai-coding-plan` (40×) and `zai-api` (34×);
  `model.client_signing.handshake_failed` `errorKind: handshake-network`;
  zero successful model requests in either day's logs.

## Why the original "IPv6-first DNS" hypothesis was incomplete

`dns.lookup` is already IPv4-first here, and `NODE_OPTIONS=
--dns-result-order=ipv4first` does **not** fix the failing fetch — DNS
ordering is not the mechanism. The mechanism is Node's
**`autoSelectFamily` Happy-Eyeballs (RFC 8305), which prefers IPv6
regardless of getaddrinfo order**: it opens with the dead IPv6
(ENETUNREACH in ~20 ms), then races IPv4 under a **250 ms** per-attempt
budget; an IPv4 connect that needs >250 ms (measured ~480 ms here,
~320 ms in #699) is killed by `internalConnectMultipleTimeout` →
`AggregateError [ETIMEDOUT]` surfaced as plain ETIMEDOUT.

## Controlled A/B (ZCode's own embedded Node via `ELECTRON_RUN_AS_NODE`; same binary, machine, moment; no credentials — connect-phase only)

| Test | Result |
|---|---|
| a) TCP connect `family:4` | **OK, 480 ms** |
| b) TCP connect `family:6` | **ENETUNREACH, 21 ms** |
| plain `fetch` (default `autoSelectFamily=true`) | **ETIMEDOUT** — 696 / 741 / 597 ms (3 runs) |
| `fetch` + `--dns-result-order=ipv4first` | **ETIMEDOUT** (741 ms) — rules out DNS-order theory |
| `fetch` + `--no-network-family-autoselection` | **HTTP 200** — 1632 / 1998 ms (2 runs) |

Single variable (`autoSelectFamily`): default fails, disabled succeeds.
Credentials are irrelevant to the mechanism (failure is at connect phase,
before any auth).

## Why the app itself cannot be switched process-locally

- Launching the real app with `NODE_OPTIONS` produces Electron's own
  error: **"Most NODE_OPTIONs are not supported in packaged apps"**, and
  the app starts regardless (probe, then closed cleanly).
- #699 additionally documents that `zcode-host` spawns `zcode-cli` with a
  **sanitized environment that strips `NODE_OPTIONS`** — so even an
  accepted flag would not reach the process making model requests.
- Therefore an in-GUI A/B with a process-local knob is **not currently
  possible**; per the brief, no system-wide changes were made.

## Matching upstream issue

**[zai-org/feedback#699](https://github.com/zai-org/feedback/issues/699)**
(open; "[Bug] Connect account does not work", 2026-09-17): ZCode 3.14.1
Linux (.deb), Electron 41 / Node v24.14.0 — identical signature
(`handshake-network` → ETIMEDOUT on all model requests; OAuth token
exchange failing), identical root-cause analysis (autoSelectFamily 250 ms
vs >250 ms IPv4 RTT), identical repro (`ELECTRON_RUN_AS_NODE` fetch fails;
`--no-network-family-autoselection` succeeds), plus an **in-app-confirmed
workaround**: `/etc/hosts` `127.0.0.1 api.z.ai` + local `socat` TCP relay
to the real CDN IP (localhost connects beat the 250 ms timer; TLS
end-to-end unchanged) — fixed model requests AND OAuth login. Follow-up
notes Node 26 raises the attempt timeout default to 500 ms (runtime bump
would likely fix).

Our data adds a second, independent confirmation at **3.14.3** on
CachyOS/AppImage. Related but distinct: #511 (false "Reconnecting" badge
from usage-stats polling while the model path is healthy — explains some
UI badge reports, not the hard request failures seen here).

**No new issue should be filed** (it would duplicate #699). Prepared
instead: a confirming comment draft (below), to be posted only with owner
approval.

## Prepared comment draft for #699 (NOT posted)

> Independent confirmation on ZCode **3.14.3** (AppImage `3.14.3.7762`,
> CachyOS/Linux, Electron packaged / Node 24.14.0, undici 7.21.0):
> same signature — `model.client_signing.handshake_failed`
> (`handshake-network`) then `ETIMEDOUT` on every model request; OAuth and
> API-key modes both affected; zero successful model requests in the logs.
> Baseline: IPv4-only egress (no global IPv6, no v6 route), DNS returns
> 2×A + 2×AAAA, `curl -4` → HTTP 200 (~1.0 s), `curl -6` → instant fail;
> measured IPv4 TCP connect to api.z.ai ≈ **480 ms** (>250 ms budget).
> Controlled A/B with the shipped runtime (`ELECTRON_RUN_AS_NODE=1`):
> plain `fetch` → ETIMEDOUT (3/3 runs, ~0.6–0.75 s);
> `--dns-result-order=ipv4first` → still ETIMEDOUT (DNS order is not the
> mechanism); `--no-network-family-autoselection` → **HTTP 200** (2/2
> runs). Also confirmed the packaged app rejects `NODE_OPTIONS`
> ("Most NODE_OPTIONs are not supported in packaged apps"), consistent
> with the sanitized spawn environment you described. +1 to the
> suggestions (raise `autoSelectFamilyAttemptTimeout` on the API client,
> stop stripping `NODE_OPTIONS`, or bump the runtime to Node 26's 500 ms
> default).

## Owner remediation options (deferred — none executed)

1. Comment on / subscribe to #699 (draft above) and wait for the ZCode fix.
2. The #699-confirmed workaround (scoped, reversible): `/etc/hosts` +
   local relay for `api.z.ai`.
3. Transient `sysctl net.ipv6.conf.all.disable_ipv6=1` during ZCode use
   (system-wide; revert after).
4. Any of these unblocks the `$iaa` GUI behavioral leg for the 0.1.1
   pre-release acceptance run.
