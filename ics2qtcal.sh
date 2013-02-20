#!/bin/sh
# Interpret command line options
while getopts v option
do	case "$option" in
	v)	verbose="-v";;
	[?])	print >&2 "Usage: $0 [-v] file sqlite_file\n(files with absolute paths)"
		exit 1;;
	esac
done
shift `expr $OPTIND - 1`

icsfile="$1"
caldb="$2"

if [ -n $icsfile ] || [ -n $caldb ]; then
    echo "Creating temporary copy of $icsfile with valid lines into db $caldb"
    # Create a copy and remove X-MOZ-LASTACK lines that are not understood by Tie::iCal
    grep -v X-MOZ-LASTACK "${icsfile}" >"${icsfile}.tmp"
    # Normalize line endings to unix format (line feed only)
    sed -e 's/\r$//g' "${icsfile}.tmp" >"${icsfile}-2.tmp"

    echo "Processing file $icsfile"
    perl ics2qtcal.pl "$verbose" --ical "${icsfile}-2.tmp" --qtopiadb "$caldb" --notesdirectory "./Annotator-tmp"

    echo "Deleting temporary files"
    rm ${icsfile}.tmp
    rm ${icsfile}-2.tmp
else
    echo "ERROR : unable to treat empty files ! Command was (without options) : \n"
    echo "$0 $*"
fi
