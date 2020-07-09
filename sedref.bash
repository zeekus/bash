#!/bin/bash
#filename: sedref.bash
#description: sed replace reference

#find all files with pp and replace clean_metadata with centos6_clean_metadata
sed -i  's/clean_metadata/centos6_clean_metadata/g' $(find . -type f -name '*.pp')

#Converted all my names using sed: 
sed -i 's/ec2_fw/centos6_legacy_ec2_fw/g' *.pp

