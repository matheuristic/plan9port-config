# Usage

Several scripts in this directory operate on STDIN or piped text.

In Acme, to pipe text to a command (say `cmd`), write out the pipe
into command `|cmd`. If the text to apply on is in the same window as
the pipe-command string, left-click to select text and right-click
select `|cmd` to pipe the text into `cmd` and replace the selected
text with the output. For example, if some selected text is to be
commented, the pipe-command string should be `|c+`.

Use 2-1 chording to pass selected text in one window to a command
in another window.
