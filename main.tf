resource "aws_instance" "ec2_example" {
  ami           = "ami-0767046d1677be5a0"
  instance_type = "t2.micro"
  tags = {
    Name = "tf-ec2-01"
  }
  security_groups = [aws_security_group.web_sg.name]
  key_name        = "sanjay-aws"
  user_data = <<-EOF
              #! /bin/bash
              yes | sudo apt update
              yes | sudo apt install apache2
              echo "<h1>Server Details</h1><p><strong>Hostname:</strong> $(hostname)</p><p><strong>IP Address:</strong> $(hostname -I | cut -d" " -f1)</p>" > /var/www/html/index.html
              sudo systemctl restart apache2
              EOF
}

/*data "template_file" "install_apache2" {
  template = file("install_apache.sh")
}*/

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic on ports 22 and 80"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from anywhere, consider limiting this
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }
}
