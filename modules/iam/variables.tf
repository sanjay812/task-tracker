variable "user_name" {
  description = "Name of the IAM User"
  type        = string
  default     = "user-02"
}

variable "policy_arn" {
  description = "IAM policy ARN to attach"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
