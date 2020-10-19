#!/bin/bash
#filename: host_gaps.sh
#author: Theodore Knab
#date: 10/19/2020
#description: host gaps and fill them by using the available hostname

target_name="nagios"
next_host_to_use=""
my_domain_target="aws.example.net"
limit=15

find_next_host_to_use() { 

 used_hostnames=""
 available_hostnames=""
 
 
 for i in $(seq 0 $limit)
 do 
  #echo debug-looking up $target_name$i.$my_domain_target
  lookup_host=$(host "$target_name$i.$my_domain_target")
  if ( test $? -eq 0); then 
    echo taken host: $lookup_host
    used_hostnames="$used_hostnames $target_name$i.$my_domain_target"
  else 
     available_hostnames="$available_hostnames $target_name$i.$my_domain_target"
  fi
  done

  for myhost in $available_hostnames
  do
   #echo we will use $myhost
   next_host_to_use=$myhost
   break
  done
}

find_next_host_to_use
echo  $next_host_to_use will be the next host we use

