# Interpret command line options
while getopts vu:p: option
do	case "$option" in
	u)	user="$OPTARG";;
	p)	password="$OPTARG";;
	v)	verbose="-v";;
	[?])	print >&2 "Usage: $0 [-v] [-u user] [-p password] fileurl1 fileurl2 ..."
		exit 1;;
	esac
done
shift `expr $OPTIND - 1`

echo "Creating a backup copy of qtopia_db.sqlite"
cp /home/root/Applications/Qtopia/qtopia_db.sqlite ./qtopia_db.sqlite.bak

echo "Fetching files"
for fileurl in $*
do
	wget --no-check-certificate --timestamping --user=$user --password=$password $fileurl
done

echo "Deleting appointments of qtopia_db"
perl deleteqtcalappointments.pl /home/root/Applications/Qtopia/qtopia_db.sqlite

echo "Deleting temporary Notes files from a previous execution"
rm Annotator-tmp/*
mkdir Annotator-tmp

echo "Transferring events to qtopia_db"
for filename in ./*.ics
do
	./ics2qtcal.sh $verbose $filename /home/root/Applications/Qtopia/qtopia_db.sqlite
done;
echo "Removing existing Note files"
rm -f /home/root/Applications/Annotator/0-*

echo "Copying Note files"
cp Annotator-tmp/* /home/root/Applications/Annotator/
echo "Done"
