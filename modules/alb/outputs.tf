
output "alb_name" {
  description = "ALBの名前"
  value = aws_lb.alb.name
}

output "alb_arn" {
  description = "ALBのARN"
  value = aws_lb.alb.arn
}

output "alb_tags" {
  description = "ALBに付与されているタグ"
  value = aws_lb.alb.tags
}

output "alb_fqdn" {
  description = "ALBに付与されたFQDNです"
  value = aws_lb.alb.dns_name
}