#!/bin/sh
# Interpret command line options
while getopts vu:p:s: option
do	case "$option" in
	u)	user="$OPTARG";;
	p)	password="$OPTARG";;
	v)	verbose="-v";;
	s)  server="$OPTARG";;
	[?])	print >&2 "Usage: $0 [-v] [-u user] [-p password] [-s serverurl] fileurl1 fileurl2 ..."
		exit 1;;
	esac
done
shift `expr $OPTIND - 1`

# Work in tmpdir
mytmp="/tmp/ics2qtcal-`date +%H%M%S`"
mkdir $mytmp
cd $mytmp

# Main configuration
icaldb="/home/root/Applications/Qtopia/qtopia_db.sqlite"
tmpnotes="./Annotator-tmp"
notes="/home/root/Applications/Annotator/"

# Remote configuration
REMOTE_USER='root'
REMOTE_IP='192.168.0.202'

echo "Fetching qtopia_db.sqlite from FreeRunner"
scp ${REMOTE_USER}@${REMOTE_IP}:${icaldb} .

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

echo "Making a backup copy of qtopia_db"
cp qtopia_db.sqlite qtobia_db.sqlite.bak

#echo "Deleting appointments of qtopia_db"
#perl deleteqtcalappointments.pl qtopia_db.sqlite

echo "Deleting temporary Notes files from a previous execution"
rm ${tmpnotes}/*
mkdir -p ${tmpnotes}

echo "Transferring events to qtopia_db"
for filename in ./*.ics
do
    if [ -n "$verbose" ] ; then
        ics2qtcal.pl -- -v --ical "${filename}" --qtopiadb qtopia_db.sqlite --notesdirectory "$tmpnotes"
    else
        ics2qtcal.pl -- --ical "${filename}" --qtopiadb qtopia_db.sqlite --notesdirectory "$tmpnotes"
    fi
done;

echo "Transferring qtopia_db.sqlite back to the FreeRunner"
scp qtopia_db.sqlite ${REMOTE_USER}@${REMOTE_IP}:/home/root/Applications/Qtopia/

echo "Removing existing Note files on the FreeRunner"
ssh ${REMOTE_USER}@${REMOTE_IP} "rm -f ${notes}0-*"

echo "Transferring Note files to the FreeRunner"
scp -q Annotator-tmp/* ${REMOTE_USER}@${REMOTE_IP}:${notes}

echo "Removing *.ics local files"
rm *.ics

echo "Done"
