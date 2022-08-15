output "repository_arn" {
  value = aws_ecr_repository.repository.arn
}

output "repository_url" {
  value = aws_ecr_repository.repository.repository_url
}

output "image_push_policy_document" {
  description = "イメージプッシュに必要となるポリシーのドキュメント"
  value = data.aws_iam_policy_document.image_push_policy_document.json
}