#!/bin/bash
#filename: get_top_100_largest_dirs.sh
#get a list of the top 100 largest directories in home with a low threshold of 1GB
#sort data in reverse order with the highest number first
du -ah -t 1G /home | sort -r -n  | head -100 

#find disk space on each user in the home dir
find /home -maxdepth 1 -exec du -hs {} ';'

#get a list of all the rpms,the install date, and version 
rpm -qa --qf '(%{INSTALLTIME:date}): %{NAME}-%{VERSION}\n' > /var/tmp/installed_rpm_list.txt

#get all the installed rpms
rpm -qa

#get the yum repos in use
yum repolist






