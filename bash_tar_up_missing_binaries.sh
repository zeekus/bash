#!/usr/bin/bash
#filename: tar_up_missing_binaries.sh
#description: this will build a put a bunch of binaries in a giant tar file.

list="missing_binaries.txt" # you need to generate this 'hosta>> rpm -qa  > packagehostA.txt' hostb>> rpm -qa > packagesostB.txt'

echo > /tmp/rebuild_list.txt # clear list

packages_to_ignore="gpg-pubkey kernel mysql-libs puppet-agent amazon-cloudwatch-agent samba"

#main check to make sure list exists
if [ -f $list ]; then
  echo file $list found preceeding
  echo $(wc -l $list) will be added to the tar file

  #find each binary from the list
  for binary in `cat $list`
  do
    echo $binary is missing
    #list troublesome packages to ignore
    for target in $packages_to_ignore
      do
       if [[ $binary =~ "$target" ]] ; then
          #don't do anything with the troublesome packages
          echo igonoring $binary
          parsed_binary=$(echo $binary| sed -s s/\.el6.*//g)
       else
          parsed_binary=$(echo $binary| sed -s s/\-[0-9].*//g)
          echo $parsed_binary is missing
          rpm -qal | grep -i $parsed_binary
          rpm -qal | grep -i $parsed_binary >> /tmp/rebuild_list.txt
       fi
      done
    tar czvf /tmp/missing_binaries.tar.gz -T /tmp/rebuilt_list.txt
  done
else
  echo file $list not found
fi
