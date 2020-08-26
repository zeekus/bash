#!/bin/bash
#file: assign_args_to_variable.sh
#description: assigns arguments to a Variable in bash

variable=.
if [ $# -gt 0 ]; then
  variable=$@
fi

echo $variable
