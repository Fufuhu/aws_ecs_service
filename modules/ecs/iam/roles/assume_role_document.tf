data "aws_iam_policy_document" "assume_role_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}