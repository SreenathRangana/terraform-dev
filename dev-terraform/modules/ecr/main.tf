# # Create an ECR repository
# resource "aws_ecr_repository" "repo" {
#   name = var.repository_name
# }

# ECR Repository
resource "aws_ecr_repository" "repo" {
  name = "${var.project_name}-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true #This allows Terraform to delete the repo even if it contains images

  tags = {
    Name        = "${var.project_name}-ecr"
    Environment = var.environment
  }
}
