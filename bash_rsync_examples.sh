
#dry run using apache user from host server_b to server_a with server_a as the origin

#change to apache user and override shell
su -s /bin/bash - apache 

#orgin server_a
rsync --dry-run -av apache@server_b:/var/www/html/documents/targe_files* /var/www/efs/share/documents/
