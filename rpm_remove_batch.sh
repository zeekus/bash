#!/bin/bash
#filename: rpm_remove_batch.sh
#description: remove a bunch of rpm packages
TEST=1
if [ $TEST == 1 ]; then
  rpm -e --test -vv $(rpm -qa 'php*') 2>&1 | grep '^D:     erase:'
else
  rpm -e  $(rpm -qa 'php*') 2>&1 | grep '^D:     erase:'
fi
