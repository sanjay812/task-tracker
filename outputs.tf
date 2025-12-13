output "instance_1_details" {
  value = {
    id         = module.ec2_instance_1.instance_id
    public_ip  = module.ec2_instance_1.public_ip
    private_ip = module.ec2_instance_1.private_ip
  }
}

output "instance_2_details" {
  value = {
    id         = module.ec2_instance_2.instance_id
    public_ip  = module.ec2_instance_2.public_ip
    private_ip = module.ec2_instance_2.private_ip
  }
}

output "instance_3_details" {
  value = {
    id         = module.ec2_instance_3.instance_id
    public_ip  = module.ec2_instance_3.public_ip
    private_ip = module.ec2_instance_3.private_ip
  }
}

output "security_group_id" {
  value = module.web_security_group.security_group_id
}