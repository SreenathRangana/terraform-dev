# AWS Region
region = "us-east-1"

# VPC Variables
vpc_cidr                = "10.0.0.0/16"
public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
enable_ecr_vpc_endpoint = true
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]


# ECR Variables
repository_name = "nginx-repo"

# ECS Variables
cluster_name = "dev-cluster"

