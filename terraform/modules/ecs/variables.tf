variable "taskdef_template" {
  default = "./modules/ecs/app.json.tpl"
}

variable "tags" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "app_name" {}

variable "env" {}

variable "app_port" {}

variable "ecr_repository_url" {}

variable "image_tag" {}

variable "private_subnet_ids" {}

variable "lb_target_group" {}

locals {
  app_image = format("%s:%s", var.ecr_repository_url, var.image_tag)
}
