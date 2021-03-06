# plan9port patches

## Creating and using patches

To create a patch from a Git repo diff (provide arguments to the
`git diff` command as necessary):

```shell
git diff > /path/to/save.patch
```

To apply a patch created using the above (the `-p1` option is to
ignore the leading `a/` and `b/` prefixes created by `git diff`):

```shell
patch -p1 < /path/to/save.patch
```

See this
[link](https://stackoverflow.com/questions/4610744/can-i-get-a-patch-compatible-output-from-git-diff)
for more info.

## Patches

### No remapping of backticks and single quotes on macOS systems

To apply the patch, run from the repository root:

```shell
patch -p1 < /path/to/plan9port-mac-noquotemap.patch
```

This patch removes the default behavior of remapping characters
`` ` `` and `'` to `‘` and `’` in macOS `fontsrv`.

### Press shift to send Button1 when mouse button is depressed

To apply the patch, run from the repository root:

```shell
patch -p1 < /path/to/plan9port-x11-shiftpressbutton1.patch
```

This patch makes it so `Shift` sends Button1 while the mouse button
is depressed for X11 systems. This allows for a 2-1 chord via
`Ctrl-Click` followed by pressing `Shift` on laptops.
