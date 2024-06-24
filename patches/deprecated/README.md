# Deprecated patches

### `plan9port-acme-lookb.patch`

Add a `Lookb` command to Acme, which works like the
`Look` command but searches backwards instead of forwards.

This is adapted from an unmerged plan9port pull request by
bd339 ([link](https://github.com/9fans/plan9port/pull/552)).

This was deprecated because of added functionality in an upstream
[commit](https://github.com/9fans/plan9port/commit/0c79c32675e83ff3d87d5bf52082652d85486a45)
that makes `Shift-Button3` (Shift-right click) search backward.
