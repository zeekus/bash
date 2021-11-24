#!/bin/bash
#file: rsync_user_dirs.sh
#description: get a list of users with group 1002 and create the rsync command to sync over all the data

list=$(grep -i :1002 /etc/passwd) #common user group is 1002

echo "#start of commands"

destination_ip="10.1.1.1"
ssh_key_name="/home/centos/.ssh/mykey.pem"
run_file="/var/tmp/rsync_run.sh"

if [[ -e $run_file ]];then
   echo "error $run_file already exists. You may want to remove it."
   exit
else
   #initialize file
   echo > $run_file
   chmod +x $run_file
fi

for line in $list
do
   mydir=$(echo $line | awk -F: {'print $6'} )
   sync_command="sudo rsync -avxP --rsync-path=\"sudo rsync\" -e \"ssh -i $ssh_key_name\" $mydir centos@$destination_ip:$mydir"
   echo "appending: $sync_command"
   echo $sync_command >> $run_file
done

echo "run sync"
bash $run_file



