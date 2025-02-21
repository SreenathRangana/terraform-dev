variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for VPC endpoints"
}

variable "env_name" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
}