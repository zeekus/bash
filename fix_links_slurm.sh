#!/bin/bash
#filename: fix_links_slurm.sh
#author: Teddy Knab
#date: 08/31/2021
#######################################
#description: fix some binary locations after slurm from yum messes up the slurm daemon on pcluster.
#######################################

binaries=$(ls /opt/slurm/bin/) #get a list of the slurm binaries

#step through the list of binaries
for i in $binaries 
do
   binary="/usr/bin/$i" #binary file name

   #test to make sure the new binary file exists
   #slurm from yum puts the binaries in /usr/bin/srun for example.  
   if test -f "$binary"; then
      echo removing $binary
      rm $binary
      echo creating symbolic link running ln -s /opt/slurm/bin/$i $binary
      ln -s /opt/slurm/bin/$i $binary
   else
      echo $i is something other than a file ignoring:  ls -lah $binary
   fi

done
