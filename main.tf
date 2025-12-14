/*module "security-group" {
  source = "./modules/security-group"
  name        = "web_sg"
  description = "Allow inbound traffic on ports 22 and 80"
  ingress_rules = var.ingress_rules
}



# Create multiple EC2 instances using for_each
module "ec2" {
  source   = "./modules/ec2"
  for_each = var.ec2_instances

  ami               = each.value.ami
  instance_type     = each.value.instance_type
  instance_name     = "tf-${each.key}"
  key_name          = "demo_key"
  security_group_id = module.security-group.security_group_id
  user_data         = var.user_data
}

resource "aws_key_pair" "ssh_public_key" {
  key_name = "demo_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpFHzGZHOROcfebq0N5FbbTHhT/RSCmWNTm8Wmk5CchXZYRxiSEuwKDu0ovtoKPugFp14BSgVT0kFP0FQy20bNJKQkmFmo7lEjHqK18gJH5+RF8TOqC/aiTIyv8x8YfmcnocgQjHJq4lr4gAdA9owxNeQmQBl4FWy4Nz7FGKQ7rdW8D6udCulC4S35ZOensU1SYEZFcY3O0l1qsJZAGI0R2TS81ux7Bsn9kFda/sd1sRK8IEc2nxkxPbhzlhXm04r6/3+c3LrMACy6dlj/6IgaHYU+IKyfl6H/ctN+Ynr6FbBDgGv+t/Q+GwVxp4um80TV5EYdAR55UHSkcCl5V6/8j2DlrGynYTOBbeF0vcjKEbBBcT0DAfXr/Bq4TWFj+9MvsTI2EEEdon+47u9eZ57QTrcXEQlT1b9ppSW8nLzS5uf4N8oSWnyq6No8tTFJqp/kgv7QRC+8yWHae58Cs8QATA1TCYDODov2ZswyVFxi5o6IipF6M4T1WezwcC4ZKIM= jegadishvelayutham@Jegadishs-MacBook-Air.local"
  
}
*/
module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}