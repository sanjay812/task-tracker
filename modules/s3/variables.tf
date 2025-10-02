variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket name"
  type        = string
  default     = "app-logs"
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}