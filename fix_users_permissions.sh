#!/bin/bash
#fix_user_permissions.sh
#author: Theodore Knab
#date: 08/26/2020
#description: fixes permissions on user directories from a list of users
#user list can be either added at the command line static

desired_perms=750

function warning_countdown () {
  echo "Warning: We will be fixing permissions on these users:  '$users' "
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
}

args=.
#user input check
if [ "$#" -gt 0 ]; then
   echo "notice... You entered $# arguements"
   echo "You provided the arguments:" "$@"
   args=$@
   echo args are $args
   users=${args}
else 
 #users seperated by a space
 users="pe-orchestration-services pe-console-services pe-puppetdb pe-webserver pe-postgres pe-ace-server pe-bolt-server pe-puppet" 
fi

warning_countdown

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
         if [ "$perms" -eq "$desired_perms" ]; then
           echo "#change appears already to have been made on $single_path"
         else 
           echo "chmod $perms $single_path #to revert from change" #output only gives the reversion 
           chmod $desired_perms $single_path #changing permissions
         fi 
       done

  done
