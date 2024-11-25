variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/8"
}

variable "subnet_cidr_jenkins_server" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/9"
}
variable "backup_scheduler" {
  default = "cron(0 0 */5 * ? *)"
  description = "schedule of backup process"
  
}
variable "backup_life_cycle" {
  default = 15
  description = "delete after life N of days"
  
}

variable "elb_log_bucket" {
  default = "the_s3_bucket_of_elb_4321"
  description = "the name of ELB bucket"
}