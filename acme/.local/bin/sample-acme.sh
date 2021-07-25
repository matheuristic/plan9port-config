#!/usr/bin/env sh

# Sample wrapper file to launch Acme from environments without the Plan 9 bin
# directory in their search path

# It is recommended to copy this file to ~/.local/bin/acme.sh and configure the
# launch command with the default font, indent and visibleclicks settings, e.g.
#    visibleclicks=1 SHELL=rc $HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc \
#        -f /mnt/font/GoRegular/16a/font -F /mnt/font/GoMono/16a/font \
#        "$@"
 
$HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc "$@"
