variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    cidr_block = string
    from_port  = number
    to_port    = number
    protocol   = string
    description = string
  }))
}

variable "user_data"{
    type = string
} 

variable "ec2_instances" {
  description = "EC2 instances configuration"
  type = map(object({
    instance_type = string
    ami           = string
  }))
}