resource "aws_instance" "this" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.security_group_id]
  user_data       = var.user_data

  tags = {
    Name = var.instance_name
  }
}