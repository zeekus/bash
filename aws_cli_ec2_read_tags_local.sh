 #!/bin/bash
 #filename: aws_cli_ec2_read_tags_local.sh
 #description: read local host's aws tags
 instance-id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
 aws ec2 describe-tags --filters "Name=resource-id,Values=${instance-id}
 
 availabiltiy-zone=$(curl -s http://169.254.169.254/latest/meta-data/availabiltiy-zone)
 