variable "region" {
  description = "AWS Region"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "enable_ecr_vpc_endpoint" {
  description = "Flag to enable ECR VPC endpoint"
  type        = bool
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}


# ECR Variables
variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

# ECS Variables
variable "cluster_name" {
  description = "Name of ECS cluster"
  type        = string
}

# variable "project_name" {
#   description = "Project name to be used for tagging"
#   type        = string
# }

variable "env_name" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}

# variable "environment" {
#   description = "Environment name (e.g., dev, prod)"
#   type        = string
# }



# variable "env_name" {
#   description = "Environment name (e.g., dev, prod)"
#   type        = string
# }


variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

# variable "route53_zone_id" {
#   description = "Route 53 Hosted Zone ID for the domain"
#   type        = string
# }


variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
}


variable "domain_name" {
  description = "The domain name for the ACM certificate and Route 53"
  type        = string
}

# variable "route53_zone_id" {
#   description = "The Route 53 Hosted Zone ID"
#   type        = string
# }
