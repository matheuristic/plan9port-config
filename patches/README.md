# plan9port patches

## Creating and using patches

To create a patch from a Git repo diff (provide arguments to the
`git diff` command as necessary):

```sh
git diff > /path/to/save.patch
```

To apply a patch created using the above (the `-p1` option is to
ignore the leading `a/` and `b/` prefixes created by `git diff`):

```sh
patch -p1 < /path/to/save.patch
```

See this
[link](https://stackoverflow.com/questions/4610744/can-i-get-a-patch-compatible-output-from-git-diff)
for more info.

For convenience, a shell script `apply-patches.sh` can be run
to apply all patches in this directory:

```sh
./apply-patches.sh /path/to/plan9port/repository
```

## Patches

### Add keybindings to Acme editor

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-acme-addkeybindings.patch
```

This patch adds the following keybindings:

- `C-n`: move point one line down
- `C-p`: move point one line up
- `Cmd-s`: execute `Put` (i.e., save file) on macOS

Sourced from [plan9port](https://github.com/9fans/plan9port) forks by
[prodhe](https://github.com/prodhe/plan9port) (for `C-n` and `C-p`),
and [ixtenu](https://github.com/ixtenu/plan9port) (for `Cmd-s`).

### Add soft tabs to Acme editor

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-acme-soft-tabs.patch
```

This patch adds a `Spaces` command, which can be used to toggle soft
tabs (spacesindent mode). `Spaces on` and `Spaces off` turns
spacesindent mode on and off for the current window. `Spaces ON` and
`Spaces OFF` turns spacesindent mode on and off for existing and
future windows.

Additionally, this patch adds a command line option `-i` which causes
each window to start in spacesindent mode (same as `Spaces ON`).

Sourced with minor changes from [mkhl](https://github.com/mkhl)'s
[acme/soft-tabs](https://github.com/mkhl/plan9port/tree/acme/soft-tabs)
branch of [Plan 9 Port](https://github.com/9fans/plan9port)
which ports spew's acme spaces indent mode from 9front.

### Make scaling of PPI in page optional

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-page-optionalscaleppi.patch
```

The `page` command scales PPI automatically when using high-DPI
screens like Mac displays (see
[commit](https://github.com/9fans/plan9port/commit/940f1fd6af2c144d0db087fefa8478d2a36633d5)).
This patch makes that behavior togglable, so PPI is scaled only when
the `-s` option is specified, i.e., `page -s somefile.pdf` scales PPI
while `page somefile.pdf` does not.

### No remapping of backticks and single quotes on macOS systems

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-mac-noquotemap.patch
```

This patch removes the default behavior of remapping characters
`` ` `` and `'` to `‘` and `’` in macOS `fontsrv`.

### Press shift to send Button1 when mouse button is depressed on X11

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-x11-shiftpressbutton1.patch
```

This patch makes it so `Shift` sends Button1 while the mouse button is
depressed for X11 systems. This allows for a 2-1 chord via
`Ctrl-Click` followed by pressing `Shift` on laptops.
