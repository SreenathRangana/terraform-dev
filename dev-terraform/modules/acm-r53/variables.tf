# variable "route53_zone_id" {
#   description = "route 53"
#   type        = string
# }

# variable "project_name" {
#   description = "Project name to be used for tagging"
#   type        = string
# }


# variable "environment" {
#   description = "Environment name (e.g., dev, prod)"
#   type        = string
# }


# variable "domain_name" {
#   description = "Domain name for Route 53 Hosted Zone"
#   type        = string
# }



# variable "domain_name" {}
# variable "env_name" {}
# variable "project_name" {}



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
