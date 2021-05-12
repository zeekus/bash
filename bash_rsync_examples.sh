
#dry run using apache user from host server_b to server_a with server_a as the origin

#change to apache user and override shell
su -s /bin/bash - apache 

#orgin server_a
rsync --dry-run -av apache@server_b:/var/www/html/documents/targe_files* /var/www/efs/share/documents/

#sudo on both ends copying files using centos user

#copy data using ssh key of magical_key and sudoing results to /home/zeekus on remote host
#
#Summary of actions**
#-sudo on both ends
#-user is centos on both ends
#-orgin is copying /home/zeekus to /home/zeekus to remote preserving permissions

#test run
sudo rsync -avxP --rsync-path="sudo rsync" -e "ssh -i /home/centos/.ssh/magical_key.pem" /home/zeekus/test/ centos@192.168.1.100:/home/zeekus/test/ --dry-run

#full home dir
sudo rsync -avxP --rsync-path="sudo rsync" -e "ssh -i /home/centos/.ssh/magical_key.pem" /home/zeekus/ centos@192.168.1.100:/home/zeekus/ --dry-run

#full home with 2GB limit on size of files
sudo rsync -avxP --rsync-path="sudo rsync" --max-size=2G -e "ssh -i /home/centos/.ssh/magical_key.pem" /home/sam/ centos@192.168.1.100:/home/sam/


