#!/bin/sh

# Creates macOS Acme.app in ~/Applications/
# Set $PLAN9 to specify path to the plan9port repository (defaults to /usr/local/plan9)
# Set $APPDIR to specify path to the Applications folder (defaults to ~/Applications)

PLAN9=${PLAN9:-/usr/local/plan9}
APPDIR=${APPDIR:-"$HOME/Applications"}

ICONPATH="$PLAN9/mac/spaceglenda.icns"
STARTACMEPATH="$HOME/.local/bin/startacme.sh"

# Check needed plan9port repository files exist
if [ ! -f "$ICONPATH" ]; then
	echo "plan9port repository not installed at $PLAN9" >&2
	echo 'Specify path by calling this script with PLAN9=/path/to/plan9port/repository' >&2
	exit 1
fi

# Check if launcher script exists
if [ ! -x "$STARTACMEPATH" ]; then
	echo "Acme shell launcher script not installed at $STARTACMEPATH" >&2
	exit 1
fi

# Create application directory structure
echo "Creating application at $APPDIR/Acme.app"
mkdir -p "$APPDIR/Acme.app/Contents"
cd "$APPDIR/Acme.app/Contents"
mkdir -p MacOS
mkdir -p Resources

# Create Info.plist, see https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
echo "Creating $APPDIR/Acme.app/Contents/Info.plist"
cat >Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>CFBundleExecutable</key>
	<string>acme</string>
	<key>CFBundleIconFile</key>
	<string>spaceglenda.icns</string>
	<key>CFBundleIdentifier</key>
	<string>com.github.9fans.plan9port.Acme</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>Acme</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0.0</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>1.0.0</string>
</dict>
</plist>
EOF

# Create app launch script
echo "Creating $APPDIR/Acme.app/Contents/MacOS/acme"
cat >MacOS/acme <<EOF
#!/bin/zsh
$STARTACMEPATH
EOF
chmod +x MacOS/acme

# Create PkgInfo, see https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/ConfigApplications.html
echo "Creating $APPDIR/Acme.app/Contents/PkgInfo"
cat >PkgInfo <<EOF
APPL????
EOF

# Copy icon from plan9port repository
echo "Copying $ICONPATH -> $APPDIR/Acme.app/Contents/Resources/spaceglenda.icns"
cp -a "$ICONPATH" Resources/spaceglenda.icns

echo "All done, it is recommended to add Acme.app to the macOS Dock."
