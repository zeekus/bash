#!/bin/bash
#filename: cleanup_snapshots.sh
#author: Teddy Knab
#date: 12/14/2020
#description: clean up old snapshots

location_jq="/usr/bin/jq" #dependancy to parse the aws cli in json format
desired_runs=1000 #limit  desired_runs
debug=0 #set to 1 for debugging
regex_matcher="ec2ab_vol" #regular expression string to match
time_delay=5
this_many_days="300" #backups older than this many days

clear
printf "Warning. In %s seconds, %s snapshots with the name \'%s\' will be removed. Press Ctrl C to cancel.\n" $time_delay $desired_runs $regex_matcher
sleep $time_delay


if [[ -e $location_jq ]];then
   if [[ $debug -eq 1 ]]; then
     echo "debug: jq found ... running..."
     echo "debug: running $desired_runs cleanup sequences"
   fi
else
   exit
fi

#list of all the snapshots with regex_matcher
#list=$(aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] | select(.StartTime < "'$(date --date='-1 year' '+%Y-%m-%d')'") | [.Description, .StartTime, .SnapshotId]' | grep -i $regex_matcher -A 2 | grep -i snap)
list=$(aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] | select(.StartTime < "'$(date --date='-$this_many_days' '+%Y-%m-%d')'") | [.Description, .StartTime, .SnapshotId]' | grep -i $regex_matcher -A 2 | grep -i snap)

count=0 #counter
total_cleanup_size=0

for snap in $list
  do
    let count=($count+1)
    csnap=$(echo $snap | sed 's/"//g') #remove quotes

    if [[ $debug -eq 1 ]]; then
      aws ec2 describe-snapshots --snapshot-ids $csnap
    fi

    #creates a nested hash
    snapshot_description=$(aws ec2 describe-snapshots --snapshot-ids $csnap)

    desc=$(echo $snapshot_description| jq -r '.Snapshots[].Description') #description
    stime=$(echo $snapshot_description| jq -r '.Snapshots[].StartTime')
    volumesize=$(echo $snapshot_description| jq -r '.Snapshots[].VolumeSize')
    printf '\n%s > %s\n' $count "----------------------------------"
    printf '%s > Description: %s\n' $count $desc
    printf '%s > Start Time: %s\n'  $count $stime
    printf '%s > Volume Size: %s\n' $count $volumesize
    total_cleanup_size=$((total_cleanup_size + volumesize))

    tb_of_data=$(( total_cleanup_size / 1024))
    printf '%s > Total Cleanup Size: %s GB\n' $count $total_cleanup_size
    printf '%s > Total Cleanup Size: %s TB\n' $count $tb_of_data
    printf 'running... aws ec2 delete-snapshot --snapshot-id %s'  $csnap
    aws ec2 delete-snapshot --snapshot-id $csnap
    if [[ $? -eq 0 ]]; then
       printf '%s > %s\n' $count "successful"
    else
       printf '%s > %s\n' $count "failed"
       exit
    fi

    #end after count equals desired desired_runs
    if [ $count -eq $desired_runs ]; then
     exit
    fi
  done
