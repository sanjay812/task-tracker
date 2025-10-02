output "ec2_public_ip" {
  description = "EC2 Instance public IP"
  value       = module.ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}


output "iam_access_key_id" {
  description = "IAM Access Key ID"
  value       = module.iam.access_key_id
}

output "iam_secret_access_key" {
  description = "IAM Secret Access Key"
  value       = module.iam.secret_access_key
  sensitive   = true
}
