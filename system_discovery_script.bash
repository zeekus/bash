#!/bin/bash
#filename: system_discovery_script.bash
#description: basis system discovery script

myhost=`uname -a | awk {'print $2'}`

function my_header {
    echo
    echo
    echo "*************************************"
    echo $TITLE $myhost
    echo "*************************************"
    echo
}

REDHAT=0

if [ -e /etc/redhat-release ];then
   TITLE="RED HAT RELEASE"
   REDHAT=1 #set redhat machine
   my_header
   cat /etc/redhat-release
fi

IP="/usr/sbin/ip"
TITLE="IP ROUTE "
my_header
if [ -e $IP ]; then
  $IP route
  TITLE="IP ADDRESS"
  my_header
  $IP addr
else 
  echo "*old machine*"
  netstat -r
  TITLE="IP ADDRESS"
  my_header
  /sbin/ifconfig -a
fi

HOSTS="/etc/hosts"
if [ -e $HOSTS ]; then
   TITLE="HOSTS FILE"
   my_header
   cat $HOSTS
fi

TITLE="DISK SPACE"
my_header
df -h

TITLE="DISK INODES"
my_header
df -i

TITLE="UPTIME"
my_header
uptime 

TITLE="PROCESSES"
my_header
ps aux

TITLE="MESSAGES"
dmesg


TITLE="PACKAGES INSTALLED"

if [ $REDHAT -eq 1 ]; then
  P_COUNT=`rpm -qa| wc -l`
  my_header
  rpm -qai
  #$RPM_PATH -qai
  TITLE="$P_COUNT $TITLE"
  my_header
fi

