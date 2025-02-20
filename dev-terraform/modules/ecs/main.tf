# Define the ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  tags = {
    Name        = "${var.env_name}-${var.project_name}-alb-task-definition"
  }
}

# # IAM Role for ECS Task
# resource "aws_iam_role" "ecs_task_role" {
#   name = "ecs_task_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#     }]
#   })
# }

# # IAM Role for ECS Execution
# resource "aws_iam_role" "ecs_execution_role" {
#   name = "ecs_execution_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#     }]
#   })
# }

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.env_name}-${var.project_name}-ecs-execution-role"
  }
}

# Attach ECS Execution Role Policy (Required for Fargate + ECR Access)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

  resource "aws_security_group" "ecs_sg" {
    name   = "${var.env_name}-${var.project_name}-ecs-sg"
    vpc_id = var.vpc_id 

    ingress {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [var.alb_security_group]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


# ECS Task Definition for Nginx
resource "aws_ecs_task_definition" "task" {
 # family                   = "nginx-task"
  family                   = "${var.project_name}-task"
  cpu                      = "256"    # Minimum required for Fargate
  memory                   = "512"    # Minimum required for Fargate
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"] # Ensure Fargate compatibility
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
   # name      = "nginx"
    name            = "${var.project_name}-service"
   # image     = "nginx:latest"
    image = "${var.ecr_repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
   tags = {
    Name        = "${var.env_name}-${var.project_name}-task-definition"
  }
}

# ECS Service Configuration
resource "aws_ecs_service" "service" {
  #name            = "nginx-service"
  #name            = "${var.project_name}-service"
  name            = "${var.env_name}-${var.project_name}-ecs"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  deployment_circuit_breaker {
      enable   = true
      rollback = true
    }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true  # Assign public IP if needed
    security_groups  = var.security_groups
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    #container_name   = "nginx"
    container_name   = "${var.project_name}-service"
    container_port   = 80
  }
  # Ensure ALB is provisioned before creating ECS service
    depends_on = [
    # var.alb_arn,  # Ensure ALB is provisioned before ECS service
    # var.alb_target_group_arn  # Ensure Target Group is linked
    #aws_lb_listener.http,  # Wait for ALB Listener
    #aws_lb_target_group.target_group,  # Ensure Target Group is linked
    var.alb_listener_arn
  ]

    tags = {
    Name        = "${var.env_name}-${var.project_name}-ecs-service"
  }

}

# Target Tracking Scaling for ECS Service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "${var.project_name}-ecs-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 50.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
