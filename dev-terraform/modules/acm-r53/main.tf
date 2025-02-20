# Request an ACM Certificate
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.project_name}-alb-cert"
    Environment = var.environment
  }
}

# Fetch Route 53 Hosted Zone
data "aws_route53_zone" "selected" {
  name = var.domain_name
}


data "aws_route53_zone" "main" {
  name         = var.domain_name  # Example: "mydomain.com"
  private_zone = false
}

resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"  # Example: "app.mydomain.com"
  type    = "A"

  alias {
    name                   = var.alb_dns_name  # ALB DNS
    zone_id                = var.alb_zone_id   # ALB Hosted Zone ID
    evaluate_target_health = true
  }
}


# Create Route 53 Record for ACM DNS Validation
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}
# Wait for ACM Certificate to be Issued
resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}
