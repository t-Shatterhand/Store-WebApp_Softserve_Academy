variable "tags" {
  default = {
    Env = "demo-3"
  }
}

variable "env" {
  default = "demo-3"
}

# network

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# lb

locals {
  lb_name = "${var.env}-app-lb"
  tg_name = "${var.env}-app-tg"
}

variable "app_port" {
  default = 9999
}

# https

variable "domain" {
  default = "softserve-demo.pp.ua"
}

# ecs

variable "app_name" {
  default = "apple-store"
}

variable "image_tag" {
  default = "latest"
}
