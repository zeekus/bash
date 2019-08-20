#!/bin/bash
#filename: espeak_alarm.sh
#author: Teddy Knab
#date: 19 August 2019
#######################################
#description: alarm countdown with espeak
#######################################

debug_state=0
#debug_state=1

check_for_espeak() {
   test -e "/usr/bin/espeak"
   if [ $? == 0 ] ; then
     printf "We found espeak. running '$0'\n"
   else
     printf "Sorry. No espeak found.\n"
     printf "This program requires the espeak binary to run. Exiting...\n"
     exit 2
   fi
}

alarm_is_ringing() {
  while true; do
    echo "Wake up. The alarm is going off." | espeak -a 500 -p 1
    date +"The time is %l:%M%p" | espeak -a 500 -p 1
    echo -n "Press SPACE to end or Ctrl+C to exit ... "
    echo ""
    read -n1 -r -t 1
    [[ $REPLY == ' ' ]] && break
  done
  echo
  echo "exiting..."
}

check_for_espeak
alarm=$1 #alarm variable in minutes
time_at_end_of_alarm=$(date --date="+$alarm minutes" +"%l:%M")

if [ $debug_state -eq 1 ] ;then
 printf "Debug: the alarm is set for '$alarm'\n" 
 printf "Debug: The end time is '$time_at_end_of_alarm'\n"
fi

#######################################
#### check to make sure number was set for the alarm
#######################################
if [[ $alarm = '' ]] ; then 
  #empty variable
  echo "use: '$0 [minutes]' "
  exit 1
elif [ $alarm -lt 1 ] ; then
  echo "use $0 minutes > 0 "
else
  if [ $debug_state -eq 1 ] ;then
     echo "We got the expected data value of '$1'"
  fi
fi

#######################################
#### Wait 15 seconds for time to pass
#######################################
until [[ $current_time = $time_at_end_of_alarm ]] 
do 
 current_time=$(date +"%l:%M")

 if [ $debug_state -eq 1 ] ;then
  echo "The current time is '$current_time' is not equal to the '$time_at_end_of_alarm'"
  echo "sleeping 5 ..."
 fi 
 sleep 5 
done

alarm_is_ringing
