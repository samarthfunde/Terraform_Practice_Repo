# Provider
provider "aws" {
  region = var.my-region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr
  web_cidr = var.web_cidr
  app_cidr = var.app_cidr
  db_cidr = var.app_cidr
  web-az = var.web-az
  app-az = var.app-az
  db-az = var.db-az

}

module "security" {
  source = "./modules/security"
  vpc-id = module.vpc.vpc_id
  vpc_cidr = var.web_cidr
  web_cidr = var.web_cidr
  app_cidr = var.app_cidr
  db_cidr = var.db_cidr
}

module "web" {
  # left - inside module/web variables. right - outside modules variables
  source = "./modules/web"
  web-sub-id = module.vpc.web-sub-id
  web-sg-id = module.security.web-sg-id
  myami = var.myami
  ins-type = var.ins-type
  mykey = var.mykey
}

module "app" {
  source = "./modules/app"
  ins-type = var.ins-type
  myami = var.myami
  mykey = var.mykey
  app-sg-id = module.security.app-sg-id
  app-sub-id = module.vpc.app-sub-id
}

module "db" {
  source = "./modules/db"
  db-sg-id = module.security.db-sg-id
  db-ins-type = var.db-ins-type
  username = var.user
  password = var.password
  storage = var.storage
  dbname = var.dbname
  sub-grp-id = module.vpc.subnet-group-id
}