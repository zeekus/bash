#!/bin/bash
#filename: ad_renew_kerberos.sh
#description: renews kerberos ticket when things get messed up

mypass="mypass"
myrealm="EXAMPLE.NET"
myuser="myuser"
domainuser=$myuser@$myrealm
domain=$myrealm| tr '[:upper:]' '[:lower:]'
domainserver="myhost.$domain"
echo "user: $domainuser"

set_time_to_windows() {
  echo "sync time with $domainserver"
  net time set -S $domainserver
}

kinit_reinitialize() {
    set_time_to_windows # sync time 
    echo "reinitializing kinit"
    echo "$myuser@$myrealm"
    echo $mypass | kinit -V $domainuser
    if [[ $? == 0 ]] ; then
       echo "success"
    else
       echo "failed to rejoin"
    fi
}

klist=$(/usr/bin/klist </dev/stdin 2>&1) #run klist and capture output

if [[ $klist =~ ^Ticket && $? == 0 ]]; then
   echo "klist found attempting to renew key"
   renew_ticket_err=$(/usr/bin/kinit -R </dev/stdin 2>&1)
   if [[ $renew_ticket_err =~ Ticket.expired ]]; then
     echo "running kdestroy"
     kdestroy
     echo "kdestroy run error is $?"
     kinit_reinitialize
   else
     echo "successful renawal with output of '$renew_ticket_err'"
   fi
elif [[ $klist =~ ^klist:.No ]]; then
  echo "fix needed. Klist is not displaying"
  echo "ERROR message: '$klist'"
  kinit_reinitialize
else
  echo "user variables not defined"
  echo "Please define them in the script."
fi
