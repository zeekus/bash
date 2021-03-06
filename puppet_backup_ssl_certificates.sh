#!/bin/bash
#file: puppet_backup_ssl_certificates.sh
#description: backup puppet ssl certificates for a 2018 instance of PE
folders="/etc/puppetlabs/puppet/ssl
/etc/puppetlabs/puppetdb/ssl 
/opt/puppetlabs/server/data/console-services/certs
/opt/puppetlabs/server/data/postgresql/9.6/data/certs
/etc/puppetlabs/orchestration-services/ssl"

today=`date +%Y%m%d`

backup_name="my_puppet_ssl_files_$today.tar"

for folder in $folders
  do
   if [ -e $folder ]; then
     echo found $folder
     tar --append --file=$backup_name $folder
   fi
  done
