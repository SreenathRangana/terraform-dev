# AWS Provider Configuration
provider "aws" {
  region = var.region
}



# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  project_name    = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  region               = var.region
  azs                  = var.azs
 # security_groups      = [aws_security_group.alb_sg.id] # Define this
  security_groups = [module.alb.alb_security_group_id]
  env_name             = var.env_name
}

# # Security Group for ALB (Created after VPC to avoid circular dependency)
# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Allow inbound HTTP and HTTPS traffic to the ALB"
#   vpc_id      = module.vpc.vpc_id #  Now it's created after VPC

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#    ingress {
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# ECR Module
module "ecr" {
  source          = "../../modules/ecr"
  repository_name = var.repository_name
  project_name    = var.project_name
  #environment     = var.environment
  env_name             = var.env_name
}

# ALB Module
module "alb" {
  source              = "../../modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnet_ids
  domain_name         = "saissk.fun"                   # Change to your actual domain
 # security_groups     = [aws_security_group.alb_sg.id] # Pass security group to ALB module
  security_groups = [module.alb.alb_security_group_id]
  #environment         = var.environment
  env_name             = var.env_name
  project_name        = var.project_name           # Add missing project_name
  acm_certificate_arn = var.acm_certificate_arn  # Correct module reference
 # acm_certificate_validation = module.acm.acm_certificate_validation_arn
  route53_zone_id     = var.route53_zone_id
}



# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# IAM Role for ECS Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
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
  acm_certificate_arn  = var.acm_certificate_arn
  public_subnets       = module.vpc.public_subnet_ids
  subnets              = module.vpc.public_subnet_ids
  #private_subnets      = module.vpc.private_subnet_ids
 # security_groups = [aws_security_group.alb_sg.id] # Now explicitly passed
  security_groups = [module.alb.alb_security_group_id]
  #security_groups     = [module.alb.alb_security_group_id]
  #security_groups      = [aws_security_group.ecs_sg.id]  #  Pass ECS SG explicitly
 # alb_security_group = module.alb.alb_security_group.alb_sg.id
  alb_security_group = module.alb.alb_security_group_id
  #alb_security_group = [aws_security_group.alb_sg.id]
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  ecr_repository_url = module.ecr.repository_url
  env_name           = var.env_name      # Add missing env_name
  ecs_min_capacity   = var.ecs_min_capacity #  Add missing ecs_min_capacity
  ecs_max_capacity   = var.ecs_max_capacity

}
