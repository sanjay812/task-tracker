variable "name" {
  description = "Name of the Instance"
  type        = string
  default     = "app-ec2"
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
  default= "my-terraform-key"
}


variable "security_group_ids" {
  type = list(string)
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"  
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}