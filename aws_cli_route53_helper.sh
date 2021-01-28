#!/bin/bash
#filename: aws_cli_route53_helper.sh
#description: used for setting up Route53 DNS entries, hostname, and hosts file on a autoscaling Linux host.
#requirements: awscli and cloud-init
#
# This script figures out a hostname based on the value in the role file.
# E.g, "someapp_webserver" would result in the hostname someapp-webserver-xxx
# where "xxx" is the next available number. The hostname is set locally and
# a CNAME record in Route53 is created.
# 
# The FQDN becomes HOSTNAME . ENVIRONMENT . mydomain
# (e.g. webserver1p.example.com)
#
# The environment portion is taken from the puppet configuration file. "Prod"
# is used if the environment is "production" (puppet's default).
# 
# Once the hostname is set, the puppet service is restarted so that the certs
# are generated for the correct hostname.
# Finally the hostname is set on the "Name" tag of the ec2 instance
# 
# Dependencies:
# This script assumes puppet is configured and running, and that the following
# packages are installed:
# * aws cli
#
# Date: 2013-12-26
# Author: Tyler Stroud <tyler@tylerstroud.com> - original source 
# Major Edits by: Theodore Knab
# major logic rewrite 10/22/2020 no longer needs route53-cli 
# last tested 1/27/2021

# BEGIN CONFIGURATION
# Set these variables accordingly
HOSTED_ZONE_ID=ZZZZZZZZZZZZZZ
REVERSE_ZONE_ID=ZZZZZZZZZZZZZZ
mydomain=us-east.aws.annapolislinux.org
my_aws_region=us-east-1
myhost="" #hostname we will use for setting up new Route53 entry
limit=15 #range of hosts to check ( 15 = 0 ... 15, 10 = 0 ... 10)
log_prefix="route53_helper:" 


# COMMANDS
HOST_BASE_FILE=/etc/hostbase # required source file with hostaname
AWS_CREDENTIALS=/$USER/.aws/credentials

# gets the next available host in a list
find_next_host_to_use() { 

 used_hostnames=""
 available_hostnames=""
 target_name=$HOST_BASE
  
 for i in $(seq 0 $limit)
 do 
  #echo debug-looking up $target_name$i.$mydomain
  lookup_host=$(host "$target_name$i$ENV.$mydomain")
  if ( test $? -eq 0); then 
    echo taken host: $lookup_host
    used_hostnames="$used_hostnames $target_name$i$ENV.$mydomain"
  else 
     available_hostnames="$available_hostnames $target_name$i$ENV.$mydomain"
  fi
  done

  for myhost in $available_hostnames
  do
   #echo we will use $myhost
   next_host_to_use=$myhost
   break
  done
}

