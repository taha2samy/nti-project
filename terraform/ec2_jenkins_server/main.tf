resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "${path.module}/ec2_key.pem"
}

resource "local_file" "public_key" {
  content  = tls_private_key.key_pair.public_key_openssh
  filename = "${path.module}/ec2_key.pub"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH, HTTP, and HTTPS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOT
    #!/bin/bash
    # Create a new user
    useradd jenkins_server
    # Add the user to the sudo group
    usermod -aG sudo jenkins_server
    # Create .ssh directory for the new user
    mkdir -p /home/jenkins_server/.ssh
    # Set permissions
    chmod 700 /home/jenkins_server/.ssh
    # Add the generated public key to the new user's authorized_keys
    echo "${tls_private_key.key_pair.public_key_openssh}" > /home/jenkins_server/.ssh/authorized_keys
    chmod 600 /home/jenkins_server/.ssh/authorized_keys
    # Ensure the correct ownership of the .ssh directory
    chown -R jenkins_server:jenkins_server /home/jenkins_server/.ssh
  EOT


  tags = {
    Name = "Terraform-EC2"
  }
}
