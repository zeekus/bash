#!/bin/bash
#filename: bash_regex_match_test.sh
#descritpion: regex matching with bash

regex_match="kernel"
list="kernel1-123 kernel2-123"
for value in $list
do
  if [[ $value =~ "$regex_match" ]];then
     echo match t: $regex_match is v:$value
  fi
done
