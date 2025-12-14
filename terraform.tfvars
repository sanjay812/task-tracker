/*ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "Allow SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "Allow HTTP"
    }
  ]

user_data = <<-EOF
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
  }*/

vpc_cidr = "11.0.0.0/22"
vpc_name = "test-proj-vpc-01"
#cidr_public_subnet = "11.0.0.0/26"
#vaeu_availability_zone" {}
#cidr_private_subnet = "11.0.1.0/26"
