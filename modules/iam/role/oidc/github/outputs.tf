output "iam_role_arn" {
  description = "作成したIAMロールのARN"
  value = aws_iam_role.role.arn
}