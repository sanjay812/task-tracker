output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.pub-subnet.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.pub-subnet.*.cidr_block
}