#!/usr/bin/bash
#filename: set_aws_tags_in_cli.sh
#description: sets target tags on hosts with matching search tags. 
#author: Theodore Knab
#date: 9/16/2020

#this example adds a tag of kernel=Linux to all the hosts with a Operating System *Linux* tag in place.

search_tag="Operating System" # my tag to search
search_value="*Linux*"        # my value to search

target_tag="kernel"  #tag to set if it doesn't exsit
target_value="Linux" #tag value to set if target_tag doesn't exist

echo "...getting list of instances: to set the instance tags"
#get list of instances that have these paramaters
my_instance_list=$(aws ec2 describe-instances --filter "Name=tag:$search_tag,Values=$search_value" --query 'Reservations[].Instances[].InstanceId' --output text)
for instance in $my_instance_list
  do
    iname=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance" "Name=key,Values=Name" --query 'Tags[].Value' --output text)
    echo $instance $iname
    check_for_target_tag=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance" --query 'Tags[?Key==`$target_tag`].Value[]' --output text)
    if [ ! -z $check_for_target_tag ]; then
      echo "...The tag of '$target_tag' appears to be set. Do nothing..."
    else
      echo "c...The tag of '$target_tag' appears to missing on our instance. Creating it."
      set_tags="aws ec2 create-tags --resource $instance --tags Key=$target_tag,Value=$target_value"
      echo "running... $set_tags"
      $set_tags
    fi

    echo "...getting list of volumes: to set the volume tags"
      #get the volume id for the instance
      list_of_volume_ids=$(aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=$instance" "Name=attachment.status, Values=attached" --query 'Volumes[].Attachments[].VolumeId' --output text)
    for volume in $list_of_volume_ids
      do
        echo "...volume is $volume"
        check_for_target_tag=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$volume" --query 'Tags[?Key==`$target_tag`].Value[]' --output text)
        if [ ! -z $check_for_target_tag ]; then
          echo "...The tag of '$target_tag' appears to be set. Do nothing..."
        else
          echo "c...The tag of '$target_tag' appears to missing on our instance. Creating it."
          set_tags="aws ec2 create-tags --resource $volume --tags Key=$target_tag,Value=$target_value"
          echo "running ... $set_tags"
          $set_tags
        fi
      done
  done
