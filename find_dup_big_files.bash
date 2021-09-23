#!/bin/bash
#filename: find_dup_big_files.bash

path_to_check="/mydata"

get_list=$(find $path_to_check -maxdepth 1 -type d )

counter=0

for foldername in $get_list
  do
    let counter++
    if [[ $counter -ne 1 ]]; then
      echo $counter $foldername
      logname=$(echo -n $foldername| sed -e s/\\/mydata\\//log_/g ).txt #sed replace to remove "/" characters from path
      echo logfile: $logname
      size_in_gb=$(du -hs $foldername)
      echo size: $size_in_gb

      if [[ $size_in_gb =~ "G" ]];then
         echo size of directory is $size_in_gb
         #one meg file
         #todo check to see if rdfind exists
         rdfind -minsize 1048576 -dryrun true -outputname $logname $foldername
      fi

    else
      echo not checking on $counter $foldername
    fi
  done
