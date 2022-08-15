resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = toset(var.managed_iam_policy_arns)
  role       = aws_iam_role.role.id
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policy_documents
  role   = aws_iam_role.role.id
  name = each.key
  policy = each.value
}