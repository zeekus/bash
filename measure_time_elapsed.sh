#!/bin/bash
#description: differnt ways to format numbers and caclulate time with bash.

start_time=$(date +%s)
SECONDS=0

printf "sleeping for 3 seconds\n"
sleep 3
elapsed=$(($(date +%s) - start_time))
printf "Finished in %02d:%02d:%02d\n" $((elapsed/3600)) $((elapsed%3600/60)) $((elapsed%60))
echo "Finished in $(printf '%02dh:%02dm:%02ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))"

printf "sleeping for 60 seconds\n"
sleep 60 

# Do your stuff here
elapsed=$(($(date +%s) - start_time))
printf "Finished in %02d:%02d:%02d\n" $((elapsed/3600)) $((elapsed%3600/60)) $((elapsed%60))
echo "Finished in $(printf '%02dh:%02dm:%02ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))"
