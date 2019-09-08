#!/bin/bash
#filename: espeak_alarm.sh
#author: Teddy Knab
#date: 07 September 2019
#######################################
#description: alarm countdown with espeak
#######################################

debug_state=0
debug_state=1
use_seconds=1 #use seconds instead of minutes

##################
check_for_espeak() {
##################
   test -e "/usr/bin/espeak"
   if [ $? == 0 ] ; then
     echo "We found espeak. running '$0'"
   else
     echo "Sorry. No espeak found.\n"
     echo "This program requires the espeak binary to run. Exiting..."
     exit 2
   fi
}

##################
alarm_is_ringing() {
##################
  end_of_alarm1=$(date +"%s") #time of alarm begin
  while true; do
    echo "Wake up. The $alarm_type alarm is going off." | espeak -a 500 -p 1
    date +"The time is %l:%M%p" | espeak -a 500 -p 1
    echo -n "Press SPACE to end or Ctrl+C to exit ... "
    echo ""
    read -n1 -r -t 1
    [[ $REPLY == ' ' ]] && break
  done
  echo
  echo "exiting..."

  #end of alarm message
  ##################
  end_of_alarm2=$(date +"%s") #time at which space bar was pressed
  seconds=$(( $end_of_alarm2 - $end_of_alarm1 ))
  if [ $seconds -gt 30 ] ; then 
    echo "It took $seconds seconds for you to respond to this alarm. Please do better next time." | espeak -a 500 -p 1
  elif [ $seconds -gt 15 ] ; then
    echo "You made me wait $seconds seconds. But, I still love you." | espeak -a 500 -p 1
  else
    echo "Thanks for pressing the button in $seconds. You rock." | espeak -a 500 -p 1
  fi
}

##################
alarm_help() {
##################
  echo "use: '$0 [minutes]' "
  echo "use: '$0 -b #for break"
  echo "use: '$0 -b #for lunch"
  exit 0
}

#######################################
check_for_espeak #check for espeak or exit
#######################################

alarm=$1 #alarm variable in minutes is an argument
alarm_type="standard"

#######################################
#### INPUT Section
#######################################
if [[ $alarm = '' || $alarm < 1 ]] ; then 
  #empty variable processed 
  alarm_help #send help 
  exit 1
elif [[ $alarm = 'b' ]] ;then
  alarm=14
  alarm_type="break"
  echo "using '$alarm' minutes for '$alarm_type'"
elif [[ $alarm = 'l' ]] ;then
  alarm=29
  alarm_type="lunch"
  echo "using '$alarm' minutes for '$alarm_type'"
elif [[ $alarm = '-h' ]]; then
  alarm_help #send help 
else
  alarm_type=""
  if [ $debug_state -eq 1 ] ;then
     echo "We got the expected data value of '$1'"
  fi
fi

#############
#setting alarm
#############
current_time=$(date +"%s")
if [ $use_seconds == 1 ] ; then  
  time_at_end_of_alarm=$(date --date="+$alarm seconds" +"%s")
  hr_time_at_end_of_alarm=$(date --date="+$alarm seconds" +"%l:%M:%S")
else
  if [ $alarm_type = 'standard' ]; then
    time_at_end_of_alarm=$(date --date="+$alarm minutes" +"%s")
    hr_time_at_end_of_alarm=$(date --date="+$alarm minutes" +"%l:%M:%S")
  else
    echo "...adding 30 seconds to non standard alarm"
    time_at_end_of_alarm=$(date --date="+$alarm minutes +30 seconds" +"%s")
    hr_time_at_end_of_alarm=$(date --date="+$alarm minutes +30 seconds" +"%l:%M:%S")
  fi
fi

if [ $debug_state -eq 1 ] ;then
 echo "Debug: the alarm is set for '$alarm'" 
 myt=$(date +"%s")
 echo "Debug: the current time is '$myt'"
 echo "Debug: The end time is '$time_at_end_of_alarm'"
 secs=$(( $time_at_end_of_alarm - $current_time ))
 mins=$(( ($time_at_end_of_alarm - $current_time) /60 ))
 echo "Debug: checking math difference is $secs seconds"
 echo "Debug: checking math difference is $mins mins"
fi


#######################################
### You may be asking why I didn't use sleep.
### I wanted to use the daate command rather than sleep.
### This was more of an exercise of using the date command.
### Using sleep $(( 60 * $mins)  would have been much more
### efficient then using this method.
#######################################
mycount=0
until [[ $current_time -gt $time_at_end_of_alarm || $current_time -eq $time_at_end_of_alarm ]] 
do 
 mycount=$(( $mycount + 1))
 current_time=$(date +"%s") #need to call current time in the loop to make this work
 hr_current_time=$(date +"%l:%M:%S") #human readable current time
 remaining_seconds=$(( $time_at_end_of_alarm - $current_time ))

 if [ $debug_state -eq 1 ] ;then
  echo "We have exactly ($remaining_seconds)s left"
  echo "The current time is '$current_time' is not equal to the end of '$time_at_end_of_alarm'"
  echo "The current time is '$hr_current_time' is not equal to the end of '$hr_time_at_end_of_alarm'"
 fi 

 ##############
 #Ajust sleep depending on remaining seconds
 ##############
 echo "We have exactly ($remaining_seconds)s left"
 if [ $remaining_seconds -gt 500 ] ; then  
   echo "...ajusting sleep (500)s ..."
   sleep 500
 elif [ $remaining_seconds -gt 60 ] ; then  
   echo "...ajusting sleep (60)s ..."
 elif [ $remaining_seconds -gt 30 ] ; then  
   echo "...ajusting sleep (30)s ..."
   sleep 30
 elif [ $remaining_seconds -gt 15 ] ; then  
   echo "...ajusting sleep (15)s ..."
   sleep 15
 elif [ $remaining_seconds -gt 10 ] ; then  
   echo "...ajusting sleep (10)s ..."
   sleep 10
 else
    #######################
    #count down with espeak at 1 per (s) interval 
    #######################
    echo "$remaining_seconds" | espeak -a 500 -p 1 -s 151
 fi

done

############
#end of wait call alarm
############
alarm_is_ringing

