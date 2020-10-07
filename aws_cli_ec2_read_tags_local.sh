#!/bin/bash
#filename: aws_cli_ec2_read_tags_local.sh
#description: read local host's aws tags
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo $instance_id
aws ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}"
