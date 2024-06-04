#!/usr/bin/env sh

# Wrapper script to launch Sam from environments without the Plan 9 bin
# directory in their search path

# It is recommended to copy this file to ~/.local/bin/sam.sh and configure the
# launch command with the appropriate font environment variable, e.g.
#    font=/mnt/font/GoMono/16a/font sam.sh \
#        $PLAN9/bin/rc $HOME/.local/bin/startsam.rc "$@"

if [ -z "$PLAN9" ]; then
	if [ -d "$HOME/.local/plan9" ]; then
		export PLAN9=$HOME/.local/plan9
		export PATH=$PATH:$PLAN9/bin
	elif [ -d "/usr/local/plan9port" ]; then
		export PLAN9=/usr/local/plan9port
		export PATH=$PATH:$PLAN9/bin
	else
		echo "PLAN9 undefined and plan9port install not found at /usr/local/plan9 or $HOME/.local/plan9" >&2
		exit 1
	fi
fi
$PLAN9/bin/rc $HOME/.local/bin/startsam.rc "$@"
