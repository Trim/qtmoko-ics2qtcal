#!/bin/sh
# Interpret command line options
while getopts vu:p:s: option
do	case "$option" in
	u)	user="$OPTARG";;
	p)	password="$OPTARG";;
	v)	verbose="-v";;
	s)	server="$OPTARG";;
	[?])	print >&2 "Usage: $0 [-v] [-u user] [-p password] [-s serverurl] fileurl1 fileurl2 ..."
		exit 1;;
	esac
done
shift `expr $OPTIND - 1`

echo "Creating a backup copy of qtopia_db.sqlite"
cp /home/root/Applications/Qtopia/qtopia_db.sqlite ./qtopia_db.sqlite.bak

echo "Fetching files"
for fileurl in $*
do
    # We force the output to have .ics extension to simplify next for loop
    if [ -z "$server" ]; then
	    wget --no-check-certificate --user="$user" --password="$password" "$fileurl" -O "`basename ${fileurl%%.ics}`_`date +%Y%m%d_%H%M%S`.ics"
	else
	    wget --no-check-certificate --user="$user" --password="$password" "${server}/${fileurl}" -O "`basename ${fileurl%%.ics}`_`date +%Y%m%d_%H%M%S`.ics"
	fi
done

echo "Deleting appointments of qtopia_db"
perl deleteqtcalappointments.pl /home/root/Applications/Qtopia/qtopia_db.sqlite

echo "Deleting temporary Notes files from a previous execution"
rm ./Annotator-tmp/*
mkdir -p Annotator-tmp

echo "Transferring events to qtopia_db"
for filename in ./*.ics
do
	./ics2qtcal.sh "$verbose" "$filename" /home/root/Applications/Qtopia/qtopia_db.sqlite
done;
echo "Removing existing Note files"
rm -f /home/root/Applications/Annotator/0-*

echo "Copying Note files"
cp ./Annotator-tmp/* /home/root/Applications/Annotator/
echo "Done"
