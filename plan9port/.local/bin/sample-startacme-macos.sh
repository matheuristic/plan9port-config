#!/usr/bin/env sh

# Sample ~/.local/bin/startacme.sh for macOS for launching Acme
# If plumbing web URLs does not work, set environment var BROWSER=none

if [ -z "$PLAN9" ]; then
    export PLAN9=/usr/local/plan9port
    export PATH=$PATH:$PLAN9/bin
fi
startparams="$@"
visibleclicks=1 SHELL=rc \
    $PLAN9/bin/rc $HOME/.local/bin/startacme.rc \
    -f /lib/font/bit/lucsans/unicode.8.font,/mnt/font/LucidaGrande/30a/font \
    -F /lib/font/bit/lucm/unicode.9.font,/mnt/font/AndaleMono/32a/font \
    $startparams
