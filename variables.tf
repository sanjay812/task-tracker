/*variable "ingress_rules" {
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
}*/
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}
