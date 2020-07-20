#!/bin/bash
#check_puppet_ssl_with_email.sh
#author: someone on the puppet slack channel 
MAILTO='root'
OPENSSL='/opt/puppetlabs/puppet/bin/openssl'
TMPFILE=$(mktemp)
trap "rm -f ${TMPFILE}" EXIT
shopt -s nullglob
for f in /etc/puppetlabs/puppet/ssl/ca/ca_crt.pem /etc/puppetlabs/puppet/ssl/ca/signed/*.pem; do
  expire_date="$(${OPENSSL} x509 -enddate -noout -in ${f})"
  ${OPENSSL} x509 -checkend $(( 86400 * 30 )) -noout -in ${f} &> /dev/null
if [[ $? != 0 ]]; then
  CERT=${f##*/}
  echo ${CERT%.pem} : ${expire_date##*=} >> ${TMPFILE}
fi
done
if [[ -s $TMPFILE ]] ; then
  if [[ -t 1 ]] ; then
    cat ${TMPFILE} | cut -d' ' -f1
  else
    cat ${TMPFILE} | mailx -s "Puppet Certs Expiring" $MAILTO
  fi
fi
