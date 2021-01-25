#!/bin/sh
#filename: disable_gss_for_broken_logins.sh
#description: a cloud user based user script to disable gss when logins fail. 
mydate=`date +%d/%b/%Y:%H:%M`
echo "$mydate: disable gss for broken logins" >> /tmp/changes.txt
sed -i 's/^GSS/\#GSS/g' /etc/ssh/sshd_config    
