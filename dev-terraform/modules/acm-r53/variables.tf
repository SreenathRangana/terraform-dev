variable "domain_name" {
  description = "The domain name for the ACM certificate and Route 53"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 Hosted Zone ID"
  type        = string
}

variable "env_name" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}
