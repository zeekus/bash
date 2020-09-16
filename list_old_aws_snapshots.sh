#!/bin/bash
#author: Theodore Knab
#description: searches and returns a list of snapshots from AWS CLI
#filename: list_old_aws_snapshots.sh
#requirements jq a json parser

jqbinary=/usr/bin/jq #jq binary
date_limit='-1 year' #older than 1 year

if [[ -e "$jqbinary" ]]; then
 #aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] | select(.StartTime < "'$(date --date='-1 year' '+%Y-%m-%d')'") | [.Description, .StartTime, .SnapshotId]'
 aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] | select(.StartTime < "'$(date --date='($date_limit)' '+%Y-%m-%d')'") | [.Description, .StartTime, .SnapshotId]'
else
 echo "missing requirement of $jqbinary"
 exit 1
fi
