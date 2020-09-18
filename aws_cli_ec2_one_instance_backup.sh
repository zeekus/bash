#!/bin/bash
#filename: aws_cli_ec2_one_instance_backup.sh
#author: Theodore Knab
#date: 06/25/2020
#License Type: GNU GENERAL PUBLIC LICENSE, Version 3
#description make snapshots of the Linux hosts in aws

target='CENTOS8_LINUX_AMI' #instance name

mydate=$(date +%m_%d_%Y) #get date

#get instances
#linux_instances=$(aws ec2 describe-instances --filters Name=tag:"Operating System",Values=*inux* --query 'Reservations[].Instances[].InstanceId' --output text)
#target_instances=$(aws ec2 describe-instances --filters Name=tag:"Name",Values=*test_ami* --query 'Reservations[].Instances[].InstanceId' --output text)
target_instances=$(aws ec2 describe-instances --filters Name=tag:"Name",Values=$target --query 'Reservations[].Instances[].InstanceId' --output text)

#loop through the instance names
for myinstance in $target_instances
do
  #get instance name
  instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$myinstance" "Name=key,Values=Name" --query 'Tags[].Value' --output text)
  echo my instance name is $instance_name with instance of $myinstance

  #get the volume id for the instance
  volume_ids=$( aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=$myinstance" "Name=attachment.status, Values=attached" --query 'Volumes[].Attachments[].VolumeId' --output text)


  #make a snapshot of each volume attached to the instnace
  for volume in $volume_ids
    do
      echo "volume id: $volume"
      snap_name="${instance_name}_${myinstance}_${volume}_${mydate}"
      echo "......snap name is $snap_name"
      echo "......running .... aws ec2 create-snapshot --volume-id $volume --query 'SnapshotId' --description '$snap_name' "

      snapshotid=$(aws ec2 create-snapshot --volume-id $volume --query 'SnapshotId' --description "$snap_name" )
      echo "......... snapshot created with a snapshotid of $snapshotid"
    done

done
