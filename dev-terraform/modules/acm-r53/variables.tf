variable "route53_zone_id" {
  description = "route 53"
  type        = string
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
}


variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}



variable "domain_name" {
  description = "Domain name for Route 53"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS Name"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB Hosted Zone ID"
  type        = string
}
