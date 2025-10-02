output "access_key_id" {
  description = "Access Key ID for the EC2 IAM user"
  value       = aws_iam_access_key.ec2_s3_access_key.id
}

output "secret_access_key" {
  description = "Secret Access Key for the EC2 IAM user"
  value       = aws_iam_access_key.ec2_s3_access_key.secret
  sensitive   = true
}