resource "aws_security_group" "this" {
  name        = var.name
  description = var.description

}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  for_each = {
    for idx, rule in var.ingress_rules : idx => rule
  }

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  description = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
