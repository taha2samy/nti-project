variable "aws_region" {
  default = "us-east-1"
}

variable "eks_cluster_name" {
  default = "nti-eks-cluster"
}

variable "jenkins_instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "key_name" {
  description = "SSH key pair for EC2 instances"
}
