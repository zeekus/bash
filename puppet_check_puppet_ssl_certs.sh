#!/bin/bash
#filename: puppet_check_puppet_ssl_certs.sh
#description: check expirations on puppet certificates.
#author: Teddy Knab


list_of_files=$(find /etc/puppetlabs/puppet/ssl -iname '*.pem')
#echo $list_of_files
for file in $list_of_files
  do
    expiration=$(cat $file | openssl x509 -enddate -noout 2>> /dev/null)

    if [ ! -z "$expiration" ]; then
      echo $file $expiration
    fi
  done

