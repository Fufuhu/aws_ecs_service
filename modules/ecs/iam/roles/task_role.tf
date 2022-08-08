resource "aws_iam_role" "task_role" {
  name               = local.task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
  tags               = local.task_role_tags
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  for_each   = toset(var.task_role_maneged_policy_arns)
  role       = aws_iam_role.task_role.arn
  policy_arn = each.key
}