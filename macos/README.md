# macOS helper scripts

## Creating an application launcher for the macOS dock

Run `makeapp.sh` to create an application launcher in the user's or
the system's Applications folder.

Set `$PLAN9` to specify the plan9port repository directory path if it
is different from the default `/usr/local/plan9`.

Set `$APPDIR` to install the resulting `Acme.app` application launcher
to a directory other than `~/Applications`.

For example, the following runs `makeapp.sh` assuming that plan9port
is installed at `~/Packages/plan9port` and the application launcher is
to be installed to the `~/Applications` (technically, this is the same
as the default target directory).

```sh
PLAN9=$HOME/Packages/plan9port APPDIR=$HOME/Applications ./makeapp.sh
```

The application launcher assumes an executable Acme startup script
`$HOME/.local/bin/startacme.sh` exists. One can be created using
`../plan9port/.local/bin/sample-startacme.sh` as a starting point.

For convenience, it is recommended to add the new launcher to the
dock for easy access.
