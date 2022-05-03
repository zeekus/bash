#!/bin/bash
#filename: aws_convert_an_ec2_image_to_a_pcluster_image.sh
#description: ec2 and pcluster use seperate environments. A conversion is needed.
#The images files from ec2 need to move to the pcluster accessible stack.

generate_a_yaml_file(){

my_output_file="/var/tmp/custom_hpc_ami.yaml"

cat >> $my_output_file << EOL
#how to run: pcluster build-image --image-id myfirst --image-configuration /var/tmp/custom_hpc_ami.yaml
Region: us-east-1
Image:
  Name: "custom AMI for Pcluster 3"
Build:
EOL
  echo "  ParentImage: $latest_image" >> $my_output_file
  echo "  InstanceType: c4.8xlarge" >> $my_output_file
}

latest_image=$(aws ec2 describe-images --owner self --output json --filters Name="name",Values="hpc-ready-os*" --query 'sort_by(Images, &CreationDate)[*].[ImageId]' --output text | tail -1)
generate_a_yaml_file

echo "move image to pcluster stack"
mydate=$(date +%m_%d_%Y)
pcluster build-image --image-id hpc_$mydate --image-configuration $my_output_file
