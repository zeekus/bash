#!/bin/bash
#filename: backup_openvpn_as.sh
backup_destination="/root/backup"


which apt > /dev/null 2>&1 && apt -y install sqlite3
which yum > /dev/null 2>&1 && yum -y install sqlite
cd /usr/local/openvpn_as/etc/db
[ -e config.db ]&&sqlite3 config.db .dump>$backup_destination/config.db.bak
[ -e certs.db ]&&sqlite3 certs.db .dump>$backup_destination/certs.db.bak
[ -e userprop.db ]&&sqlite3 userprop.db .dump>$backup_destination/userprop.db.bak
[ -e log.db ]&&sqlite3 log.db .dump>$backup_destination/log.db.bak
[ -e config_local.db ]&&sqlite3 config_local.db .dump>$backup_destination/config_local.db.bak
[ -e cluster.db ]&&sqlite3 cluster.db .dump>$backup_destination/cluster.db.bak
[ -e notification.db ]&&sqlite3 notification.db .dump>$backup_destination/notification.db.bak
cp ../as.conf $backup_destination/as.conf.bak
