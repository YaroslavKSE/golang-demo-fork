provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "ec2" {
  source                = "./modules/ec2"
  vpc_id               = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_ids[0]
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_name             = var.key_name
  ec2_profile_name     = data.aws_iam_instance_profile.ec2_instance_profile.name
  instance_count       = 2
  alb_security_group_id = module.alb.security_group_id
  target_group_arn     = module.alb.target_group_arn
  user_data_vars = {
    db_endpoint = module.rds.db_instance_endpoint
    db_port     = "5432"
    db_username = var.db_username
    db_password = var.db_password
    db_name     = var.db_name
  }
  depends_on = [module.rds, module.alb]
}

module "rds" {
  source = "./modules/rds"

  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]

  depends_on = [module.vpc]
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}