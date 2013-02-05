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

echo "Fetching qtopia_db.sqlite from FreeRunner"
scp root@192.168.0.202:/home/root/Applications/Qtopia/qtopia_db.sqlite .
echo "Fetching files"
for fileurl in $*
do
	wget --no-check-certificate --timestamping --user=$user --password=$password $fileurl
done
echo "Making a backup copy of qtopia_db"
cp qtopia_db.sqlite qtobia_db.sqlite.bak
echo "Deleting appointments of qtopia_db"
perl deleteqtcalappointments.pl qtopia_db.sqlite
echo "Deleting temporary Notes files from a previous execution"
rm Annotator-tmp/*
mkdir Annotator-tmp
echo "Transferring events to qtopia_db"
for filename in ./*.ics
do
	./ics2qtcal.sh $verbose $filename ./qtopia_db.sqlite
done;
echo "Transferring qtopia_db.sqlite back to the FreeRunner"
scp qtopia_db.sqlite root@192.168.0.202:/home/root/Applications/Qtopia/
echo "Removing existing Note files on the FreeRunner"
ssh root@192.168.0.202 "rm -f /home/root/Applications/Annotator/0-*"
echo "Transferring Note files to the FreeRunner"
scp -q Annotator-tmp/* root@192.168.0.202:/home/root/Applications/Annotator/
echo "Done"
