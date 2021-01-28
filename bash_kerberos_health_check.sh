#!/bin/bash
#filename: kerberos_health_checker.sh.
#description: make sure kerbose is still functional on a Linux host.

user="mydomainuser"
DOMAIN="MYDOMAIN"

join_domain() {

   if [[ -e "/usr/sbin/realm" ]]; then #use realm
     realm join -U $user $DOMAIN
   elif [[ -e "/usr/sbin/adcli" ]]; then  #use adcli
     adcli join --domain=$DOMAIN --login-user=$user
     #adcli join  --domain-controller=dce.example.net --domain-ou='ou=Computers,ou=Linux,dc=example,dc=net' --login-user='$user'
   else
     echo "unknown paramater"
   fi
}

#check for a keytab file
if [[ -e "/etc/krb5.keytab" ]]; then
   echo "keytab file exists: It looks like we have a domain registration."
else
   echo "the /etc/krb5.keytab file is missing. It looks like Kerbose is not setup right. Re-join the domain with 'adcli' or 'realmd'"
   #rejoin the domain
   join_domain
fi

#check for an active ticket
klist_check=$(klist -l | grep -i persistent| wc -l)

if [[ klist_check -eq 1 && $? == 0 ]] ; then
  echo "We seem to have an active kerbose ticket. Logins should work."
  else
   echo "We are missing a ticket. Logins could start to fail soon."
   echo "kinit $user@DOMAIN may fix this. "
   kinit -V $user@$DOMAIN
 fi
