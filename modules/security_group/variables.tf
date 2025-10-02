variable "name" {
  description = "Name of the Security Group"
  type        = string
  default     = "02-sg"
}

variable "description" {
  description = "Description of the Security Group"
  type        = string
  default     = "Managed by Terraform"
}


variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}
