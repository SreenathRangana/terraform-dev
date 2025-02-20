variable "vpc_id" {
  description = "The VPC ID to associate with ECS resources"
  type        = string
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs for ECS"
}

variable "subnets" {
  description = "List of subnets for ECS service"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "alb_arn" {}
variable "alb_target_group_arn" {}
variable "alb_listener_arn" {}


variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to associate with ECS resources"
  type        = list(string)
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
  default     = "cloudzenia"
}

variable "task_role_arn" {
  description = "IAM role for ECS task"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role for ECS task execution"
  type        = string
}


variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}


variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
}

variable "alb_security_group" {
  description = "Security group ID of the ALB"
  type        = string
}


variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the ALB"
  type        = string
}