#!/bin/bash
#file: rsync_user_dirs.sh
#description: get a list of users with group 1002 and create the rsync command to sync over all the data

list=$(grep -i :1002 /etc/passwd) #common user group is 1002

echo "#start of commands"

destination_ip="10.1.1.1"
ssh_key_name="mykey.pem"


for line in $list
do
   mydir=$(echo $line | awk -F: {'print $6'} )
   #echo $mydir
   sync_command="sudo rsync -avxP --rsync-path=\"sudo rsync\" -e \"ssh -i /home/centos/.ssh/$ssh_key_name\" $mydir centos@$destination_ip:$mydir"
   echo $sync_command
done
