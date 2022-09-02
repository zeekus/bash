#!/bin/bash
#filename: backup_symbolic_links.sh
#description: make a list of symlink and generate the code to recreate them in new location.

mydate=$(date +%m_%d_%Y_%H%M)

help() {
  echo "You ran '$0' with no arguments or with an invalid arguement."
  echo "use type '$0' and follow it with a directory."
  echo "directory '$@' does not exist."
 }

build_script_for_symlinks() {
  for line in $(cat $myfile):
  do
     dest=$(ls -lah $line|awk -F ' -> ' {'print $2'} )
     char_count=$(echo $dest| wc -c | awk '{ print $1}')
     mytest=$?
     if [[ $mytest -eq 0 && $char_count -gt 1 ]]; then
        echo "ln -s $line $dest" >> $myshell
     else
        echo "$dest not found ignoring"
     fi
  echo "generated link rebuild script here: $myshell"
  done
}

myshell=/var/tmp/rebuild_links.sh

for dir in "$@"
do
  if [ -d $dir ];then
    echo "dir is $dir";
    myfile="/var/tmp/symlinks_$mydate.txt"
    echo "generate a list of symbolic links and write output to '$myfile'"
    find $dir -type l -exec ls {} ';' > $myfile
    mycount=$(cat $myfile| wc -c | awk '{ print $1}')
    if [[ $mycount -gt 0 ]];then
       echo "mycount is $mycount"
       build_script_for_symlinks
    else
       echo "removing empty file before exiting '$myfile'";
       rm $myfile;
       exit;
    fi
    exit;
  fi
done

echo "error no data"
help
