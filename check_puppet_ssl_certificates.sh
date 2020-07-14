#!/bin/bash
#filename: check_puppet_ssl_certs.sh
#description: check expirations on puppet certificates.

cat ($find /etc/puppetlabs/puppet/ssl -iname 'ca.pem') | openssl x509 -enddate

list_of_files=$(find /etc/puppetlabs/puppet/ssl -iname '*.pem')
for file in $list_of_files
  do
    expiration=$(cat $file| openssl x509 -enddate)
    echo $file $expiration
  done

