#!/bin/bash
#filename: system_discovery_script.bash
myhost=`uname -a | awk {'print $2'}`

function my_header {
    echo
    echo
    echo "*************************************"
    echo $TITLE $myhost
    echo "*************************************"
    echo
}

RPM_PATH="/usr/bin/rpm"
IP="/usr/sbin/ip"
HOSTS="/etc/hosts"

TITLE="PACKAGES INSTALLED"

if [ -e $RPM_PATH ]; then
  P_COUNT=`rpm -qa| wc -l`
  my_header
  $RPM_PATH -qai
  TITLE="$P_COUNT $TITLE"
  my_header
fi


if [ -e $IP ]; then
  TITLE="IP ROUTE "
  my_header
  $IP route
  TITLE="IP ADDRESS"
  my_header
  $IP addr
fi

if [ -e $HOSTS ]; then
   TITLE="HOSTS FILE"
   my_header
   cat $HOSTS
fi

if [ -e /etc/redhat-release ];then
   TITLE="RED HAT RELEASE"
   my_header
   cat /etc/redhat-release
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
