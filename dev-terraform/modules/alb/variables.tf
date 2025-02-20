variable "security_groups" {
  description = "List of security groups to associate with the ALB"
  type        = list(string)
}


variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID to associate with the ALB"
  type        = string
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
}

variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the ALB ACM certificate"
  type        = string
}


variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID for DNS validation"
  type        = string
}
