#!/usr/bin/env sh

# Sample wrapper file to launch Sam from environments without the Plan 9 bin
# directory in their search path

# It is recommended to copy this file to ~/.local/bin/sam.sh and configure the
# launch command with the appropriate font environment variable, e.g.
#    font=/mnt/font/GoMono/16a/font sam.sh \
#        $HOME/.local/bin/rc.sh $HOME/.local/bin/startsam.rc "$@"
 
$HOME/.local/bin/rc.sh $HOME/.local/bin/startsam.rc "$@"
