#!/bin/bash
#filename: puppet_restart_processes.sh
#description: a simple wrapper to send start or stop to puppet
#Author: Theodore Knab
#date: 01/07/2021



if [ "$#" -ne 1 ]; then
    echo "error ... You must enter exactly 1 command line arguments"
    echo "example use: ./puppet.sh start or ./puppet.sh stop"
    exit
fi

echo  "results: $0 $1"

function services () {

   puppet_server="pe-puppetserver pe-nginx pe-console-services pe-orchestration-services pe-puppetdb  pe-postgresql" #services
   puppet_client="pxp-agent puppet"

   echo "verify service service is $status"
   for myservice in $puppet_server
     do
       echo "puppet resource service $myservice ensure=$status"
       puppet resource service $myservice ensure=$status
     done

   echo "verify client services are $status"
   for myservice in $puppet_client
     do
       echo "puppet resource service $myservice ensure=$status"
       puppet resource service $myservice ensure=$status
     done

}

if [[ $1 =~ ^start ]];then
   echo "starting puppet services"
   status="running"
   services
fi

if [[ $1 =~ ^stop ]]; then
  echo "stopping puppet services"
  status="stopped"
  services
fi
