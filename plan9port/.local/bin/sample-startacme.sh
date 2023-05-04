#!/usr/bin/env sh

# Sample wrapper file that launches Acme from environments without the Plan 9
# from User Space (i.e., plan9port) bin directory in their search path. It is
# recommended to copy this file to ~/.local/bin/startacme.sh and customize it
# with the desired default settings.
#
# It is good practice to make sure the PLAN9 environment variable is set and
# $PLAN9/bin is in $PATH which is not always the case if the script is called
# from a desktop menu item in Linux or a launcher app in macOS. The following
# shows how to do this assuming that plan9port is installed at the directory
# $HOME/.local/plan9port (change as appropriate).
#
#    if [ -z "$PLAN9" ]; then
#        export PLAN9="$HOME/.local/plan9port"
#        export PATH=$PATH:$PLAN9/bin
#    fi
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
#    $PLAN9/bin/rc $HOME/.local/bin/startacme.rc $startparams
#
# The following code simplifies launching of multiple Acme instances,
# enabling the script to take an optional '-n N' flag that launches
# Acme in a given namespace /tmp/ns.$USER.N (note that the -n flag
# must be the first option specified when running the script).
#
#    if [ "$1" = "-n" ]; then
#        export NAMESPACE=/tmp/ns.$USER.$2
#        mkdir -p "$NAMESPACE"
#        shift; shift
#    fi
#
# For example, 'acme.sh -n myproject' launches an Acme instance in the
# /tmp/ns.$USER.myproject namespace.
#
# The following variant, which requires a patched Acme where the '-t' option
# sets the window title, also sets the window title to the provided namespace.
#
#     titleparams=""
#     if [ "$1" = "-n" ]; then
#         if [ -z "$2" ]; then
#             echo "-n specified but namespace not provided" 1>&2
#     	exit 1
#         fi
#         export NAMESPACE=/tmp/ns.$USER.$2
#         mkdir -p "$NAMESPACE"
#         titleparams="-t $2"
#         # Uncomment below line if to maintain a cleaner /tmp/ directory
#         # (the /tmp/ directory gets cleaned on reboots in any case)
#         # trap 'rm -rf "$NAMESPACE"' EXIT
#         shift; shift
#     fi
#     # ...
#     acme $titleparams
#
# Note the default namespace and title are /tmp/ns.$USER.$DISPLAY and "acme".
#
# Example script code incorporating all elements above.
#
#    if [ -z "$PLAN9" ]; then
#        export PLAN9="$HOME/.local/plan9port"
#        export PATH=$PATH:$PLAN9/bin
#    fi
#    titleparams=""
#    if [ "$1" = "-n" ]; then
#        if [ -z "$2" ]; then
#            echo "-n specified but namespace not provided" 1>&2
#    	exit 1
#        fi
#        export NAMESPACE=/tmp/ns.$USER.$2
#        mkdir -p "$NAMESPACE"
#        titleparams="-t $2"
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
#        $PLAN9/bin/rc $HOME/.local/bin/startacme.rc \
#        -f /lib/font/bit/lucsans/unicode.13.font -F /mnt/font/GoMono/18a/font \
#        $titleparams \
#        $startparams

if [ -z "$PLAN9" ]; then
    export PLAN9=/usr/local/plan9port
    export PATH=$PATH:$PLAN9/bin
fi
$PLAN9/bin/rc $HOME/.local/bin/startacme.rc "$@"
