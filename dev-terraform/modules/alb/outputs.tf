output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}
