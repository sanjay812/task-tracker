variable "ec2_name" {
  description = "Name of the Security Group"
  type        = string
}

variable "instance_type" {
  type = string
  default = "t3.xlarge"
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"

}
