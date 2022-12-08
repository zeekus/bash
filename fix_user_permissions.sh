#!/bin/bash
#fix_user_permissions.sh
#author: Theodore Knab
#date: 08/26/2020
#description: fixes permissions on user directories from a list of users
#user list can be either added at the command line static
# source home_folders module

desired_perms=750
revert_change_file="revert_fix_user_permission_$(date +%m_%d_%Y_%H%M).sh" #to undo changes

function warning_countdown () {
  echo "Warning: We will be fixing permissions on these users:  '$users' "
  echo "WARNING: this program will only display how to change things back."
  echo "It will make changes and display the reversion."
  echo "use file: $revert_change_file to revert any changes made"
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
 users="nrpe clamupdate chrony nagios unbound nfsnobody centos toor jmassey kasplen sals ted.knab lxd puppet"
fi

warning_countdown

for user in $users
  do
     #get paths associated with a user
     dir_paths=$(grep -i $user /etc/passwd| awk -F":" {'print $6'} )


     if [[ "${#dir_paths}" -ge 1 ]];then
       echo "user is $user path is $dir_paths"
     else
       echo "skipping... $user has no path."
     fi

     #sometimes there are more than one path for a user
     for single_path in $dir_paths
       do
         if [ -d $single_path ]; then
           #echo "debug: $single_path exists"
           current_perms=$(stat $single_path| grep ^Access ) #get access line from stat
           #echo "debug - current_perms: $current_perms"
           stringarray=($current_perms) #convert string to array so we can the second field
           #echo "debug - stringarry: $stringarray"
           perms=$(echo ${stringarray[1]}| tr -dc '0-9') #only get numbers from string
           #echo "debug - perms: $perms"
           if [ "$perms" -eq "$desired_perms" ]; then
             echo "#no change made. It appears the permissions are set on $single_path to $perms"
           else
             echo "chmod $perms $single_path #to revert from change" #output only gives the reversion
             echo "chmod $perms $single_path #to revert from change" >> $revert_change_file
             chmod $desired_perms $single_path #changing permissions
           fi
         else
           echo "debug: $single_path does not exist skipping"
         fi
       done
  done
