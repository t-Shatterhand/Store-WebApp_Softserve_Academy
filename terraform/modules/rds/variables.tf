/*
variable "tags" {}

variable "subnet_ids" {}

variable "vpc_id" {}

variable "vpc_cidr_block" {}

variable "db_name" {}

variable "db_username" {}
*/

variable "environment" {
  description = "System environment name"
  type        = string
  default     = "development"
}


variable "rds_allocated_storage" {
  default = "25"
}


variable "rds_instance_class" {
  default = "db.t3.micro"
}


variable "rds_multi_az" {
  default = "false"
}





variable "vpc_subnet_ids" {
  type = list(string)
}


variable "vpc_id" {}


variable "vpc_cidr_blocks" {
  type    = list(string)
  default = []
}


variable "vpc_cidr_blocks_vpn" {
  type    = list(string)
  default = []
}


variable "skip_final_snapshot" {
  type    = string
  default = "false"
}

variable "database_master_password" {

}
