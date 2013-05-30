What about qtmoko-ics2qtcal ?
===

This program transfers the content of ical files (.ics) into the [QtMoko's calendar](http://qtmoko.sourceforge.net).
It has been reported to work on a Google Calendar private URL, an Office Online calendar and with Davical calendar.

It currently does not have any user-interface (but will have soon see Trim/getcal repo), and is written with a mix of Perl and shell script.
We aren't expert in those languages : the code can probably be improved (suggestions and help are welcome!) and the ical RFC isn't completed (but feature demands and bug reports are welcome).

How can I use it ?
===

It can run on a standard computer, or on the phone itself.
In current version, it downloads one ore several .ics files through HTTP(S), and stores their content into the SQLite database (/home/root/Applications/Qtopia/qtopia_db.sqlite , __replacing__ and removing existing appointments).
It also creates the Note files for each appointment description, in the directory where they are expected by QtMoko : /home/root/Applications/Annotator/

Usage on QtMoko (tested on v52):
- Copy all the files in a directory of your phone (you can use git clone if you've install git or [download zip file](https://www.adorsaz.ch/public/downloads/qtmoko-ics2qtcal/))
- Install the necessary Perl packages by running install_dependencies.sh on the phone
- Run the script sync4ics2openmoko.sh [-u user] [-p password] [-s serverurl] fileurl1 fileurl2 ...
The optional user/password is given to the HTTP server if it needs authentication

Examples :
- sync4ics2openmoko.sh (will parse all local files with extension .ics)
- sync4ics2openmoko.sh -u 'myuser' -p 'mypassword' -s https://myserver/mypath/ myfile1 myfile2 myfile3 
- sync4ics2openmoko.sh -u 'myuser' -p 'mypassword' -s https://myserver/ mypath1/myfile1 mypath1/myfile2 anotherpath/myfile3 

Usage on a standard computer (tested on Ubuntu 10.04) : same steps, except that you need to use remotesync4ics2openmoko.sh instead and connect your phone with IP 192.168.0.202.

How does it work ?
===

* ics2qtcal.pl is where the hard job is done. This script has several options and you can use it alone
* sync4ics2openmoko.sh and remotesync4ics2openmoko.sh automate the operations described above. They are targeted on my own usage, but you can modify them if you wish.

Sources
===

Idea taken from [openmoko wiki](http://wiki.openmoko.org/wiki/PIM_Storage#Import.2FExport_of_Calendar_Data_for_PIM-Storage) by Niebert. 
[Original application](http://mossroy.free.fr/ics2qtcal/) from Mossroy 
Some code inspired or copied from [http://cpansearch.perl.org/src/BSDZ/Tie-iCal-0.14/samples/outlooksync.pl](cpan)
The [iCal RFC](http://www.faqs.org/rfcs/rfc2445.html) implementation is quite incomplete in this script, but it covers the most common options

Suggestions/bugs
===

Please send any suggestion/bug report to mossroy.mossroy AT gmail DOT com , adrien AT adorsaz DOT ch or use github tools
You can give small donations through [our Flattrhttps](http://flattr.com/thing/104780/ics2qtcal-Perl-script-to-synchronize-ics-files-with-QtMoko-calendar-on-a-FreeRunner)

License
===

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
