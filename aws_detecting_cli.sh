#!/bin/bash
#filename: aws_detecting_cli.sh
#author: Teddy Knab
#date: 09/15/2021
#description: detecting cli and getting instance id



instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
aws_version=$(aws --version 2>&1)

echo myaws version is $aws_version

if [[ $aws_version =~ ^aws-cli\/1  ]]; then
  echo "aws version 1 detected on instance $instance_id"
else
  echo "aws version 2 detected on instance $instance_id"
fi