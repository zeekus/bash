#!/bin/bash
#filename: restart_on_fail.sh
#description: restart_varnish on fail


mystart=$(date +%s)

while true; do

 check_state=$(varnishadm debug.health | grep Backend | grep Healthy| wc -l)

 mydate=$(date +%m/%d/%Y-%H:%M:%S)  #date for log file
 mylogfile=$(date +%m_%d_%Y.log) #name of log file


 if [[ $check_state == "" || $check_state -eq 0 ]]; then
   echo "failure detected"
   count_503_errors=$(curl -I localhost 2>>/dev/null| grep "^HTTP.* 503 " | wc -l) #verify output from curl
   if [[ $count_503_errors -gt 0 ]]; then
       later=$(date +%s)
       diff1=$(($later-$mystart))
       echo "503 errors from varnish after $diff1 seconds"
       /etc/init.d/varnish restart
       echo "failure logged $mydate"
       echo "$mydate : restarted after $diff1 seconds" >> $mylogfile
       mystart=$(date +%s) #reset mystart
   fi

 else
   echo "all ok $mydate"
   echo "$mydate : ok" >> $mylogfile
 fi

 sleep 5

done
