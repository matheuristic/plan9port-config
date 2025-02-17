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

- `plan9port-acme-bindings.patch`: Adds `C-k`, `C-n`, `C-p`, `Cmd-a`
  and `Cmd-s` Acme key bindings for their usual Linux and macOS
  actions, and `Cmd-m`, `Cmd-.` and `Cmd-/` bindings to execute text
  (like Button2), backward-search/plumb text (like Shift-Button3) and
  forward-search/plumb text (like Button3) respectively.
- `plan9port-acme-extrafilechars.patch`: Allow round and square
  brackets and tildes in file and directory names in Acme.
- `plan9port-acme-soft-tabs.patch`: Adds soft tabs support to Acme
  toggleable via a `Spaces [on|off|ON|OFF]` command and an `-i` CLI
  option.
- `plan9port-acme-windowtitle.patch`: Adds a `-t TITLE` CLI option
  for setting the window title of a launched Acme instance.
- `plan9port-bdf2subf.patch`: Adds `bdf2subf` to the plan9port source
  tree that will be compiled when running the `INSTALL` script.
- `plan9port-keyboard-addrunecomposeseq.patch`: Adds new keyboard
  compose sequences for typing runes. See `patches/README.md`.
- `plan9port-mac-nofullscreenautohidemenu.patch`: Reverts changes to
  GUI window fully hide menubar when fullscreen behavior.
- `plan9port-mac-noquotemap.patch`: Remove the remapping of chars
  `` ` `` and `'` to `‘` and `’` in macOS `fontsrv`.

### Compiling plan9port

