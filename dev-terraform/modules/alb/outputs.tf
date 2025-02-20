output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}


output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}


# output "alb_dns_name" {
#   value = aws_lb.alb.dns_name
# }

# output "alb_zone_id" {
#   value = aws_lb.alb.zone_id
# }