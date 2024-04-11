#!/usr/bin/env sh

# Echos to screen the plan9port namespaces in which there is an active
# Acme session, where the current one is indicated with '*'

for nsfull in /tmp/ns.$USER.*; do
	nspart=`basename $nsfull`
	if NAMESPACE=$nsfull 9 9p ls acme >/dev/null 2>&1; then
		if [ "$(namespace)" = "$nsfull" ]; then
			echo "* $nspart"
		else
			echo "  $nspart"
		fi
	fi
done
