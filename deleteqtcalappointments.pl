#!/usr/bin/perl

use DBI;
use strict;

main:
{
	my $dbname = $ARGV[0];
	my $dbargs = {AutoCommit => 0,
			PrintError => 1};

	# Connect to the Qtopia database
	my $dbh = DBI->connect("dbi:SQLite:dbname=$dbname","","",$dbargs);
	if ($dbh->err()) { die "$DBI::errstr\n"; }

	# Remove previous appointments
	$dbh->do("DELETE FROM APPOINTMENTS;");
	$dbh->do("DELETE FROM APPOINTMENTCUSTOM;");

	if ($dbh->err()) { die "$DBI::errstr\n"; }
	# Commit and close Qtopia database
	$dbh->commit();
	$dbh->disconnect();
}
