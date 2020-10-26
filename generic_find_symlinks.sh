#!/bin/bash
#filename: generic_find_symlinks.sh
#description: find symbolic links 
#source: https://stackoverflow.com/questions/5767062/how-to-check-if-a-symlink-exists

default_backup_location="/var/puuppet/backups"
real_backup_location="" #could be /var/tmp if default location is a sym link to /var/tmp
if [ -e "$default_backup_location" ]; then
    if [ ! -L "$default_backup_location" ]
    then
        echo "you entry is not symlink"
        real_backup_location="$default_backup_location"
    else
        echo "your entry is symlink"
        real_backup_location="/var/tmp"
    fi
else
  echo "=> File doesn't exist"
fi
