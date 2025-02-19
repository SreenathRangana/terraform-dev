# Create an Application Load Balancer
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets
  

  enable_cross_zone_load_balancing = true
  enable_http2 = true

  tags = {
    Name = "main-alb"
  }
}

# Create a target group for the ALB
resource "aws_lb_target_group" "target_group" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "main-target-group"
  }
}

# Create an ALB listener for HTTP traffic on port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}

output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}