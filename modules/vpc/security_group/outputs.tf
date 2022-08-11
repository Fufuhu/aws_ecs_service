output "security_group_name" {
  description = "セキュリティグループの名前"
  value       = aws_security_group.security_group.name
}

output "security_group_tags" {
  description = "セキュリティグループのタグ"
  value       = aws_security_group.security_group.tags
}

output "security_group_id" {
  description = "セキュリティグループのID"
  value       = aws_security_group.security_group.id
}