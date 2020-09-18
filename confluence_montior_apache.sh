#!/bin/bash
#date: 8/25/2020
#author: Theodore Knab
#filename: confluence_montior_apache.sh
#description: simple monitoring script for apache error logs and restart when failure is logged


monitoring_time=10 #monitoring interval
apache_log="/var/log/httpd/error_log " #apache log to monitor
regex_search_string="The timeout specified has expired: AH01030: ajp_ilink_receive"
services="httpd confluence"

#while list_of_minutes
#start_of_monitoring_time

echo "pysdo code:"
echo "...generate a list of time step through the logs (complete)"
echo "...parse logs using list times (complete)"
echo "...if any matches of desired exsit restart services (complete)"


restart_services() {
   for service in services
     do
      echo stopping $service
      systemctl stop $service

      echo starting $service
      systemctl start $service
     done
   exit 0 #only one restart
}



counter=1
let monitoring_time=monitoring_time+1


#this loop does a count backwards to target time
#if there on any matches it restarts the services
#if nothing is found it exits with no problem found output
echo "...generate a list of times step through the logs"
while [ $monitoring_time -ne $counter ];
  do
    time_to_check=$(date -d "now - $counter minutes" +"%a %h %d %H:%M")
    #check for log entry at this time
    log_hits=$(grep -i "$time_to_check" $apache_log)

    #if not empty move on
    if [[ ! -z $log_hits ]]; then
      #if non empty string is equal to our regex_search_string then restart services
      if [[ $log_hits =~ "$regex_search_string" ]]; then
        echo $counter: $time_to_check
        echo $log_hits
        echo "match found restart services"
        restart_services
      fi
    fi
    let counter=counter+1
  done

  echo "no problems found... nothing was restarted"


#count backwards in time
