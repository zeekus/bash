# find files with spaces in them
find . -type f -name "* *" -exec ls -lah {} ';' 


# find files with no space in the name
find . -type f ! -name "* *" -exec ls -lah {} ';' | wc -l

#find files that have been changed in last 24 hours
find . -mtime -1

#find files that have been changed in last 6 hours
find . -mtime -0.25

#find files that have been changed in last 1 hour
find . -mtime -0.0417

#find files owned by root in current directory
find . ! -user root  -exec ls -lah {} ';'

#find files owned by root in home_dir
find ~ -user root  -exec ls -lah {} ';'

#find files that do not have the group set for modeling and change them 
find /modeling ! -group modeling -exec chgrp modeling {} ';'

#find the orphan sym links in a directory and remove them


