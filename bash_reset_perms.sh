#!/bin/bash
#filename: bash_reset_perms.sh
#description: using find to reset permissions of files in /var/www/html

#find every file that doesn't have group write access and add it
find /var/www/html -type f ! -perm -g=w -exec chmod 665 {} ';'

#find files without group 48 ( apache )
find /var/www/html -type f ! -gid 48 -exec ls -lah {} ';'
