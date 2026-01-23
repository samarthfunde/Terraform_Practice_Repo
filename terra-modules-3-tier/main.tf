provider "aws" {
    region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  web_cidr = var.web_cidr
  app_cidr = var.app_cidr
  db_cidr = var.db_cidr
  web-az = var.web-az
  app-az = var.app-az
  db-az = var.db-az
}

module "security" {
  source = "./modules/security"
  vpc_cidr = var.vpc_cidr
  web_cidr = var.web_cidr
  app_cidr = var.app_cidr
  vpc_id = module.vpc.vpc_id
}

module "web" {
  source = "./modules/web"
  web-sg-id = module.security.web-sg-id
  myami = var.myami
  web-sub-id = module.vpc.web-sub-id
}

module "app" {
  source = "./modules/app"
  app-sg-id = module.security.app-sg-id
  myami = var.myami
  app-sub-id = module.vpc.app-sub-id
}

module "db" {
  source = "./modules/db"
  db-ins-type = var.db-ins-type
  storage = var.storage
  db-sg-id = module.security.db-sg-id
  sub-grp-id = module.vpc.sub-grp-id
}