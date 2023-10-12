module "network" {
  source          = "./modules/network"
  vpc_cidr_block  = var.vpc_cidr
  tags            = var.tags
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "lb" {
  source          = "./modules/lb"
  lb_name         = local.lb_name
  tg_name         = local.tg_name
  vpc_id          = module.network.vpc_id
  subnets         = module.network.public_subnet_ids
  certificate_arn = module.https.certificate_arn
  app_port        = var.app_port
}

module "https" {
  source       = "./modules/https"
  domain       = var.domain
  alb_dns_name = module.lb.alb_dns_name
  alb_zone_id  = module.lb.alb_zone_id
}

module "ecr" {
  source = "./modules/ecr"
  tags   = var.tags
}

module "ecs" {
  source             = "./modules/ecs"
  tags               = var.tags
  vpc_id             = module.network.vpc_id
  vpc_cidr           = var.vpc_cidr
  app_name           = var.app_name
  env                = var.env
  app_port           = var.app_port
  ecr_repository_url = module.ecr.ecr_repository_url
  image_tag          = var.image_tag
  private_subnet_ids = module.network.private_subnet_ids
  lb_target_group    = module.lb.target_group_arn
}
