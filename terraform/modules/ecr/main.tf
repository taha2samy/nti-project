resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = var.repository_name
  }
}
