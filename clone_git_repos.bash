#!/bin/bash
#filename: clone_git_repos_with_ssh.sh
#author: Theodore Knab
#date: 5/19/2020
#description: sync all known repos to aws s3

list_of_repos="bash perl puppet-apache python ruby"
mydate=`date +%m_%d_%Y_%H%M`
bucket="mys3bucket_name"
proto="ssh" #or https
#git info
username='zeekus'
password=""

mkdir git_$mydate

#change to dir just created
cd git_$mydate


for url in $list_of_repos
  do 
    echo $myurl
    echo "protocol is $proto"
    if [ $proto == "ssh" ]; then
      myssh="git@github.com:$username/$url.git"
      git clone $myssh
    else 
      if [ $password -eq "" ]; then
	 echo "no password given exiting... We need a password."
	 exit 1
      else
         myhttp="https://$username:$password@github.com/$username/$url.git"
         git clone $myhttp
      fi
    fi
    #error checking exit on error
    if [[ $? -ne 0 ]]; then
      echo "exiting on error"
      exit 1
    fi
  done


#go back to orginal directory
cd ..
#sync this to aws
##aws s3 sync git_$mydate s3://$bucket/git_$mydate/

#sync file
##aws s3 cp clone_git_repos_with_ssh.sh s3://$bucket/

