#!/usr/bin/env sh

# Sample wrapper file to launch Acme from environments without the Plan 9 bin
# directory in their search path. It is recommended to copy this file to
# ~/.local/bin/acme.sh and configure the launch command with the desired
# default settings.
#
# The following code is an example of how to modify this script to launch into
# a start file if no extra options are specified when calling this script.
#    startparams="$@"
#    if [ "$startparams" = "" ]; then
#        startparams="-c 1 $HOME/.acme/start"
#    fi
#    $HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc $startparams
#
# The following code simplifies launching multiple Acme instances, enabling the
# script to take an optional '-n N' flag for launching Acme in the N-th
# "sub-namespace" /tmp/ns.$USER.$DISPLAY-N (note that the -n flag must
# be the first option specified when running the script).
#    if [ "$1" = "-n" ]; then
#        export NAMESPACE=/tmp/ns.$USER.$DISPLAY-$2
#        mkdir -p "$NAMESPACE"
#        shift; shift
#    fi
# For example, calling 'acme.sh -n 1' launches an Acme instance in the
# /tmp/ns.$USER.$DISPLAY-1 namespace.
#
# Example script code incorporating the above.
#    if [ "$1" = "-n" ]; then
#        export NAMESPACE=/tmp/ns.$USER.$DISPLAY-$2
#        mkdir -p "$NAMESPACE"
#        shift; shift
#    fi
#    startparams="$@"
#    if [ "$startparams" = "" ]; then
#        startparams="-c 1 $HOME/.acme/start"
#    fi
#    visibleclicks=1 SHELL=rc $HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc \
#        -f /mnt/font/GoRegular/16a/font -F /mnt/font/GoMono/16a/font \
#        $startparams

$HOME/.local/bin/rc.sh $HOME/.local/bin/acme.rc "$@"
