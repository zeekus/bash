#!/bin/bash
#filename: centos7_sview_install_on_aws_pcluster3.sh
#description: allows user to install sview on a aws-parallelcluster as a no dep
#tested with Centos7 on aws-pcluster3
#author: Theodore Knab
#date: 12/3/21
#Copyright (C) 2007 Free Software Foundation, Inc
#licence ref GPL https://www.gnu.org/licenses/gpl-3.0.txt

#download rpm
yum install slurm-gui --downloadonly

#install rpm with no deps
rpm -ivh /var/cache/yum/x86_64/7/epel/packages/slurm-gui-20.11.8-2.el7.x86_64.rpm --nodeps

#put slurm libaries where sview expects them. 
slurm_libs=$(ls /opt/slurm/lib/slurm)
mkdir -p /usr/lib64/slurm/
for file in $slurm_libs
do
  echo $file
  ln -s /opt/slurm/lib/slurm/$file /usr/lib64/slurm/$file
done

#one more library needed for sview to run
ln -s /opt/slurm/lib/slurm/libslurmfull.so /usr/lib64/libslurmfull-20.11.8.so


#remove if empty dir
if [ -e /etc/slurm ]; then 
  rmdir /etc/slurm
fi 

#put the configs in a place sview can find them
#create symbolic link so sview can find the configs
ln -s /opt/slurm/etc /etc/slurm
