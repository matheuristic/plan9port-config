#!/usr/bin/env sh

# Note than for a typical installation, PLAN9 is usually /usr/local/plan9
export PLAN9=$HOME/packages/plan9port
export PATH=$PATH:$PLAN9/bin

if command -v rlwrap >/dev/null 2>&1; then
  rlwrap "$PLAN9/bin/rc" "$@"
else
  "$PLAN9/bin/rc" "$@"
fi
