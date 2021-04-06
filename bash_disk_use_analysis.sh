#!/bin/bash
#filename: bash_disk_use_analysis.sh
#author: Theodore Knab
#date: 04/06/2021
#description: gathers information on how a set of disks are used.

folders_to_look_at="/modeling /archive /achive2"
folders_to_look_at="/mnt/c/Users/tknab/git"

for dir in $folders_to_look_at
do 
  echo my target directory is $dir
  #questions to answer
  #what is the total number of files in the target directory ?
  file_count=$(find $dir -type f |wc -l)
  echo Total number of files in $dir is $file_count
  #what is the total number of directories in the target directory ?  
  file_count=$(find $dir -type d| wc -l) 
  echo Total number of dirs in $dir is $file_count
  #how many small files do we have in the target directory ?
  small_files=$(find $dir -type f -size -10M| wc -l)
  echo Total number of small_files in $dir is $small_files
  #how many files have not been accessed in over 1 year
  large_files=$(find $dir -type f -size +1G| wc -l )
  echo Total number of large_files in $dir is $large_files
  large_and_med_files=$(find $dir -type f -size +10M| wc -l )
  echo Total number of large_and_med_files in $dir is $large_and_med_files
  #how many files have not been accessed in 60 days ?
  older_than_60_days=$(find $dir -type f -atime +60| wc -l)
  echo Total number of files older_than_60_days in $dir is $older_than_60_days

  #how many files were accessed the last 60 days
  younger_than_60_days=$(find $dir -type f -atime -60| wc -l)
  echo Total number of files younger_than_60_days in $dir is $younger_than_60_days

  #how many files were accessed in the last 10 days
  files_accessed_in_the_last_10_days=$(find $dir -type f -atime -10| wc -l)
  echo Total number of files_accessed_in_the_last_10_days in $dir is $files_accessed_in_the_last_10_days
done