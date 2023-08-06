# macOS helper scripts

## Creating an application launcher for the macOS dock

Run `makeapp.sh` or `makeapp2.sh` to create an application launcher
in the user's or the system's Applications folder.

Set `$PLAN9` to specify the plan9port repository directory path if it
is different from the default `/usr/local/plan9`.

Set `$APPDIR` to install the resulting `Acme.app` application launcher
to a directory other than `~/Applications`.

Set `$STARTACMEPATH` to set the command used to start Acme,
which can be a script or the path to the `acme` command itself,
to something other than the default `~/.local/bin/startacme.sh`.
Note that `../plan9port/.local/bin/sample-startacme.sh` can be used
as a starting point for creating a launch script.

For example, the following runs `makeapp.sh` assuming that plan9port
is installed at `~/Packages/plan9port` and the application launcher is
to be installed to the `/Applications` (technically, these are
the default assumed plan9port install and target directories).

```sh
PLAN9=$HOME/Packages/plan9port APPDIR=/Applications ./makeapp.sh
```

The difference between `makeapp.sh` and `makeapp2.sh` is that
application bundle created by `makeapp.sh` calls the Acme launcher or
command as a foreground process while the application bundle created
by `makeapp2.sh` calls the Acme launcher as a background process.

In terms of intended usage, the `makeapp.sh` launcher is designed
around launching a single Acme instance, while `makeapp2.sh` is
designed around launching multiple instances of Acme (it requires
that the called Acme script or command has an `-N` option for
launching a new instance of Acme even if one is already running).

For convenience, it is recommended to add the new launcher
application bundle to the dock for easy access.
