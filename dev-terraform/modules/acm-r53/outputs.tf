output "route53_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}



output "acm_certificate_arn" {
  description = "The ARN of the issued ACM certificate"
  value       = aws_acm_certificate.alb_cert.arn
}

# output "acm_certificate_validation_arn" {
#   description = "The ARN of the validated ACM certificate"
#   value       = aws_acm_certificate_validation.this.certificate_arn
# }


output "route53_record" {
  value = aws_route53_record.alb_alias.name
}