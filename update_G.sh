#!/bin/bash
#filename: update_G.sh
#description: update GTB and GWB from Europe

binary_files="GTB-Fedora.x86_64.rpm  GWB-Fedora.x86_64.rpm"
urls="https://ies-ows.jrc.ec.europa.eu/gtb/GWB/GWB-Fedora.x86_64.rpm https://ies-ows.jrc.ec.europa.eu/gtb/GTB/GTB-Fedora.x86_64.rpm"

cd /var/tmp #change to staging area

#clean out files
for file in $binary_files
do
  rm -f $file
done

#get the binaries
for url in $urls
do
  wget $url
done

#update the files
for file in $binary_files
do
  yum -U $file
done

#send email about update

