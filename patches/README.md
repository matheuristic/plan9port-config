# plan9port patches

## Creating and using patches

To create a patch from a Git repo diff (provide arguments like a
commit range to `git diff` as necessary), run in the Git repo:

```sh
git diff > /path/to/save.patch
```

To apply a patch created using the above (the `-p1` option is to
ignore the leading `a/` and `b/` prefixes created by `git diff`),
run from the Git repo root:

```sh
patch -p1 < /path/to/save.patch
```

See this
[link](https://stackoverflow.com/questions/4610744/can-i-get-a-patch-compatible-output-from-git-diff)
for more info.

For convenience, a shell script `apply-patches.sh` can be run
to apply all patches in this directory to a specified plan9port
repository:

```sh
./apply-patches.sh /path/to/plan9port/repository
```

## Patches

### `plan9port-acme-bindings.patch`

Add extra Acme keyboard bindings:

- `C-k`: forward erase to end of line
- `C-n`: move point one line down
- `C-p`: move point one line up
- `Cmd-a`: select all content in window
- `Cmd-e`: execute text (like Button2) on macOS
- `Cmd-s`: execute `Put` (i.e., save file) on macOS

Some portions of this patch are sourced from
[plan9port](https://github.com/9fans/plan9port) forks by
[prodhe](https://github.com/prodhe/plan9port) (`C-n` and `C-p`), and
[ixtenu](https://github.com/ixtenu/plan9port) (`Cmd-s`).

### `plan9port-acme-extrafilechars.patch`

Allow round and square brackets and tildes in file and dir names
in Acme.

Contrary to expectation, Button3 in Acme does not open files and
directories with round and square brackets (`(`, `)`, `[`, `]`)
or tildes (`~`) in their name. This patch makes it so Acme will
open them as expected.

### `plan9port-acme-soft-tabs.patch`

Add soft tabs to Acme.

Specifically, this patch adds a `Spaces` command which can be used
to toggle soft tabs (spacesindent mode), that is, expanding tabs
to spaces. `Spaces on` and `Spaces off` turns spacesindent mode
on and off for the current window. `Spaces ON` and `Spaces OFF`
turns spacesindent mode on and off for existing and future windows.

Additionally, this patch adds an `acme` command line option `-i` that
makes each window to start in spacesindent mode (like `Spaces ON`).

Sourced with minor changes from [mkhl](https://github.com/mkhl)'s
[acme/soft-tabs](https://github.com/mkhl/plan9port/tree/acme/soft-tabs)
branch of [Plan 9 Port](https://github.com/9fans/plan9port)
which ports spew's acme spaces indent mode from 9front.

### `plan9port-acme-windowtitle.patch`

Add an `acme` command line option `-t TITLE` that sets the window
title of the launched Acme instance to `TITLE`.

Sourced from [this](https://github.com/9fans/plan9port/pull/51)
unmerged pull request by [afh](https://github.com/afh).

### `plan9port-keyboard-addrunecomposeseq.patch`

Add new keyboard compose sequences for typing runes:

- `Alt-l-l` for the lozenge rune ◊

### `plan9port-bdf2subf.patch`

Add the `bdf2subf` program, for converting
BDF fonts to Plan 9 subf (see the `font(6)`
[manpage](https://plan9.io/magic/man2html/6/font)), to the plan9port
source tree. It will be compiled along with the other plan9port
programs when running the `INSTALL` script.

To convert a BDF font (replace `FONTNAME` as appropriate):

```sh
bdf2subf -f FONTNAME.bdf > FONTNAME.font
bdf2subf FONTNAME.bdf
```

This converts the character glyphs and creates the `.font` file
usable by Plan 9 programs.

Sourced from branch of plan9port by
[bleu255](https://post.lurk.org/@320x200/102532617791988449)
([code](https://git.bleu255.com/plan9port/commit/2b5318c96f51eda9e0d1078c337ca66b852cf597.html)
and [usage](https://git.bleu255.com/plan9port/file/font/terminus/README.html)),
and adapted to support BDF font files with characters whose `BBX`
parameters do not exactly match those of `FONTBOUNDINGBOX`.

**Notes**:

- Some BDF fonts have problematic characters whose bounding
  boxes are much larger than other characters and those
  should be modified before converting them. For example,
  [Cozette](https://github.com/slavfox/Cozette)'s BDF file for
  version `1.20.0` defines two characters at code points `u1F60A` and
  `u1F60E` that are 27 pixels tall while the all other characters are
  at most 13 pixels tall, so these two characters need to be modified
  (change their `BBX`  height from `27` to `11`, and remove the first
  16 rows of their bitmaps) and the overall `FONTBOUNDINGBOX` height
  changed from `27` to `13` (note that `u1F60E` was fixed upstream
  in version `1.23.0` and `u1F60A` was fixed in version `1.23.1`).

- Some BDF fonts have characters that have no encoding. These need
  to be removed before conversion using `bdf2subf`. For example,
  the [IBM3161](https://github.com/wyatt8740/IBM3161-font) BDF font
  file contains three characters at the end of the file that have
  `ENCODING -1` that should be removed (each font is defined in
  a block that starts with a `STARTCHAR` line and ends with an
  `ENDCHAR` line), and the `CHARS 57090` line should be changed to
  `CHARS 57087`.

- Some BDF fonts have empty chars with zero size bounding
  boxes like `BBX 0 0 ...`. The parser throws an error
  on these, so these characters need to be modified to
  have non-zero size bounding boxes. For example, the
  [Zpix](https://github.com/SolidZORO/zpix-pixel-font)
  font has several such characters with `BBX 0 0 0 0` bounding
  box definition where for each of those characters the line
  should be changed to `BBX 1 1 0 0` and a new line `00` added
  between the consecutive `BITMAP` and `ENDCHAR` lines.

- Some BDF fonts have empty lines and leading whitespace that need
  to be removed before converting them.  For example, the BDF font
  for [this](https://www.chiark.greenend.org.uk/~sgtatham/fonts/)
  modified Tektite font has both.

- Some BDF fonts have unsupported keywords that need to be removed
  prior to conversion. For example, fonts converted from other bitmap
  formats to BDF by [monobit](https://github.com/robhagemans/monobit)
  will have lines starting with keywords `SWIDTH1` and `DWIDTH1` that
  should be removed (one way is via the command line like running
  `cat FONT.bdf | grep -v -e '^[DS]WIDTH1 .*$' > NEWFONT.bdf`).

### `plan9port-mac-nofullscreenautohidemenu.patch`

Don't fully hide menubar and dock when fullscreen on macOS.

By default, devdraw is configured so it fully hides the menu bar and
dock when plan9port GUI program windows are full screen. This patch
reverts those changes so window behavior is per normal.

### `plan9port-mac-noquotemap.patch`

No remapping of backticks and single quotes on macOS systems.

This patch removes the default behavior of remapping characters
`` ` `` and `'` to `‘` and `’` in macOS `fontsrv`.

### `plan9port-x11-ctrlb1superb2.patch`

On X11, `Super-Click` (or `Windows-Click`) to send Button2, and press
Control and Super to send Button1 and Button2 respectively when mouse
button is depressed.

This allows for a 2-1 chord via `Super-Click` followed by pressing
`Control` on Linux/Unix laptops.

**NOTE**: `Super-Click` and `Shift-Click` detection code is modified
to look at the button state instead of tracked state, to work around
OSes like ChromeOS not passing through `Super` key press and release
events directly to the X server.
