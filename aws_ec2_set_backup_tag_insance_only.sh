#!/usr/bin/bash
#filename: aws_ec2_set_backup_tag_insance_only.sh
#description: set backup tags on intances that are missing them.
#author: Theodore Knab
#date: 9/15/2020

my_tag="Operating System" # my tag to search
my_value="*Linux*"        # my value to search

#get list of instances that have these paramaters
my_instance_list=$(aws ec2 describe-instances --filter "Name=tag:$my_tag,Values=$my_value" --query 'Reservations[].Instances[].InstanceId' --output text)
for instance in $my_instance_list
  do
        iname=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance" "Name=key,Values=Name" --query 'Tags[].Value' --output text)
        echo $instance $iname
        check_for_backup_tag=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance" --query 'Tags[?Key==`DailyBackup`].Value[]' --output text)
        if [ ! -z $check_for_backup_tag ]; then
                echo "The tag appears to be set. Do nothing..."
        else
                echo "We need to set the backup tag. Creating it"
                set_tags="aws ec2 create-tags --resource $instance --tags Key=DailyBackup,Value=true"
                echo "running... $set_tags"
                $set_tags
        fi
  done
