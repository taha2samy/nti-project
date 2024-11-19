output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "jenkins_public_ip" {
  value = module.ec2.public_ip
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
