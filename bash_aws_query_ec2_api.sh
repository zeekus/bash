#!/bin/bash
#filename: query_aws_ec2_api.sh
#description: queries the AWS EC2 api and return desired data

query_aws_ec2_api () { 
  # Get query_value from AWS EC2 Rest API
  echo "getting $query_value" 
  return_value=$(curl -s http://169.254.169.254/latest/meta-data/$query_value)

  if [[ ! -z $return_value ]]; then
    echo "check ... $query_value yielded $return_value"
    logger "$log_prefix check ... $query_value yielded $return_value"
  else
    echo "error ... $query_value is empty exiting"
    logger "$log_prefix error ... $query_value is empty exiting"
    exit
  fi
}

#Example RUN to get instance-id
query_value="instance-id"
query_aws_ec2_api #get instance id from function
INSTANCE_ID=$return_value
echo instanceid is $INSTANCE_ID


#Example Run to get local IP from ec2
###################################
query_value="local-ipv4"
query_aws_ec2_api #get ip from function
PRIV_IPV4=$return_value
echo priv_ipv4 $PRIV_IPV4

