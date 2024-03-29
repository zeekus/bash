#!/bin/bash
#description: date time commands and thier syntax
#filename: generic_reference_date_time.sh

###############################
# Time zone examples
###############################

#print date/time with different timezone
TZ='America/New_York'; current_date=$(date)
echo the current date is $current_date
#Tue Feb 25 07:16:41 EST 2020

#LA TIME
TZ='America/Los_Angeles' date

#################################
#LOGGING Examples
#################################

#for apache logs:
date +%m_%d_%Y_%H%M
#Output: 02_22_2020_0041

#message logs use this type of date
date -d  yesterday +%b" "%-d #note minus removes 0 or space 
grep -i "$(date -d yesterday +%b"  "%-d)" /var/log/messages #to view log entries from yesterday

echo "yesterday in apache log format"
yesterday=`date +%d/%b/%Y -d -yesterday`
echo $yesterday

echo "yesterday in shell format for document home dirs CM/ECF"
yesterday=`date +%Y%m%d -d -yesterday`
echo $yesterday

#################################
#date now 
#################################

date -d now


#################################
#Display current week
#################################

echo "Find current: Week number"
#echo Week number: 33 Year: 10
date +"Week number: %V Year: %y"

#################################
#Display with common English
#################################

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

echo "next day"
date -d next-day

echo "next month"
date -d next-month

echo "next year"
date -d next-year

echo "last year"
date -d last-year


#################################
#Future date Examples
#################################

#60days from a specific day
date -d "2020-12-29 +60 days"
#Output: Sat Feb 27 00:00:00 EST 2021

#60days from now
date -d "+60 days"

#start time: Wed Jul  7 08:35:06 EDT 2021 hours until future date
echo $((($(date +%s --date "July 14 2021")-$(date +%s))/(60*60))) hours
#Output: 159 hours

#days until future date
echo $((($(date +%s --date "July 14 2021")-$(date +%s))/(60*60*24))) days
#Output: 6 days

#find time 6 hours from now
date --date "+$(( 6 * 60 )) minutes" +"%D %l:%M:%S"
date -d "+6 hours"
#output 02/22/20  00:43:07

#find time from a specific time
date -d "Nov 16 2021 07:00:00 AM +7 hours"
Tue Nov 16 14:00:00 EST 2021

#find time 3 weeks from  today
date -d 'now + 3 weeks' 

#find time 3 weeks from Christmas
date -d "2021-12-25 + 3 weeks"
#Output: Sat Jan 15 00:00:00 EST 2022

#find days until Christmas
echo $((($(date +%s --date "07:00:00 Dec 25 2021")-$(date +%s))/(60*60*24))) day
#Output: 38 days

#find date 147 days ago
date -d 'now - 147 days' 

#time in 30 minutes
date -d 'now + 30 minutes'

#time in 30 hours
date -d 'now + 30 hours'

#time in 30 days
date -d 'now + 30 days'

#time in 30 years
date -d 'now + 30 years'

echo "days that passed since 1999-12-28"
echo $((($(date +%s)-$(date +%s --date "1999-12-28"))/(3600*24))) days

echo "years that passed since 1999-12-28"
echo $((($(date +%s)-$(date +%s --date "1999-12-28"))/(3600*24*365))) years

echo "mins from 16:30 today"
#415 min
echo $((($(date +%s --date "16:30")-$(date +%s))/(60))) min

#Hours until a specific tme
echo $((($(date +%s --date "16:30")-$(date +%s))/(60*60))) hours

#date from a specific time
date -d '00:00:00 May 14 1905 + 84 years + 30 days'
#result Tue Jun 13 00:00:00 EDT 1989

#day 1000 years ago
date -d 'now -1000 years'
#result Thu Apr 18 07:42:10 LMT 1022

