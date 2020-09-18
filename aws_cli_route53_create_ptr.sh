#!/bin/bash
#filename: aws_cli_route53_create_ptr.sh
#description: creates a ptr record in route53 for AWS using json files from the main A or CNAME record.
#author: Theodore Knab

HOSTED_ZONE_ID=<YOUR AWS HOSTED_ZONE_ID>
REVERSE_ZONE_ID=<YOUR AWS REVERSE_ZONE_ID>
DOMAIN=example.com   # <YOUR DOMAIN>
AWS_REGION=us-east-1 # <YOUR REGION>

echo "Warning set your ARPA variable for your subnet."

echo "You provided the arguments:" "$@"

if [ "$#" -ne 1 ]; then
    echo "error ... You must enter exactly 1 command line arguments"
        exit
fi
echo pass ... Number of arguments on the command line: $#

hostname=$1
lookup_results=$(host $hostname| sed -e s/\ has\ address\ /:/g) #seperate host and ip by colon
echo $lookup_results

IPBRIF=$(echo $lookup_results| awk -F ":" '{print $2}' | awk -F "." '{print $4"." $3}')

#verify we have the 2 octects
if [[ ! -z $IPBRIF && ! $IPBRIF =~ ^\.$ ]]; then
   echo "check ... ipbrief is '$IPBRIF'"
else
   echo "error ... IPBRIEF is empty exiting"
   exit
fi

ARPA="$IPBRIF.128.10.in-addr.arpa."
if [[ ! -z $ARPA ]]; then
   echo "check ... ARPA is $ARPA "
else
   echo "error ... ARPA is empty exiting"
   exit
fi

revfile="rev_file.json"

#json for PTR record
cat > $revfile << EOF

{
 "Comment": "R53DNS.sh created PTR for $hostname.$DOMAIN",
 "Changes": [{
   "Action": "UPSERT",
   "ResourceRecordSet": {
     "Name": "$ARPA" ,
     "Type": "PTR",
     "TTL" : 300,
     "ResourceRecords": [{
        "Value": "$hostname.$DOMAIN."
     }]
  }
 }]
}

EOF

cat $revfile

read -p "Do you want to commit this to route53 ? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "ok exiting without running.."
        exit 1
else
  echo "commiting change to Route53"
  aws route53 change-resource-record-sets --hosted-zone-id $REVERSE_ZONE_ID --change-batch file://$revfile
fi

