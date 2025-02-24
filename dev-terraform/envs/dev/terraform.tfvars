# AWS Region
region = "us-east-1"

# VPC Variables
vpc_cidr                = "10.0.0.0/16"
public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
enable_ecr_vpc_endpoint = true
azs                     = ["us-east-1a", "us-east-1b", "us-east-1c"]


# Project name used for tagging and resource naming  
project_name = "nurseplexus"

# Define the environment (dev, prod, etc.)
env_name = "dev"

# ECR Variables
repository_name = "nurseplexus-repo"

# ECS Variables
cluster_name = "nurseplexus-dev"

#DNS NAME 
domain_name = "devapi-new.agilenurses.com"

# ARN of the ACM certificate for HTTPS (used in ALB)
acm_certificate_arn = "arn:aws:acm:us-east-1:886436924955:certificate/1f091abd-07c3-4e6a-ae24-487297f0d2de"

# Maximum ECS task count (auto-scaling upper limit)  
ecs_max_capacity = 3 # Set the actual value

# Minimum ECS task count (auto-scaling lower limit)
ecs_min_capacity = 1 # Also ensure min capacity is set

# ARN of the ACM certificate for HTTPS (used in ALB)
#acm_certificate_arn = "arn:aws:acm:us-east-1:434103605849:certificate/bc6c6a0d-cff2-4557-872f-37d5422e1e6e"


# Hosted zone ID for Route 53 DNS records 
#route53_zone_id = "Z009583419TCMFOR2917R"


