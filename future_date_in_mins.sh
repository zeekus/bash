#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 TIME"
  exit 1
fi

# Format the input time as YYYY-MM-DD HH:MM
input_time=$(date -d "$1" +"%Y-%m-%d %H:%M")

# Get the current time in seconds since the Unix epoch
current_time=$(date +%s)

# Get the input time in seconds since the Unix epoch
target_time=$(date -d "$input_time" +%s)

# Calculate the number of minutes until the input time
minutes_until_target=$(( (target_time - current_time) / 60 ))

# Display the result
echo "There are $minutes_until_target minutes until $input_time"
