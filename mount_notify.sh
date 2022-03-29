#!/bin/bash
#filename: mount_notify.sh
#description: check mountpoint cron

mountpoints="/media/share /media/imagery"
myuser="someuser@someip.net"
mycopy="myuser@someip.net"

for mount in $mountpoints
do

  if mountpoint -q "$mount"; then
    echo "All Ok.. $mount is a mountpoint"
  else
cat << EOL |  mutt -s "missing imagery mountpoints" $myuser -c $mycopy -F /root/muttrc
It appears that we are missing the imagery Mountpoints.
Please mount them ASAP.

Directions:
       mount -t cifs -o username=myuser,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm  //server1/WrkGrp  /media/share
       mount -t cifs -o username=myuser,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm //server2/ImageryServer /media/imagery
EOL
exit
  fi
done
