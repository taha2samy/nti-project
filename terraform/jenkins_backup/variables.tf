variable "region" {
  description = "AWS Region"
}

variable "instance_id" {
  description = "EC2 Instance ID"
}

variable "backup_scheduler" {
  description = "schedule of backup process"
  
}
variable "backup_life_cycle" {
  description = "delete after life N of days"
}  