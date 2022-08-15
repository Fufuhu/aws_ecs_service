output "repository_url" {
  value = module.ecr.repository_url
}

output "repository_arn" {
  value = module.ecr.repository_arn
}


output "iam_role_arn" {
  value = module.iam_role.iam_role_arn
}