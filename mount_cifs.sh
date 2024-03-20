#!/bin/bash
# filename: mount_cifs.sh
# description: to be run on a reboot. @reboot /root/mount_cifs.sh
# requirements: MYSERVER needs to be changed to the name of your fileserver. 
# with this example we created smb_user and .smbcred the .smbcred file holds the credentials in cleartext.
#
###example .smbcred file looks like this 
##domain=example
##username=smb_user
##password=cleartext
log_date_time=`date +'%m-%d-%Y-%H%M'`
LOG_FILE="/var/tmp/mount_script$log_date_time.log"
MYSERVER=windows


# Function to mount a CIFS share with retries
mount_cifs() {
    local source=$1
    local target=$2

    for i in {1..3}; do
        mount -v -t cifs "$source" "$target" -o file_mode=0777,dir_mode=0777,noserverino,credentials=/home/smb_user/.smbcred >> "$LOG_FILE" 2>&1

        if [ $? -eq 0 ]; then
            echo "$(date) - Mount successful: $source -> $target" >> "$LOG_FILE"
            return 0
        else
            echo "$(date) - Mount failed: $source -> $target (Attempt $i)" >> "$LOG_FILE"
            sleep 5
        fi
    done

    echo "$(date) - Failed to mount: $source -> $target after 3 attempts" >> "$LOG_FILE"
    return 1
}

# Function to unmount a share
unmount_share() {
    local target=$1

    umount "$target" >> "$LOG_FILE" 2>&1
}

# Main script
{
    echo "Starting mount script at $(date)" >> "$LOG_FILE"

    # Unmount existing shares
    unmount_share "/media/share"
    unmount_share "/media/imagery"

    # Mount the shares with retries
    mount_cifs "//$MYSERVER/WrkGrp" "/media/share"
    mount_cifs "//$MYSERVER/WrkGrp/ImageryServer" "/media/imagery"

    echo "Mount script completed at $(date)" >> "$LOG_FILE"
} || {
    echo "Error occurred during mount script execution. Check $LOG_FILE for details."
}
