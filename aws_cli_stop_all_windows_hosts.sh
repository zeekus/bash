#filename: stop_all_windows_instances.sh
#description: stop_all_windows_instances.sh

list=$(aws ec2 describe-instances --filters Name=platform,Values=windows --query "Reservations[*].Instances[*].{Instance:InstanceId}"  --output text)
myregion="us-east-1"
for host in list
do 
  aws ec2 stop-instance --region $myregion --instance-id $host
done