query_aws_ec2_api () { 
  # Get query_value from AWS EC2 Rest API
  echo "getting $query_value" 
  return_value=$(curl -s http://169.254.169.254/latest/meta-data/$query_value)

  if [[ ! -z $return_value ]]; then
    echo "$log_prefix check ... $query_value yielded $return_value"
    logger "$log_prefix check ... $query_value yielded $return_value"
  else
    echo "$log_prefix error ... $query_value is empty exiting"
    logger "$log_prefix error ... $query_value is empty exiting"
    exit
  fi
}


###################################
#MAIN LOGIC BEGINS
###################################

###################################
###################################
# Sanitity Checks
###################################
###################################

###################################
#check for /etc/hostbase
#We need this or we need to create one.
#Cloud Config may create this if setup in user-data area.
#EXAMPLE /bin/echo list > /etc/hostbase 
###################################
if [ -f $HOST_BASE_FILE ]; then
  logger "$log_prefix HOST_BASE_FILE Exists $HOST_BASE_FILE"
  echo "$log_prefix HOST_BASE_FILE Exists $HOST_BASE_FILE"
  
  HOST_BASE=$(cat $HOST_BASE_FILE) #set hostbase variable
  echo   "$log_prefix content of hostbase is $HOST_BASE"
  logger "$log_prefix content of hostbase is $HOST_BASE"
  quick_verify=$(host $HOST_BASE)
  if [ $? == 0 ] ; then
    echo    "$log_prefix host found in DNS with $HOST_BASE_FILE"
    logger  "$log_prefix host found in DNS with $HOST_BASE_FILE"
  else
    logger "$log_prefix no host found in DNS with $HOST_BASE_FILE"
    echo   "$log_prefix no host found in DNS with $HOST_BASE_FILE"
  fi
else
  logger "$log_prefix warning ... $HOST_BASE_FILE is missing ..."
  echo   "$log_prefix warning ... $HOST_BASE_FILE is missing ..."
fi

###################################
#check for AWS credentials. Not needed if IAM role has permsissions
###################################
if [ -f "$AWS_CREDENTIALS" ]; then
  echo   "$log_prefix check ... $AWS_CREDENTIALS exist."
  logger "$log_prefix check ... $AWS_CREDENTIALS exist."
else
   echo   "$log_prefix Warning: $AWS_CREDENTIALS are missing. There may be permission issues."
   logger "$log_prefix Warning: $AWS_CREDENTIALS are missing. There may be permission issues."
fi

###################################
#check for Domain varible.
###################################
if [ -z $mydomain ]; then 
   echo   "$log_prefix error ... empty mydomain variable exiting..."
   logger "$log_prefix error ... empty mydomain variable exiting..."
   exit 1
else 
   echo check ... domain is $mydomain
fi

###################################
#check for hosted zone id 
###################################
if [ -z $HOSTED_ZONE_ID ]; then 
   echo   "$log_prefix error ... empty HOSTED_ZONE_ID variable exiting..."
   logger "$log_prefix error ... empty HOSTED_ZONE_ID variable exiting..."
   exit 1
else
   echo   "$log_prefix ok ... HOSTED_ZONE_ID variable ..."
   logger "$log_prefix ok ... HOSTED_ZONE_ID variable  ..."
fi

###################################
#check for reverse zone id
###################################
if [ -z $REVERSE_ZONE_ID ]; then
  echo   "$log_prefix error ... empty REVERSE_ZONE_ID variable exiting.."
  logger "$log_prefix error ... empty REVERSE_ZONE_ID variable exiting.."
  exit 1
else 
  echo    "$log_prefix ok ... reverse_zone_id $REVERSE_ZONE_ID found.."
  logger  "$log_prefix ok ... reverse_zone_id $REVERSE_ZONE_ID found.."
fi
###################################


#get instance-id from ec2
###################################
query_value="instance-id"
query_aws_ec2_api #get instance id from function
INSTANCE_ID=$return_value
echo instanceid is $INSTANCE_ID

#get local IP from ec2
###################################
query_value="local-ipv4"
query_aws_ec2_api #get ip from function
PRIV_IPV4=$return_value
echo priv_ipv4 $PRIV_IPV4

#get ipbrif from IP  the first two octects
###################################
IPBRIF=$(echo $PRIV_IPV4 | awk -F "." '{print $4"." $3}')
logger "$log_prefix ipbrif is  $IPBRIF"
echo "$log_prefix ipbrif is $IPBRIF" 

###################################
#verify we have the last 2 octects for reverse DNS entries
###################################
if [[ ! -z $IPBRIF ]]; then
  echo   "$log_prefix check ... ipbrief is $IPBRIF"
  logger "$log_prefix check ... ipbrief is $IPBRIF"
else
  echo   "$log_prefix warn ... IPBRIEF is empty going on"
  logger "$log_prefix warn ... IPBRIEF is empty going on"
fi

#get current name from AWS Name tag
echo   "$log_prefix status ... get name from the EC2 AWS API" #get the current name of the host from AWS EC2 Rest API
logger "$log_prefix status ... get name from the EC2 AWS API"
CURRENT_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" | awk '/Value/ {print $2}' | cut -d'"' -f2)
logger "$log_prefix current_name is $CURRENT_NAME"
echo "$log_prefix current_name is $CURRENT_NAME"

CURRENT_NAME1=$(echo $CURRENT_NAME| sed -e s/[0-9].*//g ) #trim off any text that has our expected suffix

if [[ $CURRENT_NAME  != $CURRENT_NAME1 ]]; then 
  logger "$log_prefix warning name tag of is $CURRENT_NAME"
  logger "$log_prefix warning current_name1 is $CURRENT_NAME1"
  echo "$log_prefix warning name tag is $CURRENT_NAME"
  echo "$log_prefix warning current_name1 is $CURRENT_NAME1"
  CURRENT_NAME=$CURRENT_NAME1 #use parsed tag
fi

logger "$log_prefix current_name is $CURRENT_NAME"
echo "$log_prefix current_name is $CURRENT_NAME"

###################################
#check and set hostbase
###################################
# echo "debug 1 get size of $CURRENT_NAME"
size_of_current_name=$(expr length $CURRENT_NAME)
if [ $? == 0 ] ; then
  echo "length of current_name is $size_of_current_name"
else
  echo "warning: error retrieving length of current_name"
  size_of_current_name=0 #set to 0
fi
# echo "debug 2 get size of $HOST_BASE"
size_of_hostbase=$(expr length $HOST_BASE)
if [ $? == 0 ] ; then
  echo "length of size_of_hostbase is $size_of_hostbase"
else
  echo "warning: error retrieving length of size_of_hostbase"
  size_of_hostbase=0 #set to 0
fi

##############################
#logic to set the host_base depending if $HOST_BASE_FILE exists or name exists in AWS tag.
##############################
if [ ! -z $HOST_BASE_FILE ] && [ $size_of_hostbase -gt 3 ]; then
  echo "$log_prefix  /etc/hostbase is host_base:$HOST_BASE"
  logger "$log_prefix  /etc/hostbase is host_base:$HOST_BASE"
  CURRENT_NAME=$HOST_BASE #set current_name to host_base
elif [ ! -z $CURRENT_NAME ] && [ $size_of_current_name -gt 3 ]; then
  echo "$log_prefix setting /etc/hostbase to current_name:$CURRENT_NAME"
  logger "$log_prefix setting /etc/hostbase to current_name:$CURRENT_NAME"
  echo $CURRENT_NAME > /etc/hostbase
  HOST_BASE=$CURRENT_NAME #set host_base to current_name
else 
  echo   "$log_prefix Error ... current name is: '$CURRENT_NAME' is too short or empty. exiting"
  logger "$log_prefix Error ... current name is: '$CURRENT_NAME' is too short or empty. exiting"
  exit 
fi

#logic to see if the 
logger "$log_prefix get current53 hostname from Route53 "
echo "$log_prefix get current53 hostname from Route53 "
#verify we have a r53 hostname 
CURRENT_R53_HOST=$(host $CURRENT_NAME | awk -F' ' '{print$4}')
logger "$log_prefix current53 hostname from Route53 is $CURRENT_R53_HOST"
echo "$log_prefix current53 hostname from Route53 is $CURRENT_R53_HOST"

if [[ ! -z $CURRENT_R53_HOST ]] && [ $? == 0 ] ; then
  echo "$log_prefix '$CURRENT_NAME' responds with '$CURRENT_R53_HOST' in Route53 "
  logger "$log_prefix '$CURRENT_NAME' responds with '$CURRENT_R53_HOST' in Route53 "
else
  echo "$log_prefix '$CURRENT_NAME' is not in Route53 "
  logger "$log_prefix '$CURRENT_NAME' is not in Route53 "
fi

echo "status ... get r53 reverse ipv4 address" #get ip address from R53
#verify we have an IP 
CURRENT_R53_IPV4=$(host $PRIV_IPV4 | awk -F' ' '{print$5}')
if [[ ! -z $CURRENT_R53_IPV4 ]]; then
  echo "check ... current r53 revese entrfor $PRIV_IPV4 is $CURRENT_R53_IPV4"
else
  logger "$log_prefix current r53 ip is empty or missing got: $CURENT_R53_IPV4 exiting"
  echo "$log_prefix current r53 ip is empty or missing got: $CURENT_R53_IPV4"
  echo "error ... current r53 ip is empty exiting..."
  echo "this may mean we don't have read rights. Check $AWS_CREDENTIALS"
  exit
fi

#debug info get host before environment and number assignment
logger "$log_prefix pre-env and number assignment CURRENT_R53_HOST: $CURRENT_R53_HOST and PRIV_IPV4: $PRIV_IPV4"
logger "$log_prefix pre-env and number assignment CURRENT_R53_IPV4: $CURRENT_R53_IPV4 and CURRENT_NAME.mydomain.: $CURRENT_NAME.$mydomain"
echo   "$log_prefix pre-env and number assignment CURRENT_R53_HOST: $CURRENT_R53_HOST and PRIV_IPV4: $PRIV_IPV4"
echo   "$log_prefix pre-env and number assignment CURRENT_R53_IPV4: $CURRENT_R53_IPV4 and CURRENT_NAME.mydomain.: $CURRENT_NAME.$mydomain"


echo "checks ... Sanity Check checking $CURRENT_R53_HOST and $CURRENT_R53_IPV4" #verifying we have everything we need to proceed. 
#if [ "$CURRENT_R53_HOST" == "$PRIV_IPV4" ] && [ "$CURRENT_R53_IPV4" == "$CURRENT_NAME.$mydomain." ]; then
if [ "$CURRENT_R53_HOST" == "$PRIV_IPV4" ] && [ "$CURRENT_R53_IPV4" == "$CURRENT_NAME.$mydomain." ]  && [ "$CURRENT_NAME" == "$HOST_BASE" ]; then
  echo "check ... no changes necessary exiting..."
  logger "$log_prefix R53DNS: EVERYTHING MATCHES NO CHANGES NECESSARY Exiting Script"
  exit 0
fi

echo "Grab the Environment info " #get type of environment from AWS EC2 Tags
ENV=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Environment" | awk '/Value/ {print $2}' | cut -d'"' -f2)

echo "debug... AWS Tag for Environment is '$ENV'"

#get envionment type from AWS tags
if [[ "$ENV" =~ ^[P|p] ]]; then
    ENV=p #production
elif [[ "$ENV" =~ ^[D|d] ]]; then
    ENV=d #development 
elif [[ "$ENV" =~ ^[S|s] ]]; then
    ENV=s #staging 
elif [[ "$ENV" =~ ^[T|t] ]]; then 
   ENV=t #testing 
else 
    #exit on with Error
    echo   "$log_prefix '$INSTANCE_ID' is missing environment tag. exiting. "
    logger "$log_prefix '$INSTANCE_ID' is missing environment tag. exiting. "
    exit 1
    
fi
logger "$log_prefix '$INSTANCE_ID' is will be assigned a '$ENV' suffix on the name tag"
echo "$log_prefix '$INSTANCE_ID' is will be assigned a '$ENV' suffix on the name tag"


#######################
#number for name tag suffix 
#######################
find_next_host_to_use #attempt to get next available dns name from route53
#check_for_host=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID  --output text | sed -e 's/\t/,/g' |awk -F"," -v pattern=$srch_pattern '$2~pattern {print $2}'| sort -n |grep -i "$HOST_BASE$i$ENV" )
hostname=$(echo $myhost| awk -F "." '{print $1}' ) #parse short hostname from fqdn 
fqdn=$myhost
echo   "$log_prefix R53DNS: we have a myhost $myhost and fqdn of $fqdn"
logger "$log_prefix R53DNS: we have a myhost $myhost and fqdn of $fqdn"

##############
#modify hostname 
##############
#sed -i "s/^HOSTNAME=.*$/HOSTNAME=$fqdn/" /etc/sysconfig/network
echo "$log_prefix R53DNS: File change .. Setting hostname to $hostname"
logger "$log_prefix R53DNS: File change .. Setting hostname to $hostname"
echo $hostname > /etc/hostname


##############
#modify hosts file
##############

echo  "$log_prefix R53DNS: File change .. generating the initial /etc/hosts file"
logger "$log_prefix R53DNS: File change .. generating the initial /etc/hosts file"
# Add fqdn to hosts file
cat<<EOF > /etc/hosts
## =================================== ##
# The following lines are desirable for IPv4 capable hosts
127.0.0.1   $fqdn $hostname
127.0.0.1   localhost.localdomain localhost
127.0.0.1   localhost4.localdomain4 localhost4
$PRIV_IPV4 $myhost $hostname

# The following lines are desirable for IPv6 capable hosts
::1 $fqdn $hostname 
::1 localhost.localdomain localhost
::1 localhost6.localdomain6 localhost6

# Extra host definitions
EOF

#Debug info final json builds begin
logger "$log_prefix R53DNS: Creating A record in Route53 in Zone us-east.aws.annapolislinux.org"
logger " Creating PTR record $IPBRIF.128.10.in-addr.arpa. in Route53 in zone 128.10.in-addr.arpa."
echo "$log_prefix R53DNS: Creating A record in Route53 in Zone us-east.aws.annapolislinux.org"
echo " Creating PTR record $IPBRIF.128.10.in-addr.arpa. in Route53 in zone 128.10.in-addr.arpa."


##################################
#domain registration
##################################
ARPA="$IPBRIF.128.10.in-addr.arpa."
revfile="rev_file.json"
dnsfile="dns_file.json"

echo "$log_prefix R53DNS: writing $dnsfile for A record"
logger "$log_prefix R53DNS: writing $dnsfile for A record"

cat > $dnsfile << EOF
{
 "Comment": "R53DNS.sh created A for $hostname.$mydomain",
 "Changes": [{
   "Action": "UPSERT",
   "ResourceRecordSet": {
     "Name": "$hostname.$mydomain." ,
     "Type": "A",
     "TTL" : 300,
     "ResourceRecords": [{
        "Value": "$PRIV_IPV4"
     }]
  }
 }]
}

EOF

#change A record in Route53 
cat $dnsfile 

cat > $revfile << EOF

{
 "Comment": "R53DNS.sh created PTR for $hostname.$mydomain",
 "Changes": [{
   "Action": "UPSERT",
   "ResourceRecordSet": {
     "Name": "$ARPA" ,
     "Type": "PTR",
     "TTL" : 300,
     "ResourceRecords": [{
        "Value": "$hostname.$mydomain."
     }]
  }
 }]
}

EOF

#change PTR record in Route53
cat $revfile

###stopping before final run for debugging 
# echo "exiting"
# exit

#setting A Record
echo "$log_prefix R53DNS: changing A record for $HOSTED_ZONE_ID $dnsfile"
logger "$log_prefix R53DNS: changing A record for $HOSTED_ZONE_ID $dnsfile"
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://$dnsfile

#setting Reverse Entry
echo "$log_prefix R53DNS: changing PTR record for $HOSTED_ZONE_ID $revfile"
logger "$log_prefix R53DNS: changing PTR record for $HOSTED_ZONE_ID $revfile"
aws route53 change-resource-record-sets --hosted-zone-id $REVERSE_ZONE_ID --change-batch file://$revfile

# Finally, set hostname as "Name" tag
logger "$log_prefix R53DNS: Modifying Name Tag to $hostname in EC2 for Instance $INSTANCE_ID"
echo "$log_prefix R53DNS: Modifying Name Tag to $hostname in EC2 for Instance $INSTANCE_ID"
aws ec2 create-tags --region=$my_aws_region --resources=$INSTANCE_ID --tags Key=Name,Value=$hostname

