#!/bin/sh

# Apply all patches in the current directory to a plan9port repository

set -e

# Check inputs
if [ "$#" -eq 0 ]; then
	echo "Usage: $(basename $0) /path/to/plan9port/repository" 1>&2
	exit 1
fi

REPOSITORYROOT=$1
echo "using plan9port repository at $REPOSITORYROOT"

# Cache patch files
PATCHFILES=$(ls $PWD/*.patch)

# Switch to plan9port repository root
echo "changing directory to $REPOSITORYROOT"
cd "$REPOSITORYROOT"

# Apply patches in lexicographic sequence
echo "applying patches..."
for p in $PATCHFILES; do
	echo "    $p"
	patch -p1 < "$p"
done
echo "done"
