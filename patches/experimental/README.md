# plan9port experimental or untested patches

## Remoting

### Add remoting capability to Acme via new p9 servers

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-acme-acmesrv.patch
```

This is a (lightly modified) patch
[acmesrv.patch](https://gist.github.com/mariusae/a7b13730b7c5aa08f32b30a64f31856b)
from [mariusae](https://github.com/mariusae), that adds remoting
capability to Acme. Specifically, it adds an `acmesrv` program that
acts as a multiplexer on top of two 9p servers exportfs and cmdfs for
accessing files and running commands on the remote host from a local
Acme client along with modifying `acme` to let it connect to `acmesrv`
on a remote host `acmesrv` via SSH, that is (quoted from the first
link below):

> The design of the feature is quite simple: a new program, acmesrv
> <https://github.com/mariusae/plan9port/tree/marius/src/cmd/acme/acmesrv>
> is run by acme (through ssh) on the remote host. Acme becomes a
> client of acmesrv, through which all further interaction is
> facilitated. Acmesrv itself is really just a 9p multiplexer: the
> local acme program exports the acme and plumber 9p servers; acmesrv
> provides two new 9p servers (exportfs and cmdfs) that gives the
> local acme access to the remote's file system (exportfs) and to run
> commands (cmdfs).
>
> The local acme manages a session for each remote, and properly deals
> with session disconnect/reconnect, etc. Thus, poor network
> conditions and disconnects are easily supported. Since acme's file
> handling is anyway stateless (the file is not kept open during
> editing), file state is easily maintained through
> disconnect-reconnect cycles.

To open Acme and connect a remote host to a local prefix, run

```sh
acme -R remotehost:/local/prefix
```

where `remotehost` is a host name from `$HOME/.ssh/config` or some
`user@hostname`, and `/local/prefix` is a path prefix for remote host
resources in the local Acme client. To connect to the remote SSH
server using a port other than the default `22`, use a host name from
`$HOME/.ssh/config` (the `-R` option parser splits the parameter value
into host and prefix tokens on the first `:` character, so specifying
`acme -R user@hostname:123:/local/prefix` tokenizes incorrectly).

More on remoting behavior (again quoted from the first link below):

> A remote may be attached to one or more path prefixes. These are
> similar to mount points in a file system. Thus, if the prefix
> /home/meriksen is attached to the remote "dev", then any file with
> this prefix is transparely fetched from the dev. Similarly, when
> commands are run from any directory with this prefix, the command is
> transparently run on the remote. The command is run in an
> environment that includes the acme and plumber 9p servers (forwarded
> from the local host), and so even acme programs just work. For
> example, if you run 'win' from a directory that is attached to a
> remote, 'win' is run on the remote host, but it accesses the acme 9p
> file tree (which is forwarded from the local acme) and creates its
> window and interacts with acme. It "just works". (I regularly run
> other programs like this too, e.g., acme-lsp, which uses the plumber
> to coordinate interaction).

From the appropriate Twitter thread (quoted from the fourth link below):

> Because acme was part of Plan 9 and was designed around
> application-specific file servers, I could use the same mechanism to
> implement client-server remoting.
>
> The remoting implementation exports acme's local filesystems
> (through which it interacts with external programs) over ssh, using
> 9p.
>
> Similarly, I implemented two 9p servers that were imported from the
> remote host (through the same server, which acts as a 9p
> multiplexer).
>
> The first exports the remote's file system to the local acme
> instance.
>
> The second server provides a filesystem through which commands can
> be defined and run.
>
> This is really all that's needed for a more-or-less fully fledged
> remoting implementation.
>
> Acme itself is internally quite stateless (buffers are kept in
> memory; files are read in full and written back), which also helps
> keep things simple, and the implementation is fully capable of
> handling remote failures and disconnects, etc.

Links:

- [9fans - plan9port: acme remoting](https://www.mail-archive.com/9fans@9fans.net/msg39249.html)
  (also see [here](https://twitter.com/marius/status/1345956886881865728))
- [Github Gist - mariusae/acmesrv.patch](https://gist.github.com/mariusae/a7b13730b7c5aa08f32b30a64f31856b)
- [Github - mariusae/plan9port - marius-snapshot-2022-04-24](https://github.com/mariusae/plan9port/tree/marius-snapshot-2022-04-24)
- [Twitter thread](https://twitter.com/marius/status/1345956890648317952)

### Add soft tabs to Acme editor (acmesrv-compatible version)

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-acme-soft-tabs-acmesrv.patch
```

This is the same as `plan9port-acme-soft-tabs.patch` except it has
been modified to be compatible with the codebase after applying
`plan9port-acme-acmesrv.patch` (otherwise there will be conflicts).

If using `plan9port-acme-acmesrv.patch` above to add remoting
capability and additionally soft tabs are desired, use this patch
instead of `plan9port-acme-soft-tabs.patch`.

### Use slashed zero variant for Lucida Grande font on macOS

To apply the patch, run from the repository root:

```sh
patch -p1 < /path/to/plan9port-fontsrv-lucida-grande-slashed-zero.patch
```

This is a patch for `fontsrv` by
[mariusae](https://gist.github.com/mariusae/d3856206297706ea90d30abc177a7100)
that substitutes the regular zero glyph with an alternative slashed
version from the same font when serving Lucida Grande on macOS.

Links:

- [[9fans] Slashed zero in Lucida Grande (macOS)](https://marc.info/?l=9fans&m=155425543915808)
