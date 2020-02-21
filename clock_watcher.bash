#!/bin/bash
#filename: clock_watcher.bash
#description: tells how many hours we have been working for time reporting puposes. 

declare -i lunch
lunch=3600/2

echo Clock Watcher

echo calculate time worked
#echo lunch is ${lunch} seconds.

convert_time_to_hours() {
 # Convert the times to seconds from the Epoch
 SEC1=`date +%s -d ${TIME1}`
 SEC2=`date +%s -d ${TIME2}`
 LUNCH_TIME_SEC=`date +%s --date "12:00"`

 echo Start ${TIME1}
 echo Current Time ${TIME2}

#Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
echo "if the time is after 12:00 subtract $lunch seconds for lunch"
if [[ ${TIME2_SEC} -lt ${LUNCH_TIME_SEC} ]]; then
  echo "... lunch has not passed not subtracting lunch time"
  DIFFSEC=`expr ${SEC2} - ${SEC1} `
else
  echo "... lunch passed subtracting 30 minutes"
  DIFFSEC=`expr ${SEC2} - ${SEC1} `
  DIFFSEC=`expr ${DIFFSEC} - ${lunch} `
fi

 echo Time elapased ${DIFFSEC} seconds.

 # And use date to convert the seconds back to something more meaningful
 echo Time worked is `date +%H:%M:%S -ud @${DIFFSEC}`
}

clear
start_time=$1
TIME1=07:00:00
TIME2=`date +%H:%M:%S`
TIME2_SEC=`date +%s --date "now"`

if [[ -n "$start_time" ]]; then
  TIME1=$start_time
  echo $TIME1
else
  echo "using default $TIME1"
fi

convert_time_to_hours
