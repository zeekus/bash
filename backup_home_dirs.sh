#!/bin/bash
#filenames: backup_home_dirs.sh
#description: backups up all the home directories.
#use run this in /root, /tmp or /var/tmp

path="/home"                                    # backup path
host=$(hostname|cut -d"." -f1 )                 # get first part of hostname
backup_day=$(date +%m_%d_%Y)                    # get date
homedirs=$(ls $path)                            # get all hom dirs in path
backup_location="/root/backups"

echo "filename will be $filename"


for dir in $homedirs
  do
    echo "$path/$dir"
    filename=$host"_"$backup_day"_"$dir.tar.gz
    echo "filename will be $filename"
    size_of_dir=$(du -hs $path/$dir)
    echo "$size_of_dir"
    tar -czvf "$backup_location/$filename" "$path/$dir"
  done