The following instructions are for a system-level install at
`/usr/local/plan9` or a local install at `$HOME/.local/plan9`.
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
mkdir -p $HOME/.local
cd $HOME/.local
git clone https://github.com/9fans/plan9port.git plan9
cd plan9
git checkout -b "build-$(date +%Y%m%d)"
./INSTALL -b
./INSTALL -c
```

Follow the instructions to set `$PLAN9` and add `$PLAN9/bin` to
`$PATH` for the user shell. Note that for Bash, if the plan9port
install location is `/path/to/plan9port`, adding the suggested

```sh
PLAN9=/path/to/plan9port export PLAN9
PATH=$PATH:$PLAN9/bin export PATH
```

to the profile (`~/.bashrc` or `~/.profile`) works, but for Zsh

```sh
export PLAN9=/path/to/plan9port
export PATH=$PATH:$PLAN9/bin
```

should be added instead (to `~/.zshrc` or `~/.zprofile`).

### Setting up base configuration files

Use GNU `stow` from the repository root directory to symbolically link
the base configuration files and helper scripts to the corresponding
user config locations.

```sh
stow -t $HOME --dotfiles --no-folding stow
```

This will create the symlinks:

- `~/lib/guide`: Basic guide file example.
- `~/lib/plumbing`: Plumbing file for controlling the behavior of
  `plumber`.
- `~/.local/bin/acmeactivens.sh`: Outputs the namespaces
  `/tmp/ns.$USER/*` for which there is a running instance of Acme.
- `~/.local/bin/startacme.rc`: Launcher for Acme.
- `~/.local/bin/startsam.rc`: Launcher for Sam.
- `~/.local/bin/sample-pylsp`: Sample wrapper showing how to run
  [Python LSP Server](https://github.com/python-lsp/python-lsp-server)
  installed in a Conda environment. Of utility when using `acme-lsp`.
- `~/.local/bin/startacme.sh`: Wrapper to run `startacme.rc` via `rc`.
- `~/.local/bin/startsam.sh`: Wrapper to run `startsam.rc` via `rc`.
- `~/.acme/bin/*`: Various helper scripts for Acme.

If additional launcher customization is needed, copy `startacme.sh` to
`~/.local/bin/startacme.sh` (or similarly for `startsam.sh`) instead
of symlinking, and modify the copy as desired.

## Acme

[Acme](http://acme.cat-v.org/) is a mouse-centric Plan 9 editor. It
works best with a 3-button mouse, although keyboard modifiers can be
used to simulate secondary mouse buttons on systems without a 3-button
mouse (like laptops with touchpads).

See `9 man 1 acme` for information about the Acme graphical user
interface, `9 man 4 acme` for information about interacting with Acme
using its file interface (useful for writing scripts that integrate
with Acme), and `9 man 1 sam` for information about the Sam command
language which is supported within Acme through its `Edit` command.

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
be found at `~/.acme/bin/Asave`. This script is designed to be run
from within Acme so that it will automatically exit when Acme exits.

Autosaved modified files are stored in `~/.acme/autosave/` by default,
with their filenames as the full path after replacing `/` with `%`,
` ` (spaces) with `+`, and `	` (tabs) with `=`. Once a file is saved
and therefore clean, its autosaved version will be autoremoved.

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
  examples.

### Helper scripts

If `stow` was used to symlink the base configuration files, there are
a number of helper scripts available at `~/.acme/bin`:

- `acmeexec`: Execute (Button2) some text in specified Acme window
  number (defaults to number of current Acme window).
- `alink` ([source](https://moriendi.org/tools/acme/)):
  `alink name cmd arg1 ...` creates a new window named `name` and
  executes `cmd` in it with the given args.
- `Asave`: Saves modified (i.e. unsaved) files in the running Acme
  instance to an autosave directory intermittently. See the subsection
  _Autosaving_ above.
- `Arecentf`: Prints the most recently opened files logged to
  `$HOME/.acme/recentf` by `Atrackf`, up to a specified number
  (defaults to 20 if not specified), from least recent to most recent.
- `Atrackf`: Monitors the Acme log, and append the name of each file
  as it is opened to `$HOME/.acme/recentf` or specified file. If using,
  it is best to run at the start of each Acme session.
- `c+`: Comment. Specify an argument to change the comment prefix from
  the default `#`.
- `c-`: Uncomment. An argument may be specified as in `c+`.
- `condarun`: `condarun envname cmd arg1 ...` executes `cmd` with the
  given args in the `envname` Conda environment (default environment
  is the one active when Acme was launched, else `base`).
- `Clean`: `Clean 'REGEX'` deletes clean Acme file windows with names
  matching the given regular expression. If no regular expression is
  provided, then all clean Acme file windows are deleted.
- `codepv`: Preview current Acme window code file in a browser.
- `Conf`: `Conf LANGUAGE` configures the current Acme window for the
  specified programming LANGUAGE. Run `Conf` (without a language) for
  supported languages.
- `ct`: `ct COLUMNNUMBER COMMENTPREFIX` adds `COMMENTPREFIX` at
  `COLUMNNUMBER` in each line of STDIN or text piped to the command.
- `d`: Diff the current window against the current file on disk, needs
  GNU diff (default on Linux; on macOS, install MacPorts `diffutils`).
- `dtw`: Delete trailing whitespace (spaces/tabs).
- `EC`: Load [EditorConfig](https://editorconfig.org/) indentation
  settings (spaces or tabs, and width of each indent level) for the
  current Acme window based on filename.
- `ff`: Wrapper around [fzf](https://github.com/junegunn/fzf) for
  fuzzy finding files based on filename. Also requires
  [ripgrep](https://github.com/BurntSushi/ripgrep) be installed.
- `F`: Print Acme window font or set/increase/decrease its size.
  Setting, increasing and decreasing font size only works if the
  current font is a variable font served by `fontsrv`.
- `F+`: Wrapper around `F` that increases the current Acme window's
  font size by a given number of points (defaults to 1 if called with
  no arg), assuming the screen is a low-DPI one. Only works if the
  current font is one served by `fontsrv`.
- `F-`: Like `F+` but decreases font size instead of increasing it.
- `F++`: Like `F+` but assumes the screen is a high-DPI one.
- `F--`: Like `F+` but decreases font size instead of increasing it,
  and assumes the screen is a high-DPI one.
- `Fcycle`: Cycles between a preset list of fonts in the `fontlist`
  environment variable (if `$fontlist` is empty or undefined, falls
  back to a hardcoded list of presets).
- `gb`: Wrapper for `git blame` of file in current Acme window.
- `gl`: Wrapper for `git log` of file in current Acme window.
- `ghurl`: Hurl the specified or current Acme window file in current
  or given branch to a web browser.
- `git`: Wrapper for `git` that automatically sets the `GPG_TTY`
  environment variable when in a TTY. Note that the pinentry program
  used by GPG should be set to `pinentry-tty`, see comments in the
  script file for more info.
- `h`: `hcount=N h STRING` shows the last `N` commands in a win window
  that contain `STRING`. If `hcount=N` is omitted then the last 10
  matching commands are shown. If `STRING` is omitted, then the most
  recent commands are show (i.e., match all commands).
- `hn`: Command-line [HN](https://news.ycombinator.com) client.
- `hrule`: Prints to stdout a horizontal line of a given length
  (defaults to 70) using a given character (defaults to `─`).
- `ishidpi`: Prints to stdout 1 if screen is high DPI or 0 otherwise.
- `lower`: Lowercase text selection.
- `lw`: List Acme windows (including window ID, whether the window is
  a directory window, and if the window is dirty). A fancier version
  of running the `Edit X` Sam command.
- `mdlink`: Convert URL to Markdown link labeled with its page title.
- `mdpv`: Preview current Acme window Markdown file in a browser.
- `mvto`: Rename current Acme window file, and updates the tag after.
  Uses `git mv` if the file part of a Git repository, `mv` otherwise.
- `noansi`: Strip ANSI color codes from stdin, write result to stdout.
- `rg+`: Wrapper for running
  [ripgrep](https://github.com/BurntSushi/ripgrep) with output that
  can be plumbed. Note that for modified open files in Acme, the saved
  version of the file is searched.
- `rg-`: Wrapper for running
  [ripgrep](https://github.com/BurntSushi/ripgrep) on the current Acme
  window's contents with output that can be plumbed. Note that this
  will search the unsaved modified contents if the window is dirty
  (i.e., modifications made but not yet saved to file).
- `rg--`: Like `rg-` but for all Acme windows corresponding to files.
- `runfc`: `>runfc cmd arg1 ...` will copy the text selection to a
  temporary file, run a command `cmd` that modifies the temporary file
  in-place (like Python's `black` formatter) and output the temporary
  file to the Error window. Use `|` instead of `>` to replace the text
  selection with the result instead of outputting to the Error window.
- `s+`: Indent by adding leading spaces, specify an argument to change
  the number of spaces from the default of `$tabstop`.
- `s-`: Unindent by removing leading spaces, specify an argument to
  change the number of spaces from the default of `$tabstop`.
- `s2t`: Replaces leading spaces with tabs, specify an argument to
  change number of spaces to a tab from the default of `$tabstop`.
- `sp`: Wrapper to run [Hunspell](https://hunspell.github.io/)
  spellchecker on the current Acme window with plumbable output.
- `Slide`: Start slideshow for current directory, where the slides are
  text files and slide sequence is given by an `index` file containing
  filenames of the text files (with no leading directories) with one
  filename per line and no empty lines.
- `Slide+`: Next slide, to be used with `Slide`.
- `Slide-`: Previous slide, to be used with `Slide`.
- `surround`: Add surrounding brackets, specify a left-side arg (e.g.
  `{` , `[` , `$` , `<` , and so on) to use a specific bracket pair
  other than the default round parentheses `(` and `)`.
- `t+`: Indent by adding leading tabs, specify an argument to change
  the number of tabs from the default of 1.
- `t-`: Unindent by removing leading tabs, specify an argument to
  change the number of tabs from the default of 1.
- `t2s`: Replaces tabs with spaces. Specify an argument to change the
  number of spaces to a tab from the default of `$tabstop`.
- `uline`: Underline text selection. Specify an argument to change the
  character for underlining from the default of '-'.
- `uncase`: Convert an alphanum string to a case-insensitive regexp.
- `upper`: Uppercase text selection.
- `w+`: Wrap (format text so each line is under some width in chars),
  specify an arg for a width other than the default of `70`.
- `w-`: Unwrap (join text across multiple lines into one line).

### Optional tools

- [Go](https://golang.org/): Some tools below require Go to install or
  run. Installable via a package manager (e.g. APT or Homebrew or
  MacPorts), or download a binary release from the website.

- [Rust](https://www.rust-lang.org/): Some tools below are compiled
  with Rust tooling. These use the `cargo` command. To install Rust
  tooling, see [link](https://www.rust-lang.org/tools/install).

- [acmego](https://pkg.go.dev/9fans.net/go/acme/acmego): When Go files
  are written, automatically makes adjustments in the window body to
  the import block as needed using `goimports` but does not write the
  file. Also supports autoformatting Rust files using `rustfmt`. An
  alternative that works on any Acme window using any given command is
  [acme-autoformat](https://github.com/droyo/acme-autoformat). There
  are also [several](https://github.com/mjibson/acmewatch)
  [forks](https://github.com/prodhe/acmefmt) of acmego that extend
  it to format code files other than Go and Rust ones.

- [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)
  client. Two options (current preference is `acre`):

  - [acme-lsp](https://github.com/9fans/acme-lsp)

    Can be installed with:

    ```sh
    GO111MODULE=on go install 9fans.net/acme-lsp/cmd/acme-lsp@latest
    GO111MODULE=on go install 9fans.net/acme-lsp/cmd/L@latest
    ```

    Some helper scripts for acme-lsp can be created while in the `rc`
    shell from a `$path` dir, say `$home/.acme/bin/`, and running:

    ```sh
    for(cmd in comp def fmt hov impls refs rn sig syms type assist ws ws+ ws-){
      > L^$cmd {
        echo '#!/usr/bin/env rc'
        echo exec L $cmd '$*'
      }
      chmod +x L^$cmd
    }
    ```

    Configure acme-lsp via CLI params or a [TOML](https://toml.io/) file
    `$HOME/Library/Application Support/acme-lsp/config.toml` (macOS) or
    `$HOME/.config/acme-lsp/config.toml` (Unix/Linux). A sample config
    is provided in the repo at `stow/dot-config/acme-lsp/config.toml`.

    The `stow/dot-acme/bin/LSP` script `LSP` starts `acme-lsp` with
    additional workspace dirs set based on the current dir.

  - [acre](https://github.com/mjibson/acre)

    Can be installed with (change paths or versions as needed):

    ```sh
    cd /some/path
    curl -LO https://github.com/mjibson/acre/archive/refs/tags/v0.5.5.tar.gz
    tar xzf v0.5.5.tar.gz
    cd acre-0.5.5
    cargo install --path $PWD
    cd ~/.local/bin
    ln -s /some/path/acre-0.5.5/target/release/acre
    ```

    Acre does not auto-detect workspaces
    ([link](https://github.com/mjibson/acre/issues/10)) so paths to
    project workspaces should be added to the config file at
    `$HOME/.config/acre.toml` as needed. A sample config file is
    provided in this repo at `stow/dot-config/acre.toml` that uses
    `gopls`, `ruff-lsp`, `rust-analyzer` and `zls` for Go, Python, Rust
    and Zig code (note that no workspace paths are specified).

- [AI](https://github.com/rogpeppe/AI): Interact with the OpenAI
  [ChatGPT](https://openai.com/blog/chatgpt) endpoint from Acme.

  To install:

  ```sh
  git clone https://github.com/rogpeppe/AI.git
  cd AI
  go install .
  ```

  To use, set the `OPENAI_API_KEY` environment variable with an
  API key. In Acme, run `AI 'instruction...'` to ask ChatGPT to
  perform the instruction (replace `instruction...` appropriately)
  with some selected text as context,  or `AI -c instruction...`
  for the same but with the whole file as context.  This replaces
  the selected text (or entire file if using the `-c` option) using
  the first code block in the response. If working with regular
  text or markdown, it may be necessary to end the instruction with
  `Put your response into a markdown block` or something like it.

  An alternative is [acmegpt](https://github.com/mariusae/acmegpt).
  This is a direct chat using the OpenAI API in a separate window.
  Compared to `AI`, it does not utilize any selected text as context
  (it has a chat UX so any extra context needs to be copy-pasted)
  but the chat has history so answer followups and refinements
  are possible. It also requires the `OPENAI_API_KEY` environment
  variable to be set.

- [awww](https://github.com/cjacker/awww):
  Text web browser for Acme. Button2 or Button3 opens links in opened
  webpages.  Requires [wget](https://www.gnu.org/software/wget/) and
  [rust-html2text](https://github.com/jugglerchris/rust-html2text/)
  (compile its example program `examples/html2text.rs`).

- [bdf2subf](https://post.lurk.org/@320x200/102532617791988449)
  ([source](https://git.bleu255.com/plan9port/commit/2b5318c96f51eda9e0d1078c337ca66b852cf597.html),
  [usage](https://git.bleu255.com/plan9port/file/font/terminus/README.html)):
  Patch for plan9port that builds BDF to plan9 font converter
  tool [bdf2subf](https://plan9.io/wiki/plan9/fonts/index.html)
  ([alt](http://plan9.stanleylieber.com/fonts/)) during `INSTALL`.
  A copy of this patch is included in the `patches` directory, see
  `README.md` in that directory for how to apply it.

  Usage:

  ```sh
  bdf2subf -f somefont.bdf > somefont.font  # generate font file
  bdf2subf somefont.bdf                     # generate subfont files
  ```

  Example (POSIX shell):

  ```sh
  mkdir -p /path/to/lib/font/gohufont
  cd /path/to/lib/font/gohufont
  curl -LO https://github.com/hchargois/gohufont/raw/master/gohufont-uni-14.bdf
  curl -LO https://github.com/hchargois/gohufont/raw/master/gohufont-uni-14b.bdf
  for f in *.bdf; do bdf2subf -f $f > $(basename $f .bdf).font; bdf2subf $f; done
  ```

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

- [editinacme](https://pkg.go.dev/9fans.net/go/acme/editinacme)
  ([Github](https://github.com/9fans/go/tree/main/acme/editinacme)):
  Command usable as the `EDITOR` environment variable, which uses
  `plumber` to open a specified file in Acme and waits for that
  file's window in Acme to be closed before exiting. To install:

  ```sh
  go install 9fans.net/go/acme/editinacme@latest
  ```

- [gemini](https://github.com/rsc/tmp/tree/master/gemini):
  Interact with the Google
  [Gemini](https://ai.google.dev/docs/gemini_api_overview) API
  endpoint from Acme.

  [More info](https://developers.generativeai.google/).

- [issue](https://pkg.go.dev/rsc.io/github/issue)
  ([Github](https://github.com/rsc/github)):
  Acme client for reading and updating Github project tracker issues.
  Note that the project repo defaults to `golang/go` so use the `-p`
  CLI option to specify the appropriate project. In Acme, issues for
  a given Github project can be searched by executing a command like
  `issues -a -p <OWNER>/<REPOSITORY> <QUERY>`. Example plumbing rule:

  ```text
  # matches '<OWNER>/<REPOSITORY>/issues/<ISSUENUMBER>'
  type is text
  data matches '([0-9a-zA-Z]+)/([0-9a-zA-Z]+)/issues/([0-9]+)'
  plumb to githubissue
  plumb client issues -a -p $1/$2 $3
  ```

  Install using `go install rsc.io/github/issue@latest`. This program
  requires a Github personal access token be written to the file
  `$HOME/.github-issue-token`, and the token needs to have the scope
  `repo` for public repositories or `private_repo` for private ones.

- [I](https://github.com/hherman1/I): Make CLI tools interactive in
  Acme. Running `I <cli>` to execute the command in a new window,
  where Button2 on window text will append the clicked text as a new
  arg and rerun the command, Button2 on Back will remove the newest
  arg and rerun, and Get will rerun the command as is.

- [Jira](https://pkg.go.dev/github.com/hdonnay/Jira)
  ([Github](https://github.com/hdonnay/Jira)):
  Acme client for reading and updating
  [Jira](https://www.atlassian.com/software/jira) issues. See package
  website or repository for how to set up appropriate plumbing rules.

- [match-paren](https://github.com/ChristopherSegale/match-paren) or
  [paren-matcher](https://github.com/ChristopherSegale/paren-matcher):
  Takes stdin and inserts closing parentheses at the end to balance
  out opening parentheses. `match-paren` is implemented in C while
  `paren-matcher` is implemented in Common Lisp and requires
  [SBCL](https://www.sbcl.org/). Can be useful when writing Lisp code.

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

- [uni](https://github.com/arp242/uni): Command-line tool for looking
  up the [Unicode](https://www.unicode.org/main.html) database. An
  alternative is [Unicode](https://github.com/robpike/unicode)
  (installable using `go install robpike.io/cmd/unicode@latest`).

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

- [9pfs](https://github.com/bunny351/9pfs):
  Replacement for plan9port `9pfuse` that is supposed to be faster.

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
    # Set prompt so middle-clicking whole line reruns line's command
    # Show last exit code if non-zero
    PROMPT=": %(?..{%?} )%m; "
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

### Working with remote files

One way to work with files on remote systems is by mounting remote
filesystems to a local mountpoint using [rclone](https://rclone.org/)
[mount](https://rclone.org/commands/rclone_mount/), so remote files
can be worked with as if they were local files.

Many remote storage backends are supported, like
[Azure Blob Storage](https://rclone.org/azureblob/),
[HDFS](https://rclone.org/hdfs/), [SFTP](https://rclone.org/sftp/),
[S3](https://rclone.org/s3/), etc.

An alternative is to mount NFS over SSH, though that requires
superuser permissions and user and group ids be the same across systems,
see [here](https://gist.github.com/proudlygeek/5721498),
[here](https://news.ycombinator.com/item?id=31815830), and
[here](https://www.linuxjournal.com/content/encrypting-nfsv4-stunnel-tls).

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
    scrollbar moves the viewport up and down respectively where
    the clicks near the top of scrollbar move the viewport less and
    clicks near the bottom of the scrollbar move the viewport more.
    Specifically, clicking Button1 on the scrollbar moves the top
    line of the viewport to that horizontal location and clicking
    Button3 on the scrollbar moves the line at that location to
    the top of the viewport.

  - Middle-clicks (Button2) on the scrollbar will move the viewport so
    that the view indicator is at the position scrollbar was clicked,
    which allows for directly jumping to a window position.

- Double-clicking (Button1 twice) just to the right of a left brace
  (`{`), bracket (`[`) or parenthesis (`(`), or just to the left of a
  right brace (`}`), bracket (`]`) or parenthesis (`)`) will select
  the text within paired braces, brackets or parentheses. This also
  works for text between greater than (`>`) and smaller than (`<`)
  chars. Example text:

  ```text
  (some text between (parentheses))
  [same thing within brackets
    but also across lines]
  <div>some <em>XML</em> or <em>HTML</em> text</div>
  ```

  - Wrap a command with brackets or parentheses to make it selectable
    by double-clicking as described above. Useful for easy selection
    of commands containing spaces. For example:

    ```text
    (Load /path/to/project.dump)
    ```

- Mouse chording (pressing mouse buttons in a sequence without
  releasing them) can be used to perform a number of actions.

  - The 1-2 chord (press Button1 and hold, then press Button2)
    executes Cut, i.e. remove selected text and overwrite the snarf
    buffer with it.

  - The 1-3 chord executes Paste, i.e. insert the contents of the
    snarf buffer at the point or over selected text.

  - The 2-1 chord will execute the current selected text using the
    previously selected text as an appended argument.

  - The 2-3 and 3-2 chords do not do anything, and can be used to get
    out of an unintended button press.

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
  workspace dumps. The `startacme.sh` launcher will open this file by
  default when no extra options are provided. An example of a
  start/bookmarks file follows.

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
  alias aproj='visibleclicks=1 $PLAN9/bin/rc $HOME/.local/bin/startacme.rc -f /mnt/font/GoRegular/15a/font -F /mnt/font/GoMono/15a/font -l /path/to/proj/acme.dump'
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

  1. Run `Edit =#` (or `Edit =`) at a file location to print the
     file's name and character address (or line number) of the cursor
     in a `+Errors` window. If desired, add a forward search query
     `/REGEXP/` to the end. This sets the region start location.

  1. Click on a later position in the file.

  1. In the `+Errors` window, append `,.` to the end of the file and
     line location (plus forward search query, if applicable).

  1. Button3 (right-click) on the resulting line in the `+Errors`
     window to plumb it, which will select the file region specified.

  The final line in the `+Errors` window to be plumbed will look
  something like `/path/to/file:#10,.` or `/path/to/file:#10/text/,.`
  (or `/path/to/file:10,.` or `/path/to/file:10/text/,.`), matching
  the plumbing pattern `FILEPATH:STARTLOCATION,ENDLOCATION` with the
  character address (or line) from the `Edit` command and the cursor
  location `.` used for the start and end locations.

### Typical setup and workflow

**Setup**:

- Follow the setup as described above, applying the desired patches
  prior to building.
- Install supporting programs.
  - For the scripts in `$HOME/.acme/bin`, these would be GNU
    coreutils, Conda, `fzf`, `git`, `ripgrep`, or `mamba`, `par` if
    preferable to GNU coreutils' `fmt`, and `enchant` if spell
    checking is needed.
  - For direct helper programs, these would be `acme-lsp` (along with
    the relevant LSP servers), `Watch`, and any other programs desired
    (see the _Optional tools_ subsection above). Also, other tools
    like [code search](https://github.com/google/codesearch) and
    [cspell](https://github.com/streetsidesoftware/cspell) are useful.
  - Install [gcat](https://github.com/aaronjanse/gcat) to support
    plumbing Gemini URLs `gemini://...` with output to `+Errors`.
  - Install `pandoc` to preview Markdown files with the `mdpv` script
    and code files with the `codepv` script.
  - Also install `curl`, `gawk` and `jq` so `hn` can be used to plumb
    [HN](https://news.ycombinator.com) URLs to the `+Errors` window.
- Set up an Acme launcher app (macOS) or desktop entry (Linux) to make
  launching Acme easier.

**Usage**:

- Launch Acme
- Load a dump file to restore a previous session
- Execute `Atrackf` to log opened files to `$HOME/.acme/recentf`
- Execute `Asave` to autosave dirty (i.e., modified and unsaved) files
  to `$HOME/.acme/autosave`
- If needed, execute `Arecentf` to list recently edited files
- If editing code:
  - Execute `Indent on` in a window tag if appropriate
  - Populate the window tag with useful commands, at least `Edit`,
    `:0` and `:$`.
  - If working on a Git version-controlled project, create a `guide`
    file in the repository root as a space for putting useful commands
    or as scratch. Add `/guide` to `.gitignore`.
  - Useful `Edit` commands can be added to `guide`, and they can be
    used using by 2-1 chording to `Edit` to a file window tag.
  - Change the font by executing `Font` (or using the `F` script)
    in the window tag.
  - If there is an EditorConfig setting for the project, execute `EC`
    in the window tag.
  - Search code backwards and forwards by right-clicking
    `:/[Ff]oo' and `:-/\[Bb\]ar\` in the window tag.
  - Get all search results within a file by middle-clicking
    `rg- '[Ff]oo'` which pops up the results in an error window.
  - Get all search results across all files in the directory tree by
    middle-clicking `rg+ '[Ff]oo'` which pops up the results in an
    error window.
  - To enable a write-compile-debug loop, middle-click `Watch` with
    the appropriate arguments. Error locations can be plumbed to open
    the appropriate code file and line.
  - Middle-click `acme-lsp` to launch it for a window's project. It is
    best to work on one project at a time when using `acme-lsp`.
  - Git commands can be run from the `guide` file, or from the window
    tag. Run `gl` or `gb` to see Git log or blame for the focused
    window file.
- When done with a session, `Dump` it to a file so it can be reloaded
  and continued later.

## Sam

Plan 9 also comes with another editor [Sam](http://sam.cat-v.org/)
that is the predecessor of Acme, but has the benefit of having a
client-server that can be better suited for remote file editing under
high network latency.

See `9 man sam` for more information about using the Sam editor.

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

Additional notes on scaling fonts and high DPI screens (examples use
Acme but the behavior holds similarly for other plan9port programs
where fonts may be specified using `$font` or otherwise):

- If the specified font has format `SCALE*FONT` where `SCALE` is some
  integer, `FONT` is used scaled by pixel repetition. Example:

  ```sh
  acme -f 2*/lib/font/bit/lucsans/unicode.8.font
  ```

- If the specified font has the format FONT1,FONT2 then FONT1 is used
  on low DPI screens and FONT2 is used on high DPI screens. This is
  useful in multi-screen environments where some screens are high DPI
  while other screens are low DPI. Example:

  ```sh
  acme -f /lib/font/bit/lucsans/unicode.8.font,/mnt/font/GoRegular/16a/font
  ```

- If only one font is specified, on high DPI screens the font is
  swapped out for another (for the code, see `src/libdraw/openfont.c`
  and `src/libdraw/init.c`). If the font is a Plan 9 bitmap font, the
  same font 2-times scaled by pixel repetition is used. If the font is
  a `fontsrv` vector font, the same font with double the point size is
  used. E.g., the following two commands are effectively the same:

  ```sh
  acme -f /lib/font/bit/lucsans/euro.8.font \
       -F /mnt/font/GoMono/9/font
  ```

  ```sh
  acme -f /lib/font/bit/lucsans/euro.8.font,2*/lib/font/bit/lucsans/euro.8.font \
       -F /mnt/font/GoMono/9/font,/mnt/font/GoMono/18/font
  ```

  However, it can be observed that when only one font is specified
  with a scaling factor (`acme -f 3*/lib/font/bit/luc/unicode.9.font`)
  then no font swapping occurs on high DPI screens.

- A screen is considered high DPI if it has DPI of around 200 or more.
  The code for whether a screen is considered high dpi is
  `d->dpi >= DefaultDPI*(3/2)` (in `src/libdraw/openfont.c` and
  `src/libdraw/init.c`) where `DefaultDPI=133` (in `include/draw.h`).

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

Two scripts `makeapp.sh` and `makeapp2.sh` are provided in the
`macos` folder, either of which can be used for creating an Acme
launcher application bundle. See `macos/README.md` for details.

Note that script-only apps are always run under Rosetta 2 on arm macOS
systems, so make sure to install that if needed (for more information on this
topic, see the paragraph on **unsigned native (ARM) code**
[here](https://eclecticlight.co/2022/02/01/what-shouldnt-you-use-an-m1-series-mac-for/))
and also see
[here](https://eclecticlight.co/2021/02/18/code-signing-requirements-for-scripts-and-apps-in-big-sur/).

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
Instructions here use the `~/.acme/bin/startacme.sh` launcher script.

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
Exec=/home/USERNAME/.local/bin/startacme.sh %f
TryExec=/home/USERNAME/.local/bin/startacme.sh
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
  (recommend this
  [fork]([pedramos](https://github.com/pedramos/9fans)),
  or at least incorporating some of its commits, like
  [this](https://github.com/pedramos/9fans/commit/8675b85e54e03cf16a64e07d88f91347bb12a748),
  [this](https://github.com/pedramos/9fans/commit/f0c0e9a88de15dd69c34da6cd10eb00b80594097)
  and
  [this](https://github.com/pedramos/9fans/commit/c70c0dbca34fe7f2a2ce603b2387cff6a640961b))

- [Edwood](https://github.com/rjkroege/edwood) (another Acme Go port)

- [Sam Go port](https://github.com/9fans/go/tree/main/cmd/sam)

- [Yacco](https://github.com/aarzilli/yacco)

- [Anvil](https://anvil-editor.net/) a Go port of Acme with interesting ideas around remote, running commands, and others

## Other Plan 9-related tools

- [ghfs](https://github.com/sirnewton01/ghfs): 9p Github file server.
  To use it after installing, run ghfs, mount the filesystem with
  `9 mount localhost:5640 /path/to/mountpoint` (replace port number
  with set ghfs port, and modify the the mountpoint path as needed).

## Other useful or reference links

- [Acme and me | ilanpillemer](https://ilanpillemer.github.io/subjects/acme.html)

- [Acme plumbing rules for OCaml](https://discuss.ocaml.org/t/acme-plumbing-rules-for-ocaml/10467)

- [Acme Resources](https://github.com/ixtenu/acmerc)

- [Acme Tricks](https://blog.silvela.org/post/2021-12-11-acme-tricks/)

- [Awesome Acme](https://github.com/mkmik/awesome-acme)

- [Better plumbing in Xorg with plan9port’s plumber](https://dataswamp.org/~lich/musings/plumbing.html)

- [Email Configuration for plan9 Acme on OpenBSD](https://akpoff.com/archive/2018/email_config_plan9_acme_openbsd.html)

- [Hints for writing Unix tools](https://monkey.org/~marius/unix-tools-hints.html)

- [Just as Mario: Using the Plan9 plumber utility](https://mostlymaths.net/2013/04/just-as-mario-using-plan9-plumber.html/)

- [My Acme Setup - UNOBTANIUM](https://unobtanium.de/posts/acme/)

- [On Some Tools for Plan9's Acme](https://tales.mbivert.com/on-some-tools-for-plan9-acme/)

- [Plan 9 Desktop Guide](https://pspodcasting.net/dan/blog/2019/plan9_desktop.html)

- [Plan 9 Wiki Plumbing Examples](https://9p.io/wiki/plan9/plumbing_examples/index.html)

- [Plan 9 Wiki Tip o' the day](https://9p.io/wiki/plan9/Tip_o'_the_day/index.html)

- [Plan9/Sam](https://9lab.org/plan9/sam/)

- [plan9port linux environment](https://github.com/gdiazlo/p9penv)

- [Plumbing rules for Puppet manifests](https://blog.aqwari.net/plumber-puppet/)

- [Using the Plan 9 Plumber to Turn Acme into a Git GUI](https://alexkarle.com/blog/plan9-acme-git-gui.html)

- [When You Have Reached Acme](https://mkhl.codeberg.page/acme-setup/)

- Writing a 9P server from scratch parts
  [one](https://blog.aqwari.net/9p/),
  [two](https://blog.aqwari.net/9p/parsing/) and
  [three](https://blog.aqwari.net/9p/server/)
