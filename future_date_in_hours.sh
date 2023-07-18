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

# Calculate the difference in seconds between the input time and the current time
time_difference=$((target_time - current_time))

# Calculate the number of hours and minutes until the input time
hours_until_target=$((time_difference / 3600))
minutes_until_target=$(( (time_difference % 3600) / 60 ))

# Display the result
echo "There are $hours_until_target hours and $minutes_until_target minutes until $input_time"
