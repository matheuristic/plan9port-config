#!/usr/bin/env sh

# Sample wrapper file to launch Acme from environments without the Plan 9 bin
# directory in their search path
#
# It is recommended to copy this file to ~/.local/bin/acme.sh and configure the
# launch command with the default font, indent and visibleclicks settings, e.g.
#    visibleclicks=1 SHELL=rc $HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc \
#        -f /mnt/font/GoRegular/16a/font -F /mnt/font/GoMono/16a/font \
#        "$@"

# Uncomment the next block to support launching multiple Acme instances. This
# modifies the script to take an optional '-n N' flag for launching Acme in the
# N-th "sub-namespace" /tmp/ns.$USER.$DISPLAY-N (note that the -n flag must
# be the first option specified when running the script). For example,
#    acme.sh -n 1
# lauches an Acme instance in namespace /tmp/ns.$USER.$DISPLAY-N

# if [ "$1" = "-n" ]; then
#   export NAMESPACE=/tmp/ns.$USER.$DISPLAY-$2
#   mkdir -p "$NAMESPACE"
#   shift; shift
# fi

$HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc "$@"
