#!/usr/bin/env sh

# Sample ~/.local/bin/startacme.sh for macOS for launching Acme
# If plumbing web URLs does not work, set environment var BROWSER=none

set -e

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
if ! $(echo "$PATH" | grep "$HOME/.acme/bin" >/dev/null 2>&1); then
	export PATH=$HOME/.acme/bin:$PATH
fi
titleparams=""
if [ "$1" = "-N" ]; then
	j=0
	while [ $j -lt 10 ]; do
		if ! $(NAMESPACE="/tmp/ns.$USER.$j" 9p ls acme >/dev/null 2>&1); then
			break
		fi
		j=$(( j + 1 ))
	done
	if [ $j -ge 10 ]; then
		echo "All supported namespace numbers 0 through 9 have a running Acme." >&2
		exit 1
	fi
	export NAMESPACE="/tmp/ns.$USER.$j"
	[ -d "$NAMESPACE" ] || mkdir -p "$NAMESPACE"
	titleparams="-t acme-$j"
	# Uncomment below line if to maintain a cleaner /tmp/ directory
	# (the /tmp/ directory gets cleaned on reboots in any case)
	# trap 'rm -rf "$NAMESPACE"' EXIT
	shift;
fi
startparams="$@"
startfile=$HOME/.acme/start
if [ "$startparams" = "" ]; then
	if [ -f "$startfile" ]; then
		startparams="-c 1 $startfile"
	else
		echo "Start file does not exist, skipping load: $startfile" 1>&2
	fi
fi

export acmefonts=$(cat <<EOF
$PLAN9/font/lucsans/unicode.8.font,/mnt/font/LucidaGrande/28a/font
$PLAN9/font/lucsans/boldtypeunicode.7.font,/mnt/font/ComicCode-Medium/26a/font
$HOME/lib/font/uw-ttyp0/t0-18b-uni.font,/mnt/font/PragmataProMono-Regular/32a/font
$HOME/lib/font/cozette/cozette.font,/mnt/font/BQN386/28a/font
EOF
)

visibleclicks=1 SHELL=rc BROWSER='Mullvad Browser' \
	$PLAN9/bin/rc $HOME/.local/bin/startacme.rc \
	-f /lib/font/bit/lucsans/unicode.8.font,/mnt/font/LucidaGrande/28a/font \
	-F /lib/font/bit/lucsans/boldtypeunicode.7.font,/mnt/font/ComicCode-Medium/26a/font \
	$titleparams \
	$startparams
