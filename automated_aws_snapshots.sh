#!/bin/bash
#filename: automated_aws_snapshots.sh
#author: Theodore Knab
#date: 06/25/2020
#description make snapshots of the Linux hosts in aws

mydate=$(date +%m_%d_%Y) #get date

#get instances
linux_instances=$(aws ec2 describe-instances --filters Name=tag:"Operating System",Values=*inux* --query 'Reservations[].Instances[].InstanceId' --output text)

#loop through the instance names
for myinstance in $linux_instances
do
  echo $myinstance

  #get instance name
  instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$myinstance" "Name=key,Values=Name" --query 'Tags[].Value' --output text)

  if [[ $instance_name == "Master" ]];then
     echo "...no snapshot of Master"
  else
     echo "...backing up $instance_name"

     #get the volume id for the instance
     volume_ids=$( aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=$myinstance" "Name=attachment.status, Values=attached" --query 'Volumes[].Attachments[].VolumeId' --output text)

     #make a snapshot of each volume attached to the instnace
     for volume in $volume_ids
       do
         echo "volume id: $volume"
         snap_name="${instance_name}_${myinstance}_${volume}_${mydate}"
         echo "......snap name is $snap_name"
         echo "......running .... aws ec2 create-snapshot --volume-id $volume --query 'SnapshotId' --description '$snap_name'"

         snapshotid=$(aws ec2 create-snapshot --volume-id $volume --query 'SnapshotId' --description "$snap_name")
         echo "......... snapshot created with a snapshotid of $snapshotid"
       done
  fi
done
