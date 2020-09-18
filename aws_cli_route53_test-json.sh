#!/bin/bash
#filename: aws_cli_route53_test-json.sh
#description: automatically registers a domain and ptr record in route53 for AWS using json files.
#author: Theodore Knab

HOSTED_ZONE_ID="XXXXXXXX1"
REVERSE_ZONE_ID="XXXXXXX2"
DOMAIN="myexample.com"
AWS_REGION=us-east-1
hostname="myhostname"
PRIV_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
IPBRIF=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | awk -F "." '{print $4"." $3}')
ARPA="$IPBRIF.128.10.in-addr.arpa."


revfile="rev_file.json"
dnsfile="dns_file.json"

#json for dns record
cat > $dnsfile << EOF
{
 "Comment": "R53DNS.sh created A for $hostname.$DOMAIN",
 "Changes": [{
   "Action": "UPSERT",
   "ResourceRecordSet": { 
     "Name": "$hostname.$DOMAIN." ,
     "Type": "A",
     "TTL" : 300,
     "ResourceRecords": [{
        "Value": "$PRIV_IPV4"
     }]
  }
 }]
}

EOF
    
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://$dnsfile

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

aws route53 change-resource-record-sets --hosted-zone-id $REVERSE_ZONE_ID --change-batch file://$revfile
