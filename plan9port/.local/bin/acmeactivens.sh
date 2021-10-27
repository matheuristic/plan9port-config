#!/usr/bin/env sh

# Echos to screen the plan9port namespaces in which there is an active
# Acme session

for nsfull in /tmp/ns.$USER.*; do
  nspart=`basename $nsfull`
  if NAMESPACE=$nsfull 9 9p ls acme >/dev/null 2>&1; then
    echo $NAMESPACE $nspart
  fi
done
