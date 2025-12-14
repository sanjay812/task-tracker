module "security-group" {
  source = "./modules/security-group"
  name        = "web_sg"
  description = "Allow inbound traffic on ports 22 and 80"
  ingress_rules = var.ingress_rules
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
  }
}

# Create multiple EC2 instances using for_each
module "ec2" {
  source   = "./modules/ec2"
  for_each = local.ec2_instances

  ami               = each.value.ami
  instance_type     = each.value.instance_type
  instance_name     = "tf-${each.key}"
  key_name          = "demo_key"
  security_group_id = module.security-group.security_group_id
  user_data         = local.apache_user_data
}

resource "aws_key_pair" "ssh_public_key" {
  key_name = "demo_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpFHzGZHOROcfebq0N5FbbTHhT/RSCmWNTm8Wmk5CchXZYRxiSEuwKDu0ovtoKPugFp14BSgVT0kFP0FQy20bNJKQkmFmo7lEjHqK18gJH5+RF8TOqC/aiTIyv8x8YfmcnocgQjHJq4lr4gAdA9owxNeQmQBl4FWy4Nz7FGKQ7rdW8D6udCulC4S35ZOensU1SYEZFcY3O0l1qsJZAGI0R2TS81ux7Bsn9kFda/sd1sRK8IEc2nxkxPbhzlhXm04r6/3+c3LrMACy6dlj/6IgaHYU+IKyfl6H/ctN+Ynr6FbBDgGv+t/Q+GwVxp4um80TV5EYdAR55UHSkcCl5V6/8j2DlrGynYTOBbeF0vcjKEbBBcT0DAfXr/Bq4TWFj+9MvsTI2EEEdon+47u9eZ57QTrcXEQlT1b9ppSW8nLzS5uf4N8oSWnyq6No8tTFJqp/kgv7QRC+8yWHae58Cs8QATA1TCYDODov2ZswyVFxi5o6IipF6M4T1WezwcC4ZKIM= jegadishvelayutham@Jegadishs-MacBook-Air.local"
  
}