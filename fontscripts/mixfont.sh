#!/bin/sh

# mixfont.sh
# Mix font weights and styles into a new Plan 9 font file,
# extracting glyphs 0x000000 to 0x00ffff from each specified font
# name and size for the new font.

set -e

# Command-line options
while [ "$#" -gt 0 ]; do
	case $1 in
		-h)
			cat <<EOF
Mix font weights and styles into a one Plan 9 font file.
Intended for use with Acme, afont and atalk. See:
    https://twitter.com/_rsc/status/1285650690891800585
    https://pkg.go.dev/rsc.io/tmp/afont
    https://pkg.go.dev/rsc.io/tmp/atalk

Usage: $(basename $0) [-h] [-o file] name0 size0 name1 size1 name2 size2 ...

    -h shows usage notes and exits
    -o file outputs to the specified file (default: font)
    name<k> is a font name (run "9p ls font" for available fonts)
    size<k> is font size in points (append "a" to antialias, e.g., "28a")

The glyphs for font name<k> at size<k> in range
0x000000 through 0x00ffff are mapped to the range
0x0<k>0000 through 0x<k>ffff in the new font.

The new font height and ascent (i.e., the first line of output file)
are replicated from font name0 at size0.

See "9 man 7 font" for more info.

Example:
    $(basename $0) \
        GoRegular 28a \
        Go-Italic 28a \
        Go-Bold 28a \
        Go-BoldItalic 28a \
        GoMono 28a

	creates a font file that when used in an Acme window with the
	"Font" command, text in the window can be transformed into
	italic by piping text through "|afont 1" , into bold text by
	piping text through "|afont 2" , into bold italic text by
	piping text through "|afont 3" , and into monospace text by
	piping text through "|afont 4" . This is useful to for showing
	presentations in Acme either using "Slide", "Slide+" and
	"Slide-", or using "atalk" (see above).
EOF
			exit 0
			;;
		-o)
			if [ -n "$2" ]; then
				OUTPUTFILE="$2"
				shift; shift
			else
				echo "-d requires a non-empty option argument that is a file path" 1>&2
				exit 1
			fi
			;;
		*)
			break
	esac
done

# Assign default values as needed
OUTPUTFILE=${OUTPUTFILE:-font}

# Check inputs
if [ "$#" -lt 2 ]; then
	echo 'at least one font name and size pair must be provided' >&2
	exit 1
fi

# Create new font file
COUNTER=0
while [ "$#" -gt 0 ]; do
	if [ -z "$2" ]; then
		echo "font $1 specified without a corresponding size" >&2
		exit 1
	fi
	FONTNAME=$1
	FONTSIZE=$2
	shift; shift
	if [ "$COUNTER" -eq 0 ]; then
		fontsrv -p "$FONTNAME/$FONTSIZE/font" \
			| 9 grep -e '^( |0x00)' \
			| 9 awk '
				(NR==1) {
					print $0
				}
				(NR!=1) {
					rangeleft=$1
					rangeright=$2
					fontfile=$3
					sub(/^/, "/mnt/font/'$FONTNAME'/'$FONTSIZE'/", fontfile)
					print rangeleft, rangeright, fontfile
				}' \
			> "$OUTPUTFILE"
	else
		fontsrv -p "$FONTNAME/$FONTSIZE/font" \
			| 9 grep -e '^0x00' \
			| 9 awk '
				{
					rangeleft=$1
					rangeright=$2
					fontfile=$3
					sub(/^0x00/, "0x0'$COUNTER'", rangeleft)
					sub(/^0x00/, "0x0'$COUNTER'", rangeright)
					sub(/^/, "/mnt/font/'$FONTNAME'/'$FONTSIZE'/", fontfile)
					print rangeleft, rangeright, fontfile
				}' \
			>> "$OUTPUTFILE"
	fi
	COUNTER=$((COUNTER + 1))
done
