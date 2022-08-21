output "ecs_service_arn" {
  description = "ECSサービスのARN"
  value       = aws_ecs_service.service.id
}