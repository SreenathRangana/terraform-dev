output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

output "vpc_id" {
  value       = aws_vpc.main.id  # This should be the actual VPC resource ID in the module
  description = "The VPC ID"
}
