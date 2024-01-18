#!/usr/bin/bash
#filename: check_cpus_and_info.sh
#description: check cpu, hostname, cpu, type of kernel used, and if efa is enabled
#how to run from slrum: srun -N 2 check_cpus_and_info.sh
cpu=$(awk -F: '/model name/ {cpu=$2} END {print cpu}' /proc/cpuinfo)
hostname=$(hostname)
echo "hostame -  " $hostname
echo "$hostname - cpu: $cpu"
echo "$hostname - kernel processor: " `uname -p`
echo "$hostname - efa: " `fi_info -p efa`
