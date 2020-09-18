#!/bin/bash
#Author: Theodore Knab
#date: 5/11/2020
#filename: puppet_backup_db_to_s3.bash
#description: runs backups of puppet. Data is stored in /var/puppetlabs/backups/ by default
#we move to s3
debug=0
my_s3_bucket="my_s3_bucket_name"
myhost=$(hostname| awk -F"." {'print $1'})
/opt/puppetlabs/bin/puppet-backup  create

file_list=$(find  /var/puppetlabs/backups -type f)
for file in $file_list
  do

  if [ $debug == 1 ] ; then
    echo "aws s3 mv $file s3://$my_s3_bucket/puppet/$myhost/ --dryrun"
    aws s3 mv $file s3://$my_s3_bucket/puppet/$myhost/ --dryrun
  else
    echo "aws s3 mv $file s3://$my_s3_bucket/puppet/$myhost/ "
    aws s3 mv $file s3://$my_s3_bucket/puppet/$myhost/
  fi
  done
