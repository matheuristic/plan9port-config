# plan9port-config

[Plan 9 from User Space](https://9fans.github.io/plan9port/)
(plan9port, p9p) configuration

## About

This repository contains a configuration for Plan 9 from User Space,
which is a port of several [Plan 9](https://p9f.org/) tools to Unix
systems.

Most of this configuration will be built around
[Acme](http://acme.cat-v.org/) and [Sam](http://sam.cat-v.org/), the
two Plan 9 text editors.

The shell commands here are for a POSIX-compatible shell or similar
(e.g. Bash or Zsh).

## Installing plan9port and configuring it

### Code patches

There are some patches in the `patches` subdirectory. Apply desired
patches to the source code prior to compilation. See the `README.md`
file in the subdirectory for instructions.

- `plan9port-acme-soft-tabs.patch`: Adds soft tabs support to Acme
  toggleable via a `Spaces [on|off|ON|OFF]` command and an `-i` CLI
  option.
- `plan9port-mac-noquotemap.patch`: Remove the remapping of chars
  `` ` `` and `'` to `‘` and `’` in macOS `fontsrv`.
- `plan9port-x11-shiftpressbutton1.patch`: `Shift` sends Button1 while
  a mouse button is depressed on X11 systems. This allows for 2-1
  chords on non-macOS laptops without an external mouse.

### Compiling plan9port

The following instructions are for a system-level install at
`/usr/local/plan9` or a local install at `$HOME/packages/plan9port`.
Change the target directory as desired. See `install.txt` for what
compile-time dependencies need to be installed.

System install (for all users):

```sh
cd /usr/local
sudo git clone https://github.com/9fans/plan9port.git plan9
cd plan9
sudo ./INSTALL
```

Local install (for the current user, creating a new git branch is for
easier updating, and code patches should be applied after the
`git checkout` step):

```sh
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

```sh
cd $HOME/.local/bin
ln -s $HOME/packages/plan9port/bin/9
```

### Setting up base configuration files

Use GNU `stow` from the repository root directory to symbolically link
the base configuration files and helper scripts to the corresponding
user config locations.

```sh
stow -t $HOME --no-folding plan9port
```

This will create the symlinks:

- `~/lib/guide`: Basic guide file example.
- `~/lib/plumbing`: Plumbing file for controlling the behavior of
  `plumber`.
- `~/.local/bin/rc.sh`: Launcher for the Plan 9 shell `rc`, useful for
  when the plan9port binaries directory is not added to the search
  path by default. Assumes the plan9port install directory is
  `$HOME/packages/plan9port`, so copy this file and modify the
  necessary paths if plan9port is installed elsewhere.
- `~/.local/bin/startacme.rc`: Launcher for Acme.
- `~/.local/bin/acmeautosave.rc`: Autosave script for modified windows
  in Acme.
- `~/.local/bin/startsam.rc`: Launcher for Sam.
- `~/.local/bin/sample-startacme.sh`: Sample wrapper to run
  `startacme.rc` via `rc.sh`.
- `~/.local/bin/sample-startsam.sh`: Sample wrapper to run
  `startsam.rc` via `rc.sh`.
- `~/.acme/bin/*`: Various helper scripts for Acme.

Create directory used by the autosave script.

```sh
mkdir -p $HOME/.acme/autosave
```

Copy `sample-acmeed.sh` to `~/.local/bin/acmeed.sh` and
`sample-sam.sh` to `~/.local/bin/sam.sh` and modify them to create
customized launchers for Acme and Sam.

```sh
cp plan9port/.local/bin/sample-acmeed.sh $HOME/.local/bin/acmeed.sh
cp plan9port/.local/bin/sample.sam.sh $HOME/.local/bin/sam.sh
```

Edit `~/.local/bin/acmeed.sh` and `~/.local/bin/sam.sh` to customize
the launchers as desired.

## Acme

[Acme](http://acme.cat-v.org/) is a mouse-centric Plan 9 editor. It
works best with a 3-button mouse, although keyboard modifiers can be
used to simulate secondary mouse buttons on systems without a 3-button
mouse (like laptops with touchpads).

### Acme fonts

The default main font is `/lib/font/bit/lucsans/euro.8.font`
(corresponding to the file `$PLAN9/font/lucsans/euro.8.font`) and the
default alternate font is `/lib/font/bit/lucm/unicode.9.font`
(corresponding to the file `$PLAN9/font/lucm/unicode.9.font`). Many
users typically use a proportional-width main font and a fixed-width
alternate font.

The following options can be specified when running the `acme` command
to change the main or alternate fonts:

- `-f /path/to/main/font` to set the main font.
- `-F /path/to/alt/font` to set the alternative font.

Example of running Acme with different fonts:

```sh
acme -f /lib/font/bit/pelm/unicode.13.font -F /mnt/font/GoMono/18a/font
```

Fonts can also be changed for a given Acme window by executing the
`Font` command in that window. Executing `Font` by itself toggles
between the main and alternate fonts. Executing with a font presented
by Plan 9 as an argument as in `Font /path/to/presented/font` loads
the specified font.

See the _Fonts_ section for more information on Plan 9 fonts and how
they are presented as files in Plan 9 either normally (Plan 9 bitmap
fonts) with `fontsrv` (host system vector fonts).

### Saving and loading sessions

Use `Dump /path/to/dump/file` and `Load /path/to/dump/file` to save
and load sessions when in Acme. If a path is not provided, the dump
path defaults to `~/acme.dump`.

Acme can be launched with the `-l /path/to/dump/file` option to load a
specific session dump file on startup. Example:

```sh
acme -l /path/to/project/acme.dump
```

### Autosaving

If `stow` was used to symlink the base configuration files, a script
to help with autosaving modified files that have yet to be written can
be found at `~/.local/bin/acmeautosave.rc`. This script is
automatically run by `~/.local/bin/startacme.rc`, but only has effect
if the `~/.acme/autosave` directory exists (which it will if the
instructions above were followed).

Autosaved modified files are saved to `~/.acme/autosave/%NAMESPACE%/`
where `%NAMESPACE%` is the current namespace with slashes replaced by
percents. For example, when Acme and the autosave script run in
namespace `/tmp/ns.someuser.:0`, autosaves are written into the
`~/.acme/autosave/%tmp%ns.someuser.:0/` directory.

### Guide files

Guide files are text files that contain sample commands for invoking
commands. When appropriate, the proper command can be looked up from a
guide file, copied and/or edited as needed, and executed. It is common
practice to keep a guide file open in a smaller side column window so
commands that commonly used can be accessed readily.

If `stow` was used to symlink the base configuration files, a master
guide file will be available at `~/lib/guide` containing a wide array
of commands and examples.

### Useful bundled commands

plan9port comes with several useful commands for working with Acme
(and Sam):

- `B`: Opens file in a new window inside Acme (or Sam).
- `E`: Opens file in a new window inside Acme (or Sam), returning
  control to the calling process after editing is done. Can be used as
  `$EDITOR` so commands that use it to open an editor in a sub-process
  do so using Acme, e.g. `EDITOR=E git commit -a`. See
  [link](https://blog.silvela.org/post/2021-12-11-acme-tricks/) for
  examples. Or use the `acmeed` script (see next section).

### Helper scripts

If `stow` was used to symlink the base configuration files, there are
a number of helper scripts available at `~/.acme/bin`:

- `acmeed` ([source](https://moriendi.org/tools/acme/)): When used as
  a value for the `$EDITOR` environment variable, programs that
  utilize that environment variable will open a new window in Acme to
  edit files (run `Putdel` to confirm the write and delete the window,
  or run `Del` to cancel the edit).
- `alink` ([source](https://moriendi.org/tools/acme/)):
  `alink name cmd arg1 ...` creates a new window named `name` and
  executes `cmd` in it with the given args.
- `c+`: Comment. Specify an argument to change the comment prefix from
  the default `#`.
- `c-`: Uncomment. An argument may be specified as in `c+`.
- `ci`: Convert an alphanumeric string to a case-insensitive regexp.
- `condarun`: `condarun envname cmd arg1 ...` executes `cmd` with the
  given args in the `envname` Conda environment (default environment
  is the one active when Acme was launched, else `base`).
- `csp`: Wrapper for running
  [cspell](https://github.com/streetsidesoftware/cspell) installed
  using [npm](https://www.npmjs.com/) managed by
  [NVM](https://github.com/nvm-sh/nvm).
- `ct`: `ct COLUMNNUMBER COMMENTPREFIX` adds `COMMENTPREFIX` at
  `COLUMNNUMBER` in each line of STDIN or text piped to the command.
- `d`: Diff the current window against the current file on disk.
- `dtw`: Delete trailing whitespace (spaces/tabs).
- `esp`: Wrapper for [Enchant](https://github.com/AbiWord/enchant)
  except it only supports use with files and not STDIN or piped text.
- `ff`: Wrapper around [fzf](https://github.com/junegunn/fzf) for
  fuzzy finding files based on filename. Also requires
  [ripgrep](https://github.com/BurntSushi/ripgrep) be installed.
- `h`: `hcount=N h STRING` shows the last `N` commands in a win window
  that contain `STRING`. If `hcount=N` is omitted then the last 10
  matching commands are shown. If `STRING` is omitted, then the most
  recent commands are show (i.e., match all commands).
- `i+`: Indent. Specify an argument to change the indent string from
  the default Tab character.
- `i-`: Unindent. An arg may be specified as in `i+`.
- `lower`: Lowercase text selection.
- `lw`: List Acme windows (including window ID, whether the window is
  a directory window, and if the window is dirty). A fancier version
  of running the `Edit X` Sam command.
- `rg+`: Wrapper for running
  [ripgrep](https://github.com/BurntSushi/ripgrep) with output that
  can be plumbed. Note that for modified open files in Acme, the saved
  version of the file is searched.
- `rg-`: Wrapper for running
  [ripgrep](https://github.com/BurntSushi/ripgrep) on the current Acme
  window's contents with output that can be plumbed. Note that this
  will search the unsaved modified contents if the window is dirty
  (i.e., modifications made but not yet saved to file). Also requires
  [realpath](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html)
  be installed (it is used to derive relative file paths).
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
- `uline`: Underline text selection. Specify an argument to change the
  character for underlining from the default of '-'.
- `upper`: Uppercase text selection.
- `w+`: Wrap (format text so each line is under some width in chars),
  specify an arg for a width other than the default of `70`.
- `w-`: Unwrap (join text across multiple lines into one line).

### Optional tools

- [Go](https://golang.org/): Some tools below require Go to install or
  run. Installable via a package manager (e.g. APT or Homebrew or
  MacPorts), or download a binary release from the website.

- [acmego](https://pkg.go.dev/9fans.net/go/acme/acmego): When Go files
  are written, automatically makes adjustments in the window body to
  the import block as needed using `goimports` but does not write the
  file. Also supports autoformatting Rust files using `rustfmt`. An
  alternative that works on any Acme window using any given command is
  [acme-autoformat](https://github.com/droyo/acme-autoformat).

- [acme-lsp](https://github.com/fhs/acme-lsp):
  [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)
  client. See its website for how to configure it and use it with LSP
  servers. Install acme-lsp with:

  ```sh
  go install github.com/fhs/acme-lsp/cmd/acme-lsp@latest
  go install github.com/fhs/acme-lsp/cmd/L@latest
  ```

  Create helper scripts in `$HOME/.acme/bin/` by running in `rc`:

  ```sh
  for(cmd in comp def fmt hov impls refs rn sig syms type assist ws ws+ ws-){
    > $home/.acme/bin/L^$cmd {
      echo '#!/usr/bin/env rc'
      echo exec L $cmd '$*'
    }
    chmod +x L^$cmd
  }
  ```

  Config params can be saved in a [TOML](https://toml.io/) file
  `$HOME/Library/Application Support/acme-lsp/config.toml` for macOS
  or `$HOME/.config/acme-lsp/config.toml` for Unix or Linux. Example:

  ```toml
  # ~/.config/acme-lsp/config.toml - acme-lsp config

  [Servers]

  	[Servers.elixir-ls]
  	Command = ["/path/to/elixir-ls/language_server.sh"]
  	StderrFile = ""
  	LogFile = ""

  	[Servers.jedi-language-server]
  	Command = ["jedi-language-server"]
  	StderrFile = ""
  	LogFile = ""

  	[Servers.gopls]
  	Command = ["gopls", "serve", "-rpc.trace"]
  	StderrFile = "gopls.stderr.log"
  	LogFile = "gopls.log"
  		# These settings gets passed to gopls
  		[Servers.gopls.Options]
  		hoverKind = "FullDocumentation"

  [[FilenameHandlers]]
  Pattern = "\\.exs?$"
  ServerKey = "elixir-ls"

  [[FilenameHandlers]]
  Pattern = "\\.py$"
  ServerKey = "jedi-language-server"

  [[FilenameHandlers]]
  Pattern = "[/\\\\]go\\.mod$"
  LanguageID = "go.mod"
  ServerKey = "gopls"

  [[FilenameHandlers]]
  Pattern = "[/\\\\]go\\.sum$"
  LanguageID = "go.sum"
  ServerKey = "gopls"

  [[FilenameHandlers]]
  Pattern = "\\.go$"
  LanguageID = "go"
  ServerKey = "gopls"
  ```

  An alternative is [acre](https://github.com/mjibson/acre).

- [dirtree](https://github.com/sminez/acme-corp/tree/master/dirtree):
  Tree-style file explorer for Acme. Button2 on a directory in a
  dirtree window will set that directory as the new tree root. Button3
  on a directory will toggle listing of its contents, and on a file
  will plumb it as usual. Install `dirtree` with:

  ```sh
  go install github.com/sminez/acme-corp/dirtree@latest
  ```

  Alternatives include
  [adir](https://github.com/lewis-weinberger/adir) which can be
  installed, assuming `$PLAN9` and `mk` are on the system path, with:

  ```sh
  git clone https://github.com/lewis-weinberger/adir.git
  cd adir
  mk install BIN=$home/.acme/bin
  ```

  (No need to specify `BIN=$home/.acme/bin` if installing to
  `$PLAN9/bin`.)

  Other alternatives include [xplor](https://git.sr.ht/~mkhl/xplor) or
  its Go [port](https://github.com/mpl/xplor).

- [I](https://github.com/hherman1/I): Make CLI tools interactive in
  Acme. Running `I <cli>` to execute the command in a new window,
  where Button2 on window text will append the clicked text as a new
  arg and rerun the command, Button2 on Back will remove the newest
  arg and rerun, and Get will rerun the command as is.

- [Nyne](https://github.com/dnjp/nyne): Tools for Acme, including
  `nynetab` which expands tabs and indents text (best used with a
  hotkey daemon like [skhd](https://github.com/koekeishiya/skhd) or
  [sxhkd](https://github.com/baskerville/sxhkd)), and `md` for working
  with Markdown text and files.

- [punt](https://github.com/sminez/acme-corp/tree/master/punt): Send
  window contents to a external program from Acme (e.g., to make edits
  in another editor or to view HTML in a browser) and sync changes
  back to Acme window after external program is closed. Install with:

  ```sh
  go install github.com/sminez/acme-corp/punt@latest
  ```

  Usage example: `punt -e xterm nvim` or `punt -g emacsclient` from
  the tag of the window to punt to the external program. The `-e`
  option indicates the external program is to be run in the specified
  terminal emulator, while the `-g` option indicates the external
  program is a GUI one.

- [Watch](https://pkg.go.dev/9fans.net/go/acme/Watch): Runs a given
  command each time any file in the current directory is written and
  send the output to an Acme window whose name is the current
  directory with a `/+watch` suffix. Executing `Del` in this new
  window will close the window and end the Watch process. It also
  provides `Kill` and `Quit` commands that can be used with the
  command run by Watch (the command is echoed in the first line of the
  new window) to stop any Watch commands that stall. Watch is using
  for automatically linting or running tests when files are written.
  Install Watch with:

  ```sh
  go install 9fans.net/go/acme/Watch@latest
  ```

  To have Watch run a command when a file in the directory of an Acme
  window, execute `Watch [-r] cmd arg1 ...` in the window (if the `-r`
  flag is not specified, only the current directory is watched; if the
  `-r` flag is specified then Watch is run recursively, i.e. all
  subdirectories are also watched).

### Using POSIX-compatible shells like Bash and Zsh with win

- Add the following snippet to the configuration of a POSIX-compatible
  shell so `cd`-ing into a new directory in `win` (for running shells in
  Acme) when using that shell updates the tag line with the new
  directory. This is `$HOME/.bashrc` for Bash or `$HOME/.zshrc` for Zsh.
  Can be adapted for shells that are not POSIX-compatible like `fish`.

  ```sh
  # Update Acme window tag line with dir in which it's running
  if [ "$winid" ]; then
    _acme_cd () {
      builtin cd "$@" && awd
    }
    alias cd=_acme_cd
  fi
  ```

- Additionally, for better integration with `win` windows make sure
  to handle dumb terminals (`TERM=dumb`) appropriately (e.g. don't use
  any color escape codes). For instance, in Zsh the following can be
  added to the `$HOME/.zshrc` file.

  ```sh
  # No fancy Zsh prompt when using dumb terminals
  if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    if whence -w precmd >/dev/null; then
      unfunction precmd
    fi
    if whence -w preexec >/dev/null; then
      unfunction preexec
    fi
    PROMPT="%# "
    RPROMPT=""
  fi
  ```

- To have Acme `win` windows use a specific shell by default, start
  Acme with the `SHELL` environment variable appropriately set. For
  example, `visibleclicks=1 SHELL=zsh startacme.rc` starts Acme using
  the startup script in this repo with visible button clicks and Zsh
  as the default shell.

### FUSE

Acme can be called with the `-m` option to have Acme use FUSE to mount
itself at a given mountpoint. This allows other programs that don't
have or don't allow direct shell access (i.e. cannot call `9p`) to
interact with Acme. Example:

```sh
acme -m /path/to/mtpt
```

Note that on macOS, mounting Acme at most locations can lead to random
spawning of empty windows. This is because `fseventsd` will scan
mounted filesystems periodically, and in this case it reads e.g.
`/mnt/acme/new/ctl` which spawns a new window. To avoid this, the Acme
filesystem has to be mounted outside of `/User` with `MNT_DONTBROWSE`
set on it. Mounting Acme at a directory in `/tmp` satisfies this, so
mounting Acme on macOS should be done with this in mind. For example:

```sh
acme -m /tmp/acme
```

For more information on Acme mounting and macOS, see the following
[Github issue](https://github.com/9fans/plan9port/issues/136).

### Usage tips

- Middle-clicking (Button2) executes the region or word under the
  point. Right-clicking (Button3) will plumb the region or word under
  the point, or search (equivalent to Look) for the next occurrence if
  not plumbable.

  - Right-click on `:+/[Ff]oo/` to search forward for `foo` or `Foo`.

  - Right-click on `:-/[Ff]oo/` to search backward for `foo` or `Foo`.

  - Right-click on `:42` to jump to line 42.

  - Right-click on `file:somefile` to open `somefile` in a browser.

- The window scrollbars are used in conjunction with the mouse for
  moving the viewport across the buffer.

  - Left-clicking (Button1) and right-clicking (Button3) on the
    scrollbar moves the viewport up and down respectively where the
    clicks near the top of scrollbar move the viewport less and clicks
    near the bottom of the scrollbar move the viewport more.
    Specifically, when Button1 or Button3 is clicked on the scrollbar
    the number of lines the viewport is shifted is the number of lines
    from the top of the viewport to the line next to where the
    scrollbar was clicked. This has the effect that right-clicking the
    scrollbar next to a line will move the viewport so that line is at
    the top.

  - Middle-clicks (Button2) on the scrollbar will move the viewport so
    that the view indicator is at the position scrollbar was clicked,
    which allows for directly jumping to a window position.

- Wrap a command with brackets or parentheses to make it selectable by
  double-clicking (Button1 twice) just to the right of the left
  parenthesis. Useful for easy selection of commands containing
  spaces. For example:

  ```text
  [Load /path/to/project.dump]
  ```

- A separate window can be useful for writing and maintaining a
  history of commands. A handy use of this separate window is to write
  commands to be run with Edit, and execute them by highlighting the
  commands followed by a 2-1 chord on Edit in a target window's tag
  (note that Edit is not added to window tags by default). For
  example, write `,|s/abc/xyz/g` in a side window, highlight it and
  use a 2-1 chord on Edit in the target window's tag in order to
  replace all instances of `abc` with `xyz`.

- A start file or a bookmarks file with pre-defined Load lines or
  paths to specific files can enable quick loading of project
  workspace dumps. The `sample-acmeed.sh` sample launcher has comments
  showing how a launcher can be set up to open this file on launch
  when no extra options are provided. An example of a start/bookmarks
  file follows.

  ```text
  # ~/.acme/start - Acme start file

  # Project workspaces

  [Load /path/to/project1.dump]
  [Load /path/to/project2.dump]

  # Bookmarks

  /path/to/guide
  /path/to/folder1/
  /path/to/folder2/
  /path/to/file1
  /path/to/file2
  ```

- For each project to create a project-specific guide file and copy
  into it a subset of the more useful commands for the project from
  the master guide file along with adding other project-specific
  commands (like compile or testing scripts). Have the guide file open
  in an Acme window for running specific project commands or for
  copying useful commands to add to a buffer window's tag.

- Create project-specific dump files so it is easy to save and load
  work sessions. The corresponding `Dump` and `Load` commands (with
  the appropriate dump file path) can be added to that project's guide
  file or to the main Acme tag. It is recommended to store dump files
  either in the project directory or in a separate directory like
  `~/.acme/dump/` that consolidates dump files across projects. When
  working with Git-controlled projects, the latter is better as it
  avoids polluting the Git repository with machine-local data.

- To evaluate selection in a REPL running in some win window, Snarf
  (1-2-3 chord) the selection, then execute Send in the REPL window.

- Alternative command-line launchers for Acme (e.g. ones that use
  specific fonts or loads a given dump file) can be created as
  aliases, e.g. for Bash

  ```sh
  alias aproj='visibleclicks=1 $HOME/.local/bin/rc.sh $HOME/.local/bin/startacme.rc -f /mnt/font/GoRegular/15a/font -F /mnt/font/GoMono/15a/font -l /path/to/proj/acme.dump'
  ```

  or for rc

  ```sh
  fn aproj { visibleclicks=1 $home/.local/bin/startacme.rc -f /mnt/font/GoRegular/15a/font -F /mnt/font/GoMono/15a/font -l /path/to/proj/acme.dump }
  ```

- Window management can get chaotic when there are many open. Listing
  and finding windows can be done with the `Edit X` Sam command or
  `$HOME/.acme/bin/lw` (or the [original](https://github.com/mpl/lw)
  upon which it is based) and plumbing with Button3 (right-click).
  Managing windows can be done by executing `Sort` to sort the windows
  in a column by their tags.

- There is no shift-click semantics in Acme (click on a position A,
  then shift-click on another position B to selection the region from
  A to B). As a workaround:

  1. Run `Edit =` at a file location to print the file's name and
     cursor line number in a `+Errors` window. If desired, add a
     forward search query `/REGEXP/` to the end. This sets the region
     start location.

  1. Click on a later position in the file.

  1. In the `+Errors` window, append `,.` to the end of the file and
     line location (plus forward search query, if applicable).

  1. Button3 (right-click) on the resulting line in the `+Errors`
     window to plumb it, which will select the file region specified.

  The final line in the `+Errors` window to be plumbed will look
  something like `/path/to/file:10,.` or `/path/to/file:10/text/,.`
  (corresponding to `FILEPATH:STARTLOCATION,ENDLOCATION` where `.` is
  the cursor location).

## Sam

Plan 9 also comes with another editor [Sam](http://sam.cat-v.org/)
that is the predecessor of Acme, but has the benefit of having a
client-server that can be better suited for remote file editing under
high network latency.

## Plumber

Plan 9 and plan9port has a message passing mechanism called plumbing,
and `plumber` processes plumbed messages and does dispatching. For
example, it is what enables Button3 (right-click) presses on compile
errors in Acme to jump to the corresponding file and line.

Plumbing rules should be specified in `$HOME/lib/plumbing`. If it does
not exist, then the default plumbing rules are loaded from
`$PLAN9/plumb/initial.plumbing`. An example `plumbing` file is show
below, and it defines a plumbing rule for navigating to file locations
in Python errors and also loads the default rules.

```text
# to update: cat $HOME/lib/plumbing | 9p write plumb/rules

editor = acme

# python errors
type is text
data matches ' *File "([a-zA-Z¡-￿0-9_\-./]+)", line ([0-9]+).*'
arg isfile $1
data set $file
attr add addr=$2
plumb to edit
plumb client $editor

# include basic plumbing rules
include basic
```

See `9 man 7 plumb` for more information about plumbing rules.

`plumber` is not started by default in plan9port applications, so it
has to be started in a launch script or manually. The rc command below
starts `plumber` if it is not running in the current namespace.

```sh
9p stat plumb >[2]/dev/null >[1=2] || 9 plumber
```

See `9 man 4 plumber` for more information about `plumber`.

Plumbing rules can be updated without restarting `plumber` via a Plan
9 mount point (change `/path/to/plumbing` below as appropriate, e.g.
`$home/lib/plumbing` to reload user-specific rules after an update).

```sh
cat /path/to/plumbing | 9p write plumb/rules
```

References:

- [Plan 9 Wiki](https://9p.io/wiki/plan9/plumbing_examples/index.html)
- [Just as Mario: Using the Plan9 plumber utility](https://mostlymaths.net/2013/04/just-as-mario-using-plan9-plumber.html/)
- [Better plumbing in Xorg with plan9port’s plumber](https://dataswamp.org/~lich/musings/plumbing.html)
- [Plan 9 Desktop Guide > Basics > Plumbing](https://pspodcasting.net/dan/blog/2019/plan9_desktop.html#plumbing)

## Fonts

plan9port comes with the Plan9 bitmap fonts, which are in the
`$PLAN9/font` directory. For backwards-compatibility with Plan 9
scripts, plan9port automatically translates paths beginning with
`/lib/font/bit` to paths `$PLAN9/font`. Font paths typically follow
the convention `$PLAN9/font/NAME/RANGE.SIZE.font` or
`/lib/font/bit/NAME/RANGE.SIZE.font` where `NAME` is some name for the
font, `RANGE` gives an indication of the available characters and
`SIZE` is the approximate height of the font in pixels. For example,
`$PLAN9/font/lucsans/unicode.10.font` or
`/lib/font/bit/lucsans/unicode.10.font` is the `lucsans` font for the
Unicode character set at a size of around 10 pixels high. Generally,
either the real filesystem path or backwards-compatible Plan 9 path
can be used to specify a Plan 9 bitmap font. See `9 man font` for more
information.

Fonts from the host system can also be used via `fontsrv`, which makes
those fonts accessible in the Plan 9 format at a given mountpoint
(default `/mnt/font` in the Plan 9 filesystem). `fontsrv` should be
built by default. If not, it can be built by running `9 mk install` in
the `$PLAN9/src/cmd/fontsrv` directory.

When `fontsrv` is running, available host system fonts can by listing
the `font` "directory" in the Plan 9 filesystem.

```sh
fontsrv &
9p ls font
```

`fontsrv` presents fonts at paths `/mnt/font/FONTNAME/SIZE[a]/font`
where `FONTNAME` is the name of the font, `SIZE` is the point size of
the font, and where the font is anti-aliased if `SIZE` is suffixed
with an `a` or non-anti-aliased if it is not. For example, the font
presented by `fontsrv` at path `/mnt/font/Iosevka/20a/font` is
[Iosevka](https://github.com/be5invis/Iosevka) font, Regular weight,
at point size 20 and anti-aliased. See `9 man fontsrv` for more info.

Several programs, like Sam, use the `$font` variable to determine
which font to use.

Acme also supports specification of the main and alternate font when
running its binary from the command line via the `-f` (main font) and
`-F` (alternate font) flags, illustrated in an earlier section.

Fonts can also be specified in ways that extend the standard behavior:

- If the specified font has format `SCALE*FONT` where `SCALE` is some
  integer, `FONT` is used scaled by pixel repetition. This can be
  helpful for high DPI Linux systems where fonts are not automatically
  scaled (unliked in macOS, where they are). Example:

  ```sh
  acme -f 2*/lib/font/bit/lucsans/unicode.8.font
  ```

- If the specified font has the format FONT1,FONT2 then FONT1 is used
  on low DPI screens and FONT2 is used on high DPI screens. This is
  useful in multi-screen environments where some screens are high DPI
  while other screens are low DPI. Example:

  ```sh
  acme -f /lib/font/bit/lucsans/unicode.8.font,/mnt/font/GoRegular/15a/font
  ```

On slower machines, using vector fonts can be slow when rendering many
unicode characters outside the basic plane on screen. As a workaround,
see the `fontscripts` folder for scripts that leverage `fontsrv` to
convert vector fonts to Plan 9 subf format.

## Keyboard bindings

Despite the mouse-centricity of the Plan 9 system (so plan9port too),
it provides a few keyboard bindings applicable to most GUI programs.

- `Ctrl-a`: Start of line
- `Ctrl-e`: End of line
- `Ctrl-h`: Delete previous character
- `Ctrl-w`: Delete previous word
- `Ctrl-u`: Delete backwards to start of line
- `Ctrl-f`: Complete filename or pop up options in a `+Error` window
  (and warp the pointer to that window if it is newly created)
- `ESC`: Selects text typed since last mouse action in Sam and Acme
  if nothing is selected, or deletes selected text otherwise; quick
  undoing of recent text input can be done with `ESC-ESC`

Runes can be entered using the compose key (`Alt` on PCs and `Option`
on Macs) followed by a key sequence. This provides a way to type
special characters on keyboards without those keys. Examples assuming
compose key is `Alt`.

- `Alt-'-`_(char)_ for a character with acute accent, e.g. `Alt-'-a`
  for á
- `` Alt-`- ``_(char)_ for a character with grave accent, e.g.
  `` Alt-`-a `` for à
- `Alt-^-`_(char)_ for a character with circumflex, e.g. `Alt-^-a` for
  â
- `Alt-"-`_(char)_ for a character with umlaut, e.g. `Alt-"-a` for ä
- `Alt-,-`_(char)_ for a character with cedilla, e.g. `Alt-,-c` for ç
- `Alt-*-`_(char)_ for Greek letters, e.g. `Alt-*-a` for α
- `Alt-`_(num)_`-`_(num)_ for fractions, e.g. `Alt-1-2` for ½
- `Alt-<-=` and `Alt->-=` for ≤ and ≥
- `Alt-<--` and `Alt--->` for ← and →
- `Alt-u-a` and `Alt-d-a` for ↑ and ↓
- `Alt-X-`_(hex)_`-`_(hex)_`-`_(hex)_`-`_(hex)_ for a unicode
  character with the given four hexadecimal digit code point, e.g.
  `Alt-X-2-5-C-A` for the LOZENGE character ◊ (hex code point 25CA);
  use `Alt-X-X-` for five hexadecimal digits and `Alt-X-X-X-` for six
  hexadecimal digits

See `lib/keyboard` in the plan9port source for key sequences, or the
[KEYBOARD(7)](https://9fans.github.io/plan9port/man/man7/keyboard.html)
man page (`man 7 keyboard`) for more info.

Also, note that up and down in Plan 9 programs like Acme and Sam
scroll the window viewport instead of moving the cursor.

## macOS

Additional notes specific to macOS systems.

### macOS bindings

When the touchpad is depressed, `Ctrl` acts as Button1, `Option` acts
as Button2 and `Command` acts as Button3. Holding a modifier while
depressing the touchpad does the same.

- `Ctrl-Click`: Button1
- `Option-Click`: Button2
- `Command-Click`: Button3
- `Click-hold` then `Option`: 1-2 chord (Acme)
- `Click-hold` then `Command`: 1-3 chord (Acme)
- `Option-Click-hold` then `Ctrl`: 2-1 chord (Acme)
- `Option-Click-hold` then `Command`: Do nothing (Acme)
- `Command-Click-hold` then `Option`: Do nothing (Acme)
- `Command-Click-hold` then `Ctrl`: Do nothing (Acme)

On macOS, there are also additional keybindings:

- `Command-c`: Copy/Snarf
- `Command-v`: Paste
- `Command-x`: Cut
- `Command-z`: Undo (Acme)
- `Command-Shift-z`: Redo (Acme)
- `Command-r`: Toggle between low DPI and high DPI screen rendering

### macOS dock icons

#### macOS Acme launcher app

1. Install [Platypus.app](https://github.com/sveinbjornt/Platypus) for
   creating macOS apps from command-line programs.
1. Open Platypus.app and configure an app for launching Acme with the
   following settings:
   - **App Name**: Acme
   - **Script Type**: Shell, `/bin/sh`
   - **Script Path**: Path to some Acme launcher script (e.g.
     `sample-acmeed.sh` or a customized `acmeed.sh` created from it),
     which needs to be a real file and not a symlink
   - **Interface**: None
   - **Checkbox Settings**:
     - `[ ]` Accept dropped items
     - `[ ]` Run with root privileges
     - `[*]` Run in background
     - `[ ]` Remain running after execution
   - **Icon**: Set to the `spaceglenda.icns` file in the `$PLAN9/mac/`
     directory
1. Click _Create App_ to bring up a save to file dialog, make sure
   that "Create symlink to script and bundled files" is unchecked,
   select the destination folder, modify the application name as
   needed, and click _Create_ to create the application
1. Move the generated application to the `/Applications` folder
1. Drag the application from the `/Applications` folder to the dock to
   keep it in the dock (this is a launcher app, different from the
   launched app which is a `drawterm` app running Acme)

### macOS tips

- See [here](https://www.bytelabs.org/posts/acme-lsp/) for an example
  of how to set up acme-lsp for Acme on macOS. One nice config part is
  using the hotkey daemon [skhd](https://github.com/koekeishiya/skhd)
  to create Acme-specific keyboard shortcuts to run acme-lsp commands.

- Any required font scaling is detected from window properties
  (specifically from the value of
  [backingScaleFactor](https://developer.apple.com/documentation/appkit/nswindow/1419459-backingscalefactor))
  so high-density (e.g. Retina) screens are handled automatically in
  macOS. Bitmap fonts are scaled by pixel-doubling so they can get
  jaggy. Therefore, it can be better to use vector fonts presented
  using `fontsrv` as those are instead scaled by doubling font size.

## Unix

Additional notes specific to Unix systems.

### Unix bindings

When the touchpad is depressed, `Ctrl` acts as Button2, `Alt` acts as
Button3 and `Command` acts as Button3. Holding a modifier while
depressing the touchpad does the same. Note that 2-1 chords are not
possible in Unix system without a mouse.

- `Ctrl-Click`: Button2
- `Alt-Click`: Button3
- `Click-hold` then `Ctrl`: 1-2 chord (Acme)
- `Click-hold` then `Alt`: 1-3 chord (Acme)
- `Ctrl-Click-hold` then `Alt`: Do nothing (Acme)
- `Alt-Click-hold` then `Ctrl`: Do nothing (Acme)

### Unix desktop icons

#### Acme freedesktop.org desktop entry specification

Assume that `stow` was used above to symlink scripts and config files.
Instructions here use the `~/.acme/bin/acmeed.sh` launcher script.

To create a menu item for Acme, create a scaled down version of
`mac/spaceglenda.png` in the plan9port repository (at resolution
240x240), save it to `~/.local/share/icons/spaceglenda240.png` and
create the [freedesktop.org](https://www.freedesktop.org/wiki/)
desktop entry specification file at
`~/.local/share/applications/acme.desktop` with the following contents
(replace `USERNAME` as appropriate).

```desktop
[Desktop Entry]
Name=Acme
Comment=A text editor that is the successor of sam
GenericName=Text Editor
Exec=/home/USERNAME/.local/bin/acmeed.sh %f
TryExec=/home/USERNAME/.local/bin/acmeed.sh
Icon=/home/USERNAME/.local/share/icons/spaceglenda240.png
Categories=Utility;Development;TextEditor;
Terminal=false
Type=Application
Version=1.0
```

## Other files in this repository

- `sam-examples.txt`: Examples of Sam commands, most of which can also
  be used in Acme with the `Edit` command.

- `unicode-chars.txt`: Useful Unicode characters.

## Ports of Plan 9 tools to other languages

- [Acme Go port](https://github.com/9fans/go/tree/main/cmd/acme)

- [Edwood](https://github.com/rjkroege/edwood) (another Acme Go port)

- [Sam Go port](https://github.com/9fans/go/tree/main/cmd/sam)

- [Yacco](https://github.com/aarzilli/yacco)

## Other Plan 9-related tools

- [ghfs](https://github.com/sirnewton01/ghfs): 9p Github file server.
  To use it after installing, run ghfs, mount the filesystem with
  `9 mount localhost:5640 /path/to/mountpoint` (replace port number
  with set ghfs port, and modify the the mountpoint path as needed).

- [muscle](https://github.com/nicolagi/muscle): 9p file server with
  revision history and merge, with S3 as the write-once-read-many
  (WORM) device. Install with:

  ```sh
  go install github.com/nicolagi/muscle/cmd/...
  ```

  Create an initial config using `muscle init` and customize.

  After starting `musclefs` and `snapshotfs`, mount using something
  akin to the following (replicated from the source repo), modifying
  as needed (e.g. `youruser` or the paths).

  ```sh
  sudo mount 127.0.0.1 /mnt/muscle -t 9p -o 'trans=tcp,port=2323,dfltuid=1000,dfltgid=1000,uname=youruser'
  sudo mount `{namespace}^/muscle /mnt/muscle -t 9p -o 'trans=unix,dfltuid=1000,dfltgid=1000,uname=youruser'
  9pfuse 127.0.0.1:2323 /mnt/muscle
  9pfuse `{namespace}^/muscle /mnt/muscle
  ```

  On Linux, an alternative to using `9pfuse` is
  [v9fs](https://www.kernel.org/doc/html/latest/filesystems/9p.html)
  which is built into the Linux kernel.

  Similar to [Upspin](https://upspin.io/) but without the need to
  maintain an always-connected running server.

- [telegramfs](https://github.com/nicolagi/telegramfs): 9p Telegram
  file server.

## Other useful links

- [Acme Tricks](https://blog.silvela.org/post/2021-12-11-acme-tricks/)

- [Plan 9 Wiki Tip o' the day](https://9p.io/wiki/plan9/Tip_o'_the_day/index.html)

- [plan9port linux environment](https://github.com/gdiazlo/p9penv)

- [Using the Plan 9 Plumber to Turn Acme into a Git GUI](https://alexkarle.com/blog/plan9-acme-git-gui.html)

- [When You Have Reached Acme](https://mkhl.codeberg.page/acme-setup/)
