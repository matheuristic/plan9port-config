# Font conversion scripts

Scripts for getting Plan 9 subf fonts from vector fonts via `fontsrv`
which does the actual conversion. These scripts are sourced from
[this](https://9fans.topicbox.com/groups/9fans/Td0ab6c3112c95493-M4b945fa58f69efff23098167)
[9fans mailing list](https://9fans.topicbox.com/groups/9fans) thread
message with minimal editing.

On slower machines, using subf fonts can be faster than using vector
fonts via `fontsrv` when there are many Unicode characters that need
to be rendered.

Note that the scripts can be quite slow and generate quite a large
font folder for fonts that have very wide Unicode coverage.

Run `9p ls font` with `fontsrv` running for available vector fonts.

- `mixfont.sh`: Mix different `fontsrv` vector fonts (or different
  weights and styles) into a new Plan 9 font.

- `subf_get_1_size.rc`: Get a single size of a given font. Example
  usage:

  ```shell
  subf_get_1_size.rc DejaVuSans-Bold 20a
  ```

- `subf_get_all_sizes.rc`: Get all available sizes of a given font.
  Requires `subf_get_1_size.rc` be on the system path. Example usage:

  ```shell
  subf_get_all_sizes.rc DejaVuSans-Bold
  ```

An alternative to `subf_get_1_size.rc` and `subf_get_all_sizes.rc`
is using `fontsrv -m mtpt` to mount a virtual directory tree at
`mtpt` and copying the bitmap font files directly from there
([source](https://pmikkelsen.com/plan9/fonts)). **This alternative
approach requires that FUSE be installed on the system**.

```console
$ mkdir -p /tmp/font
$ fontsrv -m /tmp/font &
$ mkdir -p /path/to/font/GoRegular/15a
$ cp /tmp/font/GoRegular/15a/* /path/to/font/GoRegular/15a/
```
