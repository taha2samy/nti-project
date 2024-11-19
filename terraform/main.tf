provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "nti-vpc"
  cidr    = var.vpc_cidr
  azs     = ["us-east-1a", "us-east-1b"]
  public_subnets = var.subnets_cidr
}

module "eks" {
  source      = "./modules/eks"
  cluster_name = var.eks_cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnets
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = var.jenkins_instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnets[1]
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = "nti-ecr-repo"
}
