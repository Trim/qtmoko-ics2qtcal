#
# Regular cron jobs for the qtmoko-ics2qtcal package
#
0 4	* * *	root	[ -x /usr/bin/qtmoko-ics2qtcal_maintenance ] && /usr/bin/qtmoko-ics2qtcal_maintenance
