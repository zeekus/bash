#!/bin/bash
#filename: backup_puppet_and_send_to_s3.sh
#author: Theodore Knab
#date: 01/29/2021
#description: backs up puppet and sends it to an s3 bucket
#requirements: aws-cli, aws-crendentials or role, an s3 bucket

debug=1

#get my hostname
myhost=$(hostname| awk -F"." {'print $1'})

s3_bucket="puppet-backups/$myhost/"

#backup puppet
/opt/puppetlabs/bin/puppet-backup  create

#this creates a backup log 
#get the last backup filename from the backup log
backup_file_name=$(cat /var/log/puppetlabs/pe-backup-tools/backup.log | tail -1| sed -e s/.*filename:\ //g | sed -e s/\)$//g)

if [[ -e $backup_file_name ]];then
  if [ $debug == 1 ] ; then
    mycmd="aws s3 mv $backup_file_name s3://$my_s3_bucket/puppet/$myhost/ --dryrun"
    logger "running $mycmd"
    $mycmd
  else
    mycmd="aws s3 mv $backup_file_name s3://$my_s3_bucket/puppet/$myhost/ "
    logger "running $mycmd"
    $mycmd
  fi
else
  echo "error we can't find  the backup file called '$backup_file_name'"
fi