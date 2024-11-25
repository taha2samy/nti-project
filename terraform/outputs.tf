output "vpc_cidr" {
  value = aws_vpc.main_vpc.cidr_block
}

output "subnet_cidr" {
  value = aws_subnet.main_subnet.cidr_block
}

output "subnet_name" {
  value = "subnet-1"
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}
output "instance_public_ip" {
  value = module.aws_instance.ec2.public_dns
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}
