#!/bin/bash
#file: generate_readme.bash
#date: 5/29/2020
#author: Theodore Knab
#description: generates a readme.md file by scanning files in directory

filename="README.md"

##################
generate_readme() {
##################
  test -e "$filename"
  if [ $? == 0 ] ; then
     echo "We have a $filename over writing file."
     # " '$0'"
     echo "" > $filename
  else
    echo "Sorry. No $filename found. Creating. $filename \n"
    touch $filename
  fi

  echo "Most of it is just for fun. 
  It showcases some of things I can do.
  Filename | Description | Language
  ----------- | ----------- | ----------" > $filename

}

filelist=$(ls)
generate_readme #generate header file

for myfile in $filelist
  do
  echo $myfile
  my_desc=$(grep -i "^#descr" $myfile)
  my_desc=`echo "${my_desc//\#}"` #remove # symbol
  my_lang=$(head -1 $myfile| sed -e s/*//g )
  if [ $myfile != $filename ]; then
    echo "$myfile   |  $my_desc | $my_lang " >> $filename
  fi 
  done


