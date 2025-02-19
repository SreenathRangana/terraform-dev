variable "repository_name" {
  description = "ECR repository name"
  type        = string
}



variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
  default     = "cloudzenia"
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}