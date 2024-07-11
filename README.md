# FXC Intelligence Take Home Task- DevOps 
Thank you for choosing to do the take-home task for your FXC Intelligence interview process! Please don’t spend more than 2 hours on the task, and once complete, please send me a link to a GitHub repo with all relevant files for me to pass onto the team. 
Good luck, and if you have any questions, let me know! 
See task below: 
## Test 1 
1. Create a Terraform configuration that provisions an AWS EC2 instance in eu-west-2 region with following specs 
2. Instance type: t2.micro 
3. AMI: Amazon Linux 2 
4. Assign a public IP address to the instance 
5. Create a Security Group allowing SSH access from anywhere (0.0.0.0/0) 
6. Ouput the public IP address of the instance 
## Test 2 
Create a Terraform configuration to deploy a backup script that 
will run daily on an AWS EC2 instance . 
The script should create a backup of a specified directory and store it in an Amazon S3 bucket. 
Ensure the following requirements are met: 
1. Use the existing AWS EC2 instance created in Test 1 
2. The backup script should run daily at 2:00 am UTC 
3. The backup should be created in a directory named "backup" within the home directory of the EC2 user 
4. The script should compress the contents of the specified directory into a single tar.gz file 
5. The compressed backup file should be uploaded to an existing S3 bucket named "my-backup-bucket" with a timestamp in the filename 
6. Output the URL of the uploaded backup file 
Your Terraform configuration should include all necessary resources and configurations to fulfill these requirements
