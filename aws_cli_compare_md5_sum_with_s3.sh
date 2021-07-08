#get cleaned up json from aws cli
#getting filename, size, and md5sum
buck="sample-cve" #bucket
folder="clamav"
list=$(aws --output json --query 'Contents[*][Key,Size,ETag]' s3api list-objects --bucket $buck --prefix $folder| jq  -c '.[]')

#output looks like this: ["clamav/bytecode.cvd","\"4b84d0b6974c0618890ab963d1571e24\""]
counter=0

function check_for_local_equiv() {
   #echo check_for_local_equiv - $counter: $line
   filename=$(echo -n $line| cut -d, --output-delimiter ',' -f 1)
   size=$(echo -n $line| cut -d, --output-delimiter ',' -f 2)
   md5sum=$(echo -n $line| cut -d, --output-delimiter ',' -f 3)
   #echo s3 filename is $filename
   #echo s3 file size is $size
   #echo s3 file md5sum is $md5sum

   localpath="/var/lib/$filename"
   #echo "local file path is $localpath"
   error=0

   ##echo "running checks"
   if [[ -e $localpath ]]; then
     #check md5sum
     md5sum_local=$(md5sum $localpath| sed s/\ .*//g) #remove filename after the space


    #echo local is \'$md5sum_local\'
    #echo s3 is \'$md5sum\'

     if [[ "$md5sum_local" == $md5sum ]]; then
      echo -n ""
      #echo "good - md5sums match"
     else
       echo "md5sum does not match local: '$md5sum_local' vs s3: '$md5sum'"
       error=1
     fi
   else
     echo "$filename is missing on local machine"
     error=1 #file missing
   fi

   if [[ $error -eq '1' ]]; then
     s3path="s3://$buck/$filename"
     echo we need to get $s3path
     echo "local file is $localpath"
     cmd="aws s3 sync $s3path /var/lib/$folder/."
     echo "command to run is:  $cmd"
     $cmd
   fi


}



for line in $list
  do
   let counter=counter+1
   line=$(echo -n $line | tr -d '"\\[]') #clean up line - remove brackets from json and '"' character and "\" characters
   check_for_local_equiv
   #echo main - $counter : $line
  done
