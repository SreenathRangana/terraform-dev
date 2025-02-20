resource "aws_security_group" "alb_sg" {
    name   = "${var.environment}-${var.project_name}-alb-sg"
    vpc_id = var.vpc_id

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

# Create an Application Load Balancer
resource "aws_lb" "main" {
  #name               = "main-alb"
  name               = "${var.environment}-${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = var.security_groups
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
  

  enable_cross_zone_load_balancing = true
  enable_http2 = true

  tags = {
    Name        = "${var.project_name}-ecs-tasks-sg"
    Environment = var.environment
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
      Name = "${var.environment}-${var.project_name}-alb"
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

# Create an ALB listener for HTTP traffic on port 80
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn = aws_acm_certificate.alb_cert.arn  # Automatically created
  certificate_arn   = var.acm_certificate_arn
  #certificate_arn  = aws_acm_certificate.alb_cert.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
  #depends_on = [aws_acm_certificate_validation.alb_cert_validation]  #  Ensure ACM is validated
}
