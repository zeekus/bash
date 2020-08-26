#!/bin/bash
#fix_user_permissions.sh
#description: fixes permissions on user directories from a list of users

#users seperated by a space
users="pe-orchestration-services pe-console-services pe-puppetdb pe-webserver pe-postgres pe-ace-server pe-bolt-server pe-puppet"
desired_perms=750

echo "WARNING: this program will only display how to change things back."
echo "It will make changes and display the reversion."
mycountdown=5
while [ $mycountdown -gt 0 ]
   do 
     echo -n $mycountdown ".."
     sleep 1
     let mycountdown=($mycountdown-1)
   done

echo "making changes: here is the reversion settings. please save this."

for user in $users
  do
     #echo "user is $user"
     #get paths associated with a user
     dir_paths=$(grep -i $user /etc/passwd| awk -F":" {'print $6'} )

     #sometimes there are more than one path for a user
     for single_path in $dir_paths
       do
         current_perms=$(stat $single_path| grep ^Access ) #get access line from stat
         stringarray=($current_perms) #convert string to array so we can the second field
         perms=$(echo ${stringarray[1]}| tr -dc '0-9') #only get numbers from string
         if [ $perms == $desired_perms ]; then
           echo "#change appears already to have been made on $single_path"
         else 
           echo "chmod $perms $single_path #to revert from change" #output only gives the reversion 
           chmod $desired_perms $single_path #changing permissions
         fi 
       done

  done
