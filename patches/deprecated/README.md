# Deprecated patches

### `plan9port-acme-lookb.patch`

Add a `Lookb` command to Acme, which works like the
`Look` command but searches backwards instead of forwards.

This is adapted from an unmerged plan9port pull request by
bd339 ([link](https://github.com/9fans/plan9port/pull/552)).

Deprecated because of added functionality in an upstream
[commit](https://github.com/9fans/plan9port/commit/0c79c32675e83ff3d87d5bf52082652d85486a45)
that makes `Shift-Button3` (Shift-right click) search backward.

### `plan9port-x11-shiftpressbutton1.patch`

Press shift to send Button1 when mouse button is depressed on X11.

This patch makes it so `Shift` sends Button1 while the mouse button is
depressed for X11 systems. This allows for a 2-1 chord via
`Ctrl-Click` followed by pressing `Shift` on laptops.

Deprecated due to breaking mouse chording after upstream
[commit](https://github.com/9fans/plan9port/commit/a2567fcac9851e5cc965a236679f568b0e79cff2).
