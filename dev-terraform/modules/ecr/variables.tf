variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
}

variable "env_name" {
  description = "Environment (dev/staging/prod)"
  type        = string
}