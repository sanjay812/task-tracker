variable "aws_region" {
  type = string
}

variable "ec2_name" {
  description = "Name of the Security Group"
  type        = string
}

variable "key_name" {
  type = string
}

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}

variable "user_name" {
  description = "Name of the IAM User"
  type        = string
}

variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket name"
  type        = string
}