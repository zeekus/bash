#!/bin/bash
#filename: reboot_if_no_interactive_users.sh
#description: reboot host if uptime is over 14 days and no interactive users are active.

# Check for interactive users
users_logged_in=$(who | wc -l)

# Get the system uptime in days 86400 seconds = 1 day
uptime_days=$(awk '{print int($1/86400)}' /proc/uptime)

# Check if the uptime is greater than or equal to 14 days
if (( uptime_days >= 14 )); then
    echo "Condition 1: Uptime is greater than or equal to 14 days"

    if (( users_logged_in == 0 )); then
        echo "No interactive users are logged in."
        echo "Reboot will occur."
        reboot
    else
        echo "Condition 2: There are $users_logged_in interactive users logged in."
        echo "No reboot will occur."
    fi
fi
