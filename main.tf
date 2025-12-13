module "security-group" {
  source = "./modules/security-group"

  name        = "web_sg"
  description = "Allow inbound traffic on ports 22 and 80"

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    }
  ]
}

locals {
  apache_user_data = <<-EOF
    #! /bin/bash
    yes | sudo apt update
    yes | sudo apt install apache2
    echo "<h1>Server Details</h1><p><strong>Hostname:</strong> $(hostname)</p><p><strong>IP Address:</strong> $(hostname -I | cut -d" " -f1)</p>" > /var/www/html/index.html
    sudo systemctl restart apache2
  EOF

  # Define all your EC2 instances here
  ec2_instances = {
    ec2-01 = {
      instance_type = "t2.micro"
      ami           = "ami-02b8269d5e85954ef"
    }
    ec2-02 = {
      instance_type = "t2.micro"
      ami           = "ami-02b8269d5e85954ef"
    }
    ec2-03 = {
      instance_type = "t2.small"
      ami           = "ami-02b8269d5e85954ef"
    }
    ec2-04 = {
      instance_type = "t2.micro"
      ami           = "ami-02b8269d5e85954ef"
    }
    ec2-05 = {
      instance_type = "t2.micro"
      ami           = "ami-02b8269d5e85954ef"
    }
  }
}

# Create multiple EC2 instances using for_each
module "ec2" {
  source   = "./modules/ec2-instance"
  for_each = local.ec2_instances

  ami               = each.value.ami
  instance_type     = each.value.instance_type
  instance_name     = "tf-${each.key}"
  key_name          = "sanjay-aws"
  security_group_id = module.web_security_group.security_group_name
  user_data         = local.apache_user_data
}