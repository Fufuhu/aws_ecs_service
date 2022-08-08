output "task_definition_arn" {
  description = "タスク定義のARN"
  value       = aws_ecs_task_definition.task_definition.arn
}