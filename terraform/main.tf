provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "jenkins_server_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr_jenkins_server
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

module "ec2_jenkins_server" {
  source         = "./ec2_jenkins_server"
  region         = var.region
  instance_type  = var.instance_type
  ami_id         = var.ami_id
  key_name       = var.key_name
  vpc_id         = aws_vpc.main_vpc.id
  subnet_id      = aws_subnet.jenkins_server_subnet.id

}


module "jenkins_backup" {
  source        = "./jenkins_backup"
  region        = var.region
  instance_id   = module.ec2_jenkins_server.instance_id
  backup_scheduler= var.backup_scheduler
  backup_life_cycle=var.backup_scheduler

}


