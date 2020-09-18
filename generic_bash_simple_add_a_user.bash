#!/bin/bash
#filename: generic_bash_simple_add_a_user.bash
#description: add a user from a bash script

user="admin"
group=wheel
home="/home/$user"
shell="/bin/bash"
pass="someexamplepassword"

create_user() {
        useradd -d $home -G $group -m -s $shell $user
        if [ $? == 0 ]
        then
           echo "successfuly added user"
        fi
}

reset_pass(){
       echo "$user:$pass" | chpasswd
       if [ $? == 0 ]
       then
          echo "successfuly updated password"
       fi
}


uid=$(id $user)
if [ $? == 0 ]
then
   echo user exists reseting pass
   reset_pass
else
   echo user does not exist creating..
   create_user
   reset_pass
fi
