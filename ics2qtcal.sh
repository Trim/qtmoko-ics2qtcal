# Interpret command line options
while getopts v option
do	case "$option" in
	v)	verbose="-v";;
	[?])	print >&2 "Usage: $0 [-v] file sqlite_file"
		exit 1;;
	esac
done
shift `expr $OPTIND - 1`

echo "Creating temporary copy of $1 with valid lines"

# Create a copy and remove X-MOZ-LASTACK lines that are not understood by Tie::iCal
grep -v X-MOZ-LASTACK $1 >$1.tmp
# Normalize line endings to unix format (line feed only)
sed -e 's/\r$//g' $1.tmp >$1-2.tmp
echo "Processing file $1"
perl ics2qtcal.pl $verbose --ical $1-2.tmp --qtopiadb $2 --notesdirectory ./Annotator-tmp


echo "Deleting temporary files"
rm $1.tmp
rm $1-2.tmp
