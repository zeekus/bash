#!/bin/bash
#filename: mount_notify.sh
#description: check mountpoint cron

mountpoints="/media/share /media/imagery"
myemail="myuser@myexample.com"

for mount in $mountpoints
do

  if mountpoint -q "$mount"; then
    echo "$mount is a mountpoint"
  else
    echo "$mount is not a mountpoint"
    echo "missing imagery mountpoints" | mail -s "missing mount point $mount on lgis3d" $myemail
  fi
done
