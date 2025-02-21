# AWS Provider Configuration
provider "aws" {
  region = var.region
}
# ACM & ACM Module
module "acm-r53" {
  source          = "../../modules/acm-r53"
  domain_name     = var.domain_name
  env_name        = var.env_name
  project_name    = var.project_name
  route53_zone_id = module.acm-r53.route53_zone_id
}


# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  region               = var.region
  azs                  = var.azs
  security_groups = [module.alb.alb_security_group_id]
  env_name        = var.env_name
}


# ECR Module
module "ecr" {
  source          = "../../modules/ecr"
  repository_name = var.repository_name
  project_name    = var.project_name
  env_name = var.env_name
}

# ALB Module
module "alb" {
  source         = "../../modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  # domain_name         = "saissk.fun"  
  domain_name = var.domain_name # Change to your actual domain
  security_groups = [module.alb.alb_security_group_id] # Pass security group to ALB module
  env_name            = var.env_name
  project_name        = var.project_name        # Add missing project_name
  acm_certificate_arn = module.acm-r53.acm_certificate_arn # Correct module reference
  route53_zone_id = module.acm-r53.route53_zone_id
}

# ECS Module
module "ecs" {
  source       = "../../modules/ecs"
  vpc_id       = module.vpc.vpc_id
  cluster_name = var.cluster_name
  # alb_target_group_arn = module.alb.target_group_arn 
  alb_target_group_arn = module.alb.alb_target_group_arn
  alb_arn              = module.alb.alb_arn
  alb_listener_arn     = module.alb.alb_listener_arn
  acm_certificate_arn  = module.acm-r53.acm_certificate_arn
  public_subnets       = module.vpc.public_subnet_ids
  subnets              = module.vpc.public_subnet_ids
  security_groups = [module.alb.alb_security_group_id]
  # alb_security_group = module.alb.alb_security_group.alb_sg.id
  alb_security_group = module.alb.alb_security_group_id
  #alb_security_group = [aws_security_group.alb_sg.id]
  #task_role_arn      = aws_iam_role.ecs_task_role.arn
  #execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn       = module.ecs.ecs_task_role_arn
  execution_role_arn  = module.ecs.ecs_execution_role_arn
  ecr_repository_url = module.ecr.repository_url
  env_name           = var.env_name         # Add missing env_name
  ecs_min_capacity   = var.ecs_min_capacity #  Add missing ecs_min_capacity
  ecs_max_capacity   = var.ecs_max_capacity
}