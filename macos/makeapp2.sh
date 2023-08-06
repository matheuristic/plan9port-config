#!/bin/sh

# Creates macOS Acme.app in target directory

# Set $APPDIR to specify path to the Applications folder (defaults to ~/Applications)
# Set $PLAN9 to specify path to the plan9port repository (defaults to /usr/local/plan9)
# Set $STARTACMEPATH to specify path to acme command or start script (defaults to ~/.local/bin/startacme.sh)

# Requirements:
# - The acme start script supports or command is patched to support the '-N'
#   option to start Acme in a new namespace, so there can be multiple instances

set -e

APPDIR=${APPDIR:-"$HOME/Applications"}
PLAN9=${PLAN9:-"/usr/local/plan9"}
STARTACMEPATH=${STARTACMEPATH:-"$HOME/.local/bin/startacme.sh"}

# Derived variables
APPBUNDLE="${APPDIR}/Acme.app"
ACMEICONPATH="$PLAN9/mac/spaceglenda.icns"

# Check Applications directory exists
if [ ! -d "$APPDIR" ]; then
	echo "Applications directory does not exist: $APPDIR" >&2
	exit 1
fi

# Check if Acme.app already exists
if [ -e "$APPBUNDLE" ]; then
	echo "${APPBUNDLE} already exists. Remove before recreating." >&2
	exit 1
fi

# Check needed plan9port repository files exist
if [ ! -f "$ACMEICONPATH" ]; then
	echo "plan9port repository not installed: $PLAN9" >&2
	echo 'Specify path by calling this script with PLAN9=/path/to/plan9port/repository' >&2
	exit 1
fi

# Check if launch command or script exists
if [ ! -x "$STARTACMEPATH" ]; then
	echo "Acme launch command or script not installed: $STARTACMEPATH" >&2
	exit 1
fi

WORKDIR=$(mktemp -d)
echo "Created work directory: ${WORKDIR}"

function cleanup() {
	echo "Cleaning up and removing work directory: ${WORKDIR}"
	rm -rf "${WORKDIR}"
}

trap cleanup EXIT

WORKSCRIPT="${WORKDIR}/Acme.scpt"

echo "Creating launch script: ${WORKSCRIPT}"
cat >"${WORKSCRIPT}" <<EOF
do shell script "zsh -i -c '${STARTACMEPATH} -N >/dev/null 2>&1' &"
EOF

echo "Creating application: ${APPBUNDLE}"
osacompile -l "Generic Scripting System" -o "${APPBUNDLE}" "${WORKSCRIPT}"
plutil -replace CFBundleIdentifier -string com.github.9fans.plan9port.Acme "${APPBUNDLE}/Contents/Info.plist"
plutil -replace CFBundleName -string Acme "${APPBUNDLE}/Contents/Info.plist"
plutil -replace CFBundlePackageType -string APPL "${APPBUNDLE}/Contents/Info.plist"

APPLETICONPATH="${APPBUNDLE}/Contents/Resources/applet.icns"
echo "Overwriting generic icon ${APPLETICONPATH} with Acme icon ${ACMEICONPATH}"
rm -f "${APPLETICONPATH}"
cp -a "${ACMEICONPATH}" "${APPLETICONPATH}"

echo "All done, it is recommended to add (by dragging) Acme.app to the macOS Dock"

echo "---"
echo "NOTE: Acme.app assumes the acme launch script or command supports the '-N' option"
echo "      for starting Acme in a new namespace for multiple running instances"
