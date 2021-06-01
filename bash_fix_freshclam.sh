#!/usr/bin/bash
#author: Theodore Knab
#date: 06/01/2021
#filename: bash_fix_freshclam.sh
#description: run and fix freshclam if needed.
#problem: running freshclamav occassionally hangs up on the daily.cld file. This seems to be a bug. #source https://forum.efa-project.org/viewtopic.php?t=3352

ERROR_OUTPUT=$(freshclam /dev/null 2>&1 /dev/null)

find_dailycld=$(find /var -iname 'daily.cld')



if [[ $ERROR_OUTPUT =~ "Can't add daily.hsb to new daily.cld" ]]; then
  echo error follows this line:
  echo We have issue adding to the daily.cld file.
  echo "removing $find_dailycld"
  rm $find_dailycld
  echo rerunning freshclam
  freshclam
else
  echo clean: freshclam may have run sucessfully
fi
