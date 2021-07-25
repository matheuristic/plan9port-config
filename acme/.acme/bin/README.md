# Usage

Several scripts in this directory operate on STDIN or piped text.

In Acme, to pipe text to a command (say `cmd`), write out the pipe
into command `>cmd`. If the text to apply on is in the same window as
the pipe-command string, left-click to select text and right-click
select `>cmd` to pipe the text into `cmd` and echo the result to the
corresponding Error window.

Using `|` rather than `>` (i.e., `|cmd`) will replace the selected
text with the output instead. For example, if some selected text is to
be commented, the pipe-command string should be `|c+`.

Use 2-1 chording to pass selected text in one window to a command in
another window. Note that using `|cmd` in this way will replace the
selected text in the window with the command rather than the window
with the text was selected.

For more info, see `<|>` in the **Mouse button 2** section of the
[Acme manpage](https://9fans.github.io/plan9port/man/man1/acme.html).
