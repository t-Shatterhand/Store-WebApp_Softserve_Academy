variable "db_port" {
    type = string
    default = "5432"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "db_master_username" {
    type = string
    default = "master"
}

variable "db_storage_type" {
    type = string
    default = "gp2"
}

variable "db_instance_class" {
    type = string
    default = "db.t3.micro"
}

variable "db_name" {
    type = string
    default = "demo"
}

variable "subnet_ids" {
    type = list(string)
}

variable "vpc_id" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}