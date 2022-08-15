resource "aws_ecr_repository" "repository" {
  name = "${var.service_name}-${var.env}-${var.role}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.image_scanning_scan_on_push_enabled
  }

  tags = merge(var.repository_additional_tags, {
    ServiceName = var.service_name
    Env = var.env
    Role = var.role
  })
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.repository.name
  policy     = var.repository_lifecycle_policy == "" ? file("${path.module}/lifecycle_policy/default_policy.json"): var.repository_lifecycle_policy
}