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
