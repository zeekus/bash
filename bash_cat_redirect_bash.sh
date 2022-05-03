#!/bin/bash
#filename: cat_redirect.sh
#description: redirects text to myfile.txt

cat >> myfile.txt << EOL

test 1

test 2

test 3

EOL
