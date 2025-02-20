# ECR Repository
resource "aws_ecr_repository" "repo" {
  name = "${var.project_name}-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true #This allows Terraform to delete the repo even if it contains images


  tags = {
      Name = "${var.environment}-${var.project_name}-ecr"
    }
}
