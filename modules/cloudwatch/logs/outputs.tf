output "log_group_name" {
  description = "ロググループの名前です"
  value       = aws_cloudwatch_log_group.log_group.name
}

output "log_group_arn" {
  description = "ロググループのARNです"
  value       = aws_cloudwatch_log_group.log_group.arn
}

output "log_group_tags" {
  description = "ロググループのタグです"
  value       = aws_cloudwatch_log_group.log_group.tags
}