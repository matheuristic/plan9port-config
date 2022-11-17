#!/usr/bin/env sh

# Sample wrapper file to launch Sam from environments without the Plan 9 bin
# directory in their search path

# It is recommended to copy this file to ~/.local/bin/sam.sh and configure the
# launch command with the appropriate font environment variable, e.g.
#    font=/mnt/font/GoMono/16a/font sam.sh \
#        $PLAN9/bin/rc $HOME/.local/bin/startsam.rc "$@"

if [ -z "$PLAN9" ]; then
    export PLAN9=/usr/local/plan9port
    export PATH=$PATH:$PLAN9/bin
fi
$PLAN9/bin/rc $HOME/.local/bin/startsam.rc "$@"
