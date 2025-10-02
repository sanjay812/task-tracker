variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
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
