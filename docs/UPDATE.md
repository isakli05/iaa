# Update

## Plugin forms

```sh
claude plugin update iaa            # Claude Code
codex plugin marketplace upgrade …  # Codex (refreshes marketplace snapshots), then re-add if version-pinned
```

ZCode: refresh the marketplace source in Settings, update the plugin, then
Settings → Skills → Refresh.

Updates replace the plugin cache. **Your integration block is not part of the
plugin and is never touched by an update** — it is marker-delimited state in
your own instruction files.

## Personal-skill / deployed form

```sh
cd "$HOME/.local/share/iaa-src" && git pull        # or unpack a new release tarball
sh scripts/iaa deploy                               # repo → ~/.local/share/iaa (transactional, provenance recorded)
sh "$HOME/.local/share/iaa/iaa/scripts/manage.sh" verify
```

`deploy` stages the new tree, verifies it byte-matches the source, moves the
previous live tree aside (`iaa.iaa-previous-<stamp>`, one-command rollback),
and records hashes in `~/.config/iaa/provenance.json`. Consumer links keep
resolving (the live path never changes).

## Version compatibility discipline

- The package version (`VERSION`) and policy revision
  ([POLICY-LINEAGE.md](POLICY-LINEAGE.md)) are independent axes; release notes
  state both.
- Boundary guarantees are version-pinned to tested neighbors — after a
  Superpowers (or other orchestration framework) upgrade, re-run the boundary
  regression and `iaa doctor` before trusting coexistence claims
  ([COMPATIBILITY.md](COMPATIBILITY.md)).
- Mixed versions across channels are detectable: `iaa doctor` compares the
  plugin-cached skill core against the repository core and the recorded
  provenance, and flags drift.

## After updating

```sh
iaa doctor
```

Exit 0 expected. If the update changed the shim text (rare; it is deliberately
stable), re-run the integration step — the block is replaced idempotently with
a fresh backup.
