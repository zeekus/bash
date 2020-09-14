#!/bin/bash
#filename: puppet_service.sh
#description: a simple wrapper to send start or stop to puppet

if [ "$#" -ne 1 ]; then
    echo "error ... You must enter exactly 1 command line arguments"
    exit
fi

echo  "results: $0 $1"

function services () {
   puppet resource service pe-orchestration-services ensure=$status
   puppet resource service pe-puppetdb ensure=$status
   puppet resource service pe-postgresql ensure=$status
   puppet resource service puppet ensure=$status
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
