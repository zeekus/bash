#!/bin/bash
#filename: generic_reference_sed.bash
#description: sed replace reference

#find all files with pp and replace clean_metadata with centos6_clean_metadata
sed -i  's/clean_metadata/centos6_clean_metadata/g' $(find . -type f -name '*.pp')

#Converted all my names using sed: 
sed -i 's/ec2_fw/centos6_legacy_ec2_fw/g' *.pp


#remove quotes from string
quoted_str=\"something\"
echo 1 $quoted_str
unq_string=$(echo $quoted_str| sed 's/"//g')
echo 2 $unq_sring


