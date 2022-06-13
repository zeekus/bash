#get a list of the top 100 largest directories in home with a low threshold of 1GB
#sort data in reverse order with the highest number first
du -ah -t 1G /home | sort -r -n  | head -100 


