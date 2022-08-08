resource "aws_iam_role" "task_exec_role" {
  name               = local.task_exec_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
  tags               = local.task_exec_role_tags
}

data "aws_iam_policy_document" "task_exec_role_policy_document" {
  version = "2012-10-17"
  statement {
    sid = "ECRPullImage"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "CloudWatchPutLog"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "task_exec_role_policy" {
  role   = aws_iam_role.task_exec_role.id
  policy = data.aws_iam_policy_document.task_exec_role_policy_document.json
}