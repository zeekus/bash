#!/bin/bash
#file: generic_bash_example_assign_args_to_variable.sh
#description: assigns arguments to a Variable in bash

variable=.
if [ $# -gt 0 ]; then
  variable=$@
fi

echo $variable
