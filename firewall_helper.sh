#!/bin/bash
#filename: firewall_helper.sh
#author: Teddy Knab
#date: 26 September 2019
#use at own risk 
#######################################
#description: iptables helper aka firewall helper
#######################################

debug_state=0

##################
check_for_iptables() {
##################
   test -e "/sbin/iptables"
   if [ $? == 0 ] ; then
     echo "We found iptables. running '$0'"
   else
     echo "Sorry. No iptables found.\n"
     echo "This program requires the iptables binary to run. Exiting..."
     exit 2
   fi
}

##################
use_help() {
##################
  if [[ $debug_state -eq 0 ]] ; then
    clear
  else
    echo "debug: $debug_state"
  fi 
  echo "................................................."
  echo "How to use $0"
  echo "................................................."
  echo "TO BLOCK ONE IP"
  echo "type: $0 IPADDRESS"
  echo "      for example '$0 53.44.21.120'"
  echo "................................................."
  echo "RESTART / RESET Firewall with 'service iptables restart'"
  echo "type: $0 reset" 
  exit 0
}

################
find_dataminer() {
################
   #future function
   echo 0
}

################
reset_firewall(){
################
   root_check
   echo "firewall reset called"
   service iptables restart
}

firewall_ip(){
  root_check
  #firewall and log it
  echo "firewalling $ip" | logger -t "firewall rule added" -p alert
  my_cmd="/sbin/iptables -I INPUT 1 -s $ip -j DROP"
  echo "running: $my_cmd"
  $my_cmd
  echo $my_cmd| logger -t "firewall rule" -p alert
  #my_output=$(/sbin/iptables -I INPUT 1 -s $ip -j DROP) 
  #echo $my_output
}

################
test_ip_address(){
################

  if  [ $ip4 == '' ]   ;then
    range="bad"
    echo "missing value in $ip" 
    exit
  fi

  if [ $ip1 -gt 0 ] && [ $ip1 -lt 256 ]; then
    range="ok"
  else
    echo "out of range error with 1st octect $ip1" 
    exit 3
  fi
 
  if [ $ip2 -ge 0 ] && [ $ip2 -lt 256 ]; then
    range="ok:ok"
  else
    echo "out of range error with 2nd octet $ip2" 
    exit 4
  fi

  if [ $ip3 -ge 0 ] && [ $ip3 -lt 256 ]; then
    range="ok:ok:ok"
  else
    echo "out of range error with 3rd octet $ip3" 
    exit 5
  fi

  if [ $ip4 -gt 0 ] && [ $ip4 -lt 256 ] ; then
    range="ok:ok:ok:ok"
  else
    echo "out of range error with 4th octet $ip4" 
    exit 5
 fi
}

################
root_check(){
################
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
  fi
}


check_for_iptables #check for iptables or exit
ip=$1 #ip address
#echo "debug: ip is '$ip'"
ip1=`echo $ip| cut -d '.' -f1`
ip2=`echo $ip| cut -d '.' -f2`
ip3=`echo $ip| cut -d '.' -f3`
ip4=`echo $ip| cut -d '.' -f4`

#echo "debug: ip is : $ip1\.$ip2\.$ip3\.$ip4"

#######################################
#### INPUT Section
#######################################
if [[ $ip == '' ]] ;then 
  #empty variable processed 
  use_help #send help 
  exit 1
elif [ $ip == "r" ] || [ $ip == "reset" ] ;then
  echo "we got \'$ip\'"
  echo "reseting firewall"
  reset_firewall
  exit 0
elif [ $ip1 -gt  0 ] && [ $ip1 -lt  256 ] ;then
  test_ip_address
  if [ $range == "ok:ok:ok:ok" ] && [ $ip != "255.255.255.255" ] && [ $ip != "127.0.0.1" ]   ; then
    echo "This looks like an ip address."
    echo "Checking to make sure $ip is not in the firewall already."
    l_count=`iptables -L | grep -w $ip|wc -l` 
    #echo lines is '$l_count'
    if [[ $l_count == 0 ]] ;then
      echo "$ip was not found in \"iptables -L\" ... firewalling $ip"
      firewall_ip
    else
      echo "$l_count: $ip is already in firewall list"
      echo "It is not a good practice to firewall the same IP ADDRESS twice."
    fi
  else
    echo "broadcast address or loop back detected: exiting: $ip"
    exit 10
  fi
else
  echo "something unexpected happened."
  use_help
  exit 2
fi
