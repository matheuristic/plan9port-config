#!/usr/bin/env sh

# Sample wrapper file that launches Acme from environments without the Plan 9
# from User Space (i.e., plan9port) bin directory in their search path. It is
# recommended to copy this file to ~/.local/bin/startacme.sh and customize it
# with the desired default settings.
#
# The following code illustrates how to modify this script so it launches into
# a start file when the script is run without any options specified.
#
#    startparams="$@"
#    startfile=$HOME/.acme/start
#    if [ "$startparams" = "" ]; then
#        if [ -f "$startfile" ]; then
#            startparams="-c 1 $startfile"
#        else
#            echo "Start file does not exist, skipping load: $startfile" 1>&2
#        fi
#    fi
#    $HOME/.local/bin/rc.sh $HOME/.local/bin/startacme.rc $startparams
#
# The following code simplifies launching of multiple Acme instances,
# enabling the script to take an optional '-n N' flag that launches
# Acme in a "sub-namespace" /tmp/ns.$USER.$DISPLAY-N (note that the
# -n flag must be the first option specified when running the script).
#
#    if [ "$1" = "-n" ]; then
#        export NAMESPACE=/tmp/ns.$USER.${DISPLAY-:":0"}-$2
#        mkdir -p "$NAMESPACE"
#        shift; shift
#    fi
#
# For example, 'acme.sh -n myproject' launches an Acme instance in the
# /tmp/ns.$USER.$DISPLAY-myproject namespace.
#
# Example script code incorporating all elements above.
#
#    if [ "$1" = "-n" ]; then
#        export NAMESPACE=/tmp/ns.$USER.${DISPLAY-:":0"}-$2
#        mkdir -p "$NAMESPACE"
#        # Uncomment below line if to maintain a cleaner /tmp/ directory
#        # (the /tmp/ directory gets cleaned on reboots in any case)
#        # trap 'rm -rf "$NAMESPACE"' EXIT
#        shift; shift
#    fi
#    startparams="$@"
#    startfile=$HOME/.acme/start
#    if [ "$startparams" = "" ]; then
#        if [ -f "$startfile" ]; then
#            startparams="-c 1 $startfile"
#        else
#            echo "Start file does not exist, skipping load: $startfile" 1>&2
#        fi
#    fi
#    visibleclicks=1 SHELL=rc BROWSER=garcon-url-handler \
#        $HOME/.local/bin/rc.sh $HOME/.local/bin/startacme.rc \
#        -f /lib/font/bit/lucsans/unicode.13.font -F /mnt/font/GoMono/18a/font \
#        $startparams

$HOME/.local/bin/rc.sh $HOME/.local/bin/startacme.rc "$@"
