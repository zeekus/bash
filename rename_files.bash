#!/bin/bash
#filename: rename_files.bash
#description: removes c6 from a group of files with the prefix.  

files=$(ls)
match_string="c6"

for file in $files
  do
    if [[ $file  == *"$match_string"* ]]; then
       new_file=$(echo $file | sed -e s/c6//g)
       mv $file $new_file
    fi
  done
