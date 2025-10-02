# Name of the EC2 instance
ec2_name = "ec2-02"
# Key pair name (you can create this in AWS if it doesn't exist)
key_name = "my-terraform-key"

# Name of the IAM user
user_name = "ec2-s3-user"

# Prefix for the S3 bucket (the random suffix will be appended automatically)
bucket_name_prefix = "app-logs"

# Name of the Security Group
sg_name = "02-sg"

# AWS Region
aws_region= "ap-south-1"