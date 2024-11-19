variable "ami_id" {
  description = "ID of the AMI for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet in which to launch the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "SSH key name for accessing the EC2 instance"
  type        = string
}
