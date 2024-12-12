provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "rds" {
  source = "./modules/rds"

  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
}

module "ec2" {
  source                    = "./modules/ec2"
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
  golang_app_instance_count = var.golang_app_instance_count
  ami_id                    = var.ami_id
  golang_app_instance_type  = var.golang_app_instance_type
  key_name                  = var.key_name

  user_data_vars = {
    db_endpoint = module.rds.db_instance_endpoint
    db_port     = "5432"
    db_username = var.db_username
    db_password = var.db_password
    db_name     = var.db_name
    domain_name = var.domain_name
  }
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = var.certificate_arn
  instance_ids      = module.ec2.golang_app-instance_ids
}