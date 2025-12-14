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