#!/bin/bash
#fix_yum_issues.sh
#description: cleanup yum db and update
echo clean up databases
rm -f /var/lib/rpm/__db*
echo rebuild package database
db_verify /var/lib/rpm/Packages
rpm --rebuilddb
yum clean all
echo remove orphans if they exist.
rm -f /var/lib/rpm/__db*
echo run update
yum update
