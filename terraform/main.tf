provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  vpc_cidr            = "10.0.0.0/16"
  staging_public_cidr = "10.0.1.0/24"
  prod_public_cidr    = "10.0.2.0/24"
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  app_port     = var.app_port
}

module "alb_staging" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = "staging"
  subnet_ids        = [module.vpc.staging_public_id, module.vpc.prod_public_id] 
  security_group_id = module.security.alb_sg_id
  app_port          = var.app_port
  vpc_id            = module.vpc.vpc_id

}

module "alb_production" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = "production"
  subnet_ids        = [module.vpc.staging_public_id, module.vpc.prod_public_id]
  security_group_id = module.security.alb_sg_id
  app_port          = var.app_port
  vpc_id            = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "asg_staging" {
  source = "./modules/asg"

  project_name          = var.project_name
  environment           = "staging"
  instance_type         = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
  security_group_id     = module.security.ec2_sg_id
  aws_region            = var.aws_region
  ecr_url               = module.ecr.repository_url
  app_port              = var.app_port
  number_of_instances   = var.number_of_instances
  target_group_arn      = module.alb_staging.target_group_arn
  subnet_id   = [module.vpc.staging_public_id, module.vpc.prod_public_id]
}

module "asg_production" {
  source = "./modules/asg"

  project_name          = var.project_name
  environment           = "production"
  instance_type         = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
  security_group_id     = module.security.ec2_sg_id
  aws_region            = var.aws_region
  ecr_url               = module.ecr.repository_url
  app_port              = var.app_port
  number_of_instances   = var.number_of_instances
  target_group_arn      = module.alb_production.target_group_arn
  subnet_id   = [module.vpc.staging_public_id, module.vpc.prod_public_id]
}

module "github_actions" {
    source = "./modules/iam/github-oidc" 

    project_name = var.project_name 
    your_github_username = var.github_username
    your_repo = var.github_repo
}