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

module "network" {
  source          = "./modules/network"
  vpc_cidr_block  = var.vpc_cidr
  tags            = var.tags
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "rds" {
  source = "./modules/rds"
  subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  environment = "demo"
}