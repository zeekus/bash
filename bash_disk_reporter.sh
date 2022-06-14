#!/bin/bash
#filename: bash_disk_reporter.sh
#description: create a simple report of what folders have the data.
TZ='America/New_York'
current_date=$(date +%Y-%m-%d)
myfolder="/modeling"
echo $current_date
write_folder="/var/tmp"
email_destination"myemail@example.net"
filename="$write_folder/disk_report_$current_date.txt"
echo "filename: $filename"
if [[ -e "$write_folder" ]]; then
  echo "****************************************************" >  $filename
  echo "date: $current_date" >> $filename
  echo "subject: disk report from $myfolder" >> $filename
  echo "full report: $filename" >>  $filename
  echo "****************************************************" >>  $filename
  du -ah -t 1G $myfolder| sort -r -n  >> $filename
  #send email if mutt exists
  if [[ -e "/usr/bin/mutt" ]]; then
    #note the ~/.muttrc will hold the sender info minumum as follows
    #set realname = "My Name"
    #set from = "root@myhost.example.net"
    cat $filename | head -n 50 | mutt -s "disk report from $myfolder" $email_destination -a $filename #file is an attachment
  fi
else
  echo "error we can't find $write_folder"
fi