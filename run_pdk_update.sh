#!/bin/bash
#file: pdk_conver_puppet.bash
#description: converts puppet modules in current directory to use PDK stuff. Normally, it just addes meta data. Note user still needs to press 'Y' when run.
#use at your own risk
#author: Theodore Knab
#wrote: 5/29/2020
my_dirs=$(ls -D)
for repo in $my_dirs
  do
    full_path="$PWD/$repo"
    echo $full_path
    test -d $full_path 
    if true; then
      cd $full_path
      pdk convert; pdk update; pdk validate; pdk test unit
      git add --all; git commit -am "rework modules to use pdk" ; git push
      cd ..
    fi 
  done
