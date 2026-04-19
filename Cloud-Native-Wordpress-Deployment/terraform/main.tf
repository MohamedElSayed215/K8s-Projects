provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "nodes" {
  source             = "./modules/nodes"
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnets[0]
  private_subnet_ids = module.vpc.private_subnets
  instance_type      = "t3.medium"
}