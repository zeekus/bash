#!/bin/bash
#author: Teddy Knab
#description: get sar logs in LC_ALL=C format so they work.
#These Text filescan be used in kSar to graph the atsar data.

for x in $(seq 31)
 do
   printf "$x\n"
   if [ $x -lt 10 ]; then
     LC_ALL=C sar -A -f /var/log/sa/sa0$x > sa0$x.txt
   else
     LC_ALL=C sar -A -f /var/log/sa/sa$x > sa$x.txt
   fi
 done
