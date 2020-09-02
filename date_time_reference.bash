#!/bin/bash
#description: date time commands and thier syntax

#print date/time with differnt timezone
TZ=America/New_York date
Tue Feb 25 07:16:41 EST 2020

#message logs use this type of date
date -d  yesterday +%b" "%-d #note minus removes 0 or space 
grep -i $(date -d yesterday +%b" "%-d) /var/log/messages #to view log entries from yesterday 

#for apache logs:
date +%m_%d_%Y_%H%M

#find time 6 hours from now
date --date "+$(( 6 * 60 )) minutes" +"%D %l:%M:%S"

#find time 3 weeks from  today
date -d 'now + 3 weeks' 

#fine date 147 days ago
date -d 'now - 147 days' 

#time in 30 minutes
date -d 'now + 30 minutes'

echo "Week number"
#echo Week number: 33 Year: 10
date +"Week number: %V Year: %y"

echo "now"
#echo Wed Aug 18 16:47:31 EDT 2010
date -d now

echo "today"
#Wed Aug 18 16:47:32 EDT 2010
date -d today

echo "yesterday"
#Tue Aug 17 16:47:33 EDT 2010
date -d yesterday

echo "tomorrow"
#Thu Aug 19 16:46:34 EDT 2010
date -d tomorrow

echo "sunday"
#Sun Aug 22 00:00:00 EDT 2010
date -d sunday

echo "last Sunday"
#Sun Aug 15 00:00:00 EDT 2010
date -d last-sunday

echo "7000 days from 1999-12-28"
echo $((($(date +%s)-$(date +%s --date "1999-12-28"))/(3600*24))) days

echo "mins from 16:30"
#415 min
echo $((($(date +%s --date "16:30")-$(date +%s))/(60))) min

#6 hours
echo $((($(date +%s --date "16:30")-$(date +%s))/(60*60))) hours

echo "yesterday in apache log format"
yesterday=`date +%d/%b/%Y -d -yesterday`
echo $yesterday

echo "yesterday in shell format for document home dirs CM/ECF"
yesterday=`date +%Y%m%d -d -yesterday`
echo $yesterday


