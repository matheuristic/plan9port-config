# plan9port-config

[Plan 9 from User Space](https://9fans.github.io/plan9port/)
(plan9port, p9p) configuration

## About

This repository contains a configuration for Plan 9 from User Space,
which is a port of several [Plan 9](https://p9f.org/) tools to *nix
systems.

Most of this configuration will be built around
[Acme](http://acme.cat-v.org/) and [Sam](http://sam.cat-v.org/),
the two Plan 9 text editors.

The shell commands here are for a POSIX-compatible shell or similar
(e.g. Bash or ZSH).

## Installing plan9port and configuring it

### Compiling plan9port

The following instructions are for a system-level install at
`/usr/local/plan9` or a local install at `$HOME/packages/plan9port`.
Change the target directory as desired. See `install.txt` for what
compile-time dependencies need to be installed.

System install (for all users):

```shell
cd /usr/local
sudo git clone https://github.com/9fans/plan9port.git plan9
cd plan9
sudo ./INSTALL
```

Local install (for the current user, creating a new git branch is for
easier updating):

```shell
mkdir -p $HOME/packages
cd $HOME/packages
git clone https://github.com/9fans/plan9port.git
cd plan9port
git checkout -b $(date +%Y%m%d)
./INSTALL -b
./INSTALL -c -r $PWD
```

Follow the instructions to add the plan9port `bin` directory to the
user shell path, if desired. However, it can be better to avoid mixing
the GNU or BSD tooling with the Plan 9 tooling, so an alternative
would be to create a symlink to the `9` command for running the
plan9port commands. In that case, `ls` runs the regular version of
`ls` while `9 ls` runs the plan9port version.

I.e., suppose `$HOME/.local/bin` exists and is on the shell search
path, and plan9port is installed locally as above:

```shell
cd $HOME/.local/bin
ln -s $HOME/packages/plan9port/bin/9
```

### Setting up base configuration files

Use GNU `stow` from the repository root directory to symbolically link
the base configuration files and helper scripts to the corresponding
user config locations.

```shell
stow -t $HOME --no-folding acme
stow -t $HOME --no-folding rc
stow -t $HOME --no-folding sam
```

This will create the symlinks:

- `~/.local/bin/rc.sh`: Launcher for the Plan 9 shell `rc`, useful for
  when the plan9port binaries directory is not added to the search
  path by default.
- `~/.local/bin/acme.rc`: Launcher for Acme.
- `~/.local/bin/acmeautosave.rc`: Autosave script for modified windows in Acme.
- `~/.local/bin/sample-acme.sh`: Sample wrapper to run `acme.rc` via
  `rc.sh`.
- `~/.local/bin/sample-sam.sh`: Sample wrapper to run `sam` via
`rc.sh`. Copy contents to `~/.local/bin/sam.sh`, modify as needed.
- `~/.acme/bin/*`: Various helper scripts for Acme.

Create a directory utilized by the autosave script.

```shell
mkdir -p $HOME/.acme/autosave
```

Copy `sample-acme.sh` to `~/.local/bin/acme.sh` which can be modified
to create a customized launcher for Acme.

```shell
cp acme/.local/bin/sample-acme.sh $HOME/.local/bin/acme.sh
```

Edit `~/.local/bin/acme.sh` to customize the launcher as desired.

## Acme

[Acme](http://acme.cat-v.org/) is a mouse-centric Plan 9 editor. It
works best with a 3-button mouse, although keyboard modifiers can be
used to simulate secondary mouse buttons on systems without a 3-button
mouse (like laptops with touchpads).

### Acme fonts

The default main (variable) font is `$PLAN9/font/lucsans/euro.8.font`
and alternate (fixed) font is `$PLAN9/font/lucm/unicode.9.font`.

The following options can be specified when running the `acme` command
to change the main or alternate fonts:

- `-f /path/to/main/font` to set the main font.
- `-F /path/to/alt/font` to set the alternative font.

The font paths can either be mount points created via `fontsrv` (these
have a path `/mnt/font/<FONTNAME>/<SIZE>/font` where `<FONTNAME>` is a
font listed in `9p ls font` and `<SIZE>` is the size of the font with
an `a` suffix to use the anti-aliased version) or a file in the Plan 9
install. Example of running Acme with different fonts:

```shell
acme -f /mnt/font/GoRegular/16a/font -F /mnt/font/GoMono/16a/font
```

Fonts can also be changed for a given Acme window by running the
`Font` command in that window. Running `Font` by itself toggles
between the main and alternate fonts, and `Font /path/to/font` loads
the specified font.

### Saving and loading sessions

Use `Dump /path/to/dump/file` and `Load /path/to/dump/file` to save
and load sessions when in Acme. If a path is not provided, the dump
path defaults to `~/acme.dump`.

Acme can be launched with the `-l /path/to/dump/file` option to load a
specific session dump file on startup. Example

```shell
acme -l /path/to/project/acme.dump
```

### Autosaving

If `stow` was used to symlink the base configuration files, a script
to help with autosaving modified files that have yet to be written can
be found at `~/.local/bin/acmeautosave.rc`. This script is
automatically run by `~/.local/bin/acme.rc`, but only has effect if
the `~/.acme/autosave` directory exists (which it will if the
instructions above were followed).

Autosaved modified files are saved to `~/.acme/autosave/%NAMESPACE%/`
where `%NAMESPACE%` is the current namespace with slashes replaced by
percents. For example, when Acme and the autosave script run in
namespace `/tmp/ns.someuser.:0`, autosaves are written into the
`~/.acme/autosave/%tmp%ns.someuser.:0/` directory.

### Guide file

If `stow` was used to symlink the base configuration files, a master
guide file will be available at `~/.acme/guide` containing a number of
useful commands and examples.

### Helper scripts

If `stow` was used to symlink the base configuration files,
there are a number of helper scripts available at `~/.acme/bin`:

- `acmeed` ([source](https://moriendi.org/tools/acme/)): When used as
  a value for the `$EDITOR` environment variable, programs that
  utilize that environment variable will open a new window in Acme to
  edit files (run `Putdel` to confirm the write and delete the window,
  or run `Del` to cancel the edit).
- `alink` ([source](https://moriendi.org/tools/acme/)): `alink name
  cmd arg1 ...` creates a new window named `name` and executes `cmd`
  in it with the given args.
- `c+`: Comment. Specify an argument to change the comment prefix from
  the default `#`.
- `c-`: Uncomment, an arg may be specified as in `c+`.
- `condarun`: `condaenv=envname condarun cmd arg1 ...` executes `cmd`
  with the given args in the `envname` Conda environment (default
  environment is the one active when Acme was launched, else `base`).
- `dtw`: Delete trailing whitespace (spaces/tabs).
- `i+`: Indent. Specify an argument to change the
  indent string from the default Tab character.
- `i-`: Unindent. An arg may be specified as in `i+`.
- `lower`: Lowercase text selection.
- `rg+`: Wrapper for running
  [ripgrep](https://github.com/BurntSushi/ripgrep) with output that
  can be plumbed.
- `runfc`: `>runfc cmd arg1 ...` will copy the text selection to a
  temporary file, run a command `cmd` that modifies the temporary file
  in-place (like Python's `black` formatter) and output the temporary
  file to the Error window. Use `|` instead of `>` to replace the text
  selection with the result instead of outputting to the Error window.
- `s2t`: Replaces spaces with tabs, specify an argument to change the
  number of spaces to a tab from the default of `$tabwidth`.
- `Slide`: Start slideshow for current directory, where the slides are
  text files and slide sequence is given by an `index` file containing
  filenames of the text files (with no leading directories) with one
  filename per line and no empty lines.
- `Slide+`: Next slide, to be used with `Slide`.
- `Slide-`: Previous slide, to be used with `Slide`.
- `surround`: Add surrounding brackets, specify a left-side arg (e.g.
  `{` , `[` , `$` , `<` , and so on) to use a specific bracket pair
  other than the default round parentheses `(` and `)`.
- `t2s`: Replaces tabs with spaces. Specify an argument to change the
  number of spaces to a tab from the default of `$tabwidth`.
- `upper`: Uppercase text selection.
- `w+`: Wrap (format text so each line is under some width in chars),
  specify an arg for a width other than the default of `70`.
- `w-`: Unwrap (join text across multiple lines into one line).

### Optional tools

- [acme-lsp](https://github.com/fhs/acme-lsp): [Language Server
  Protocol](https://microsoft.github.io/language-server-protocol/)
  client.
- [adir](https://github.com/lewis-weinberger/adir) or
  [Xplor](https://git.sr.ht/~mkhl/xplor): Tree-style file explorer for
  Acme.

### Using POSIX-compatible shells like Bash and Zsh with win

Add the following snippet to the configuration of a POSIX-compatible
shell so `cd`-ing into a new directory in `win` (for running shells in
Acme) when using that shell updates the tag line with the new
directory. This is `$HOME/.bashrc` for Bash or `$HOME/.zshrc` for Zsh.
Can be adapted for shells that are not POSIX-compatible like `fish`.

```shell
# Update Acme window tag line with dir in which it's running
if [ "$winid" ]; then
    _acme_cd () {
        \cd "$@" && awd
    }
    alias cd=_acme_cd
fi
```

### FUSE

**TODO**: General overview of the experimental `-m` option to have
FUSE mount itself at the given mountpoint so other programs that don't
have or don't allow direct access to the shell (i.e. cannot call `9p`)
can interact with it. Seems buggy at the moment on macOS
([link](https://github.com/9fans/plan9port/issues/136)).

### Usage tips

- For each project to create a project-specific guide file and copy
  into it a subset of the more useful commands for the project from
  the master guide file along with adding other project-specific
  commands (like compile or testing scripts). Have the guide file open
  in an Acme window for running specific project commands or for
  copying useful commands to add to a buffer window's tag.
- Create project-specific dump files so it is easy to save and load
  work sessions. The corresponding `Dump` and `Load` commands (with
  the appropriate dump file path) can be added to that project's guide
  file or to the main Acme tag.
- To evaluate selections in REPLs running in win windows, Snarf
  (1-2-3 chord) the selection, then execute Send in the REPL window.

## Sam

Plan 9 also comes with another editor [Sam](http://sam.cat-v.org/)
that is the predecessor of Acme, but has the benefit of having a
client-server that can be better suited for remote file editing under
high network latency.

## Plumber

**TODO**: Plumber setup

## Fonts

plan9port comes with the Plan9 fonts, which are in the `$PLAN9/fonts`
directory.

Fonts from the host system can also be used via `fontsrv`, which makes
those fonts accessible in the Plan 9 format at a given mountpoint
(default `/mnt/font` in the Plan 9 filesystem). `fontsrv` should be
built by default. If not, it can be built by running `9 mk install` in
the `$PLAN9/src/cmd/fontsrv` directory.

When `fontsrv` is running, available host system fonts can by listing
the `font` "directory" in the Plan 9 filesystem.

```shell
fontsrv &
9p ls font
```

A font file provided via `fontsrv` has the path
`/mnt/font/FONTNAME/SIZE[a]/font` where `FONTNAME` is the name of the
font and `SIZE[a]` is the point size of the font with an `a` suffix
for the anti-aliased version. For example, the Plan 9 font presented
by `fontsrv` at the path `/mnt/font/Iosevka/20a/font` is the
[Iosevka](https://github.com/be5invis/Iosevka) font, Regular weight,
at point size 20 and anti-aliased.

Several programs, like Sam, use the `$font` variable to determine the
main font and `$lfont` to determine the alternate font to use.

Acme also supports specification of the main and alternate font when
running its binary from the command line via the `-f` (main font) and
`-F` (alternate font) flags, illustrated in an earlier section.

## Keyboard bindings

Despite the mouse-centricity of the Plan 9 system (so plan9port too),
it provides a few keyboard bindings applicable to most GUI programs.

- `Ctrl-a`: Start of line
- `Ctrl-e`: End of line
- `Ctrl-h`: Delete previous character
- `Ctrl-w`: Delete previous word
- `Ctrl-u`: Delete backwards to start of line

## macOS

Additional notes specific to macOS systems.

### macOS bindings

When the touchpad is depressed, `Ctrl` acts as Button1, `Option` acts
as Button2 and `Command` acts as Button3. Holding a modifier while
depressing the touchpad does the same.

- `Ctrl-Click`: Button1
- `Option-Click`: Button2
- `Command-Click`: Button3
- `Click-hold` then `Option`: 1-2 chord
- `Click-hold` then `Command`: 1-3 chord
- `Option-Click` then `Ctrl`: 2-1 chord
- `Option-Click` then `Command`: Do nothing
- `Command-Click` then `Option`: Do nothing

macOS has a few additional keybindings:

- `Command-c`: Copy/Snarf
- `Command-v`: Paste
- `Command-x`: Cut
- `Command-z`: Undo
- `Command-Shift-z`: Redo- `Fn-Left`: Viewport to start of buffer
- `Fn-Right`: Viewport to end of buffer

### macOS dock icons

#### macOS Acme launcher app

1. Install [Platypus.app](https://github.com/sveinbjornt/Platypus) for
   creating macOS apps from command-line programs.
2. Open Platypus.app and create an app for launching Acme with the settings:
   - **App Name**: Acme
   - **Script Type**: Shell, `/bin/sh`
   - **Script Path**: Path to some Acme launcher script (e.g.
     `sample-acme.sh` or a customized `acme.sh` created from it),
     needs to be a real file and not a symlink
   - **Interface**: None
   - **Checkbox Settings**:
     - `[ ]` Accept dropped items
     - `[ ]` Run with root privileges
     - `[*]` Run in background
     - `[ ]` Remain running after execution
   - **Icon**: Set to the `spaceglenda.icns` file in the `$PLAN9/mac/`
     directory
3. Move the generated application to the `/Applications` folder

### macOS tips

- See [here](https://www.bytelabs.org/posts/acme-lsp/) for an example
  of how to set up acme-lsp for Acme on macOS. One nice config part is
  using the hotkey daemon [skhd](https://github.com/koekeishiya/skhd)
  to create Acme-specific keyboard shortcuts to run acme-lsp commands.

## Unix notes

Additional notes specific to Unix systems.

### Unix bindings

When the touchpad is depressed, `Ctrl` acts as Button2, `Alt` acts
as Button3 and `Command` acts as Button3. Holding a modifier while
depressing the touchpad does the same. Note that 2-1 chords are not
possible in *nix system without a mouse.

- `Ctrl-Click`: Button2
- `Alt-Click`: Button3
- `Click-hold` then `Ctrl`: 1-2 chord
- `Click-hold` then `Alt`: 1-3 chord
- `Ctrl-Click` then `Alt`: Do nothing
- `Alt-Click` then `Ctrl`: Do nothing

Unix systems have two additional keybindings:

- `Super-Left`: Viewport to start of buffer
- `Super-Right`: Viewport to end of buffer

### Unix desktop icons

#### Acme freedesktop.org desktop entry specification

Assume that `stow` was used above to symlink scripts and config files.
Instructions here use the `~/.acme/bin/acme.sh` launcher script.

To create a menu item for Acme, create a scaled down version of
`mac/spaceglenda.png` in the plan9port repository (at resolution
240x240), save it to `~/.local/share/icons/spaceglenda240.png` and
create the [freedesktop.org](https://www.freedesktop.org/wiki/)
desktop entry specification file at
`~/.local/share/applications/acme.desktop` with the following
contents (replace `USERNAME` as appropriate).

```desktop
[Desktop Entry]
Name=Acme
Comment=A text editor that is the successor of sam
GenericName=Text Editor
Exec=/home/USERNAME/.local/bin/acme.sh %f
TryExec=/home/USERNAME/.local/bin/acme.sh
Icon=/home/USERNAME/.local/share/icons/spaceglenda240.png
Categories=Utility;Development;TextEditor;
Terminal=false
Type=Application
Version=1.0
```

Note that the above desktop entry specification file uses the Go fonts
at a fairly large font size, which is recommended when running on a
Linux machine with a HiDPI screen.
