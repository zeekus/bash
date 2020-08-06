#!/bin/bash
#filename: reset_firewalld_to_default.sh
#description: removes any firewall customization and reverts to OS version. 
rm -f /etc/firewalld/zones/*
cp /usr/lib/firewalld/zones/* /etc/firewalld/zones/.
firewall-cmd --reload
echo "default firewall applied"
systemctl status firewalld
