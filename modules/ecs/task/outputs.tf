output "task_definition_arn" {
  description = "タスク定義のARN"
  value       = aws_ecs_task_definition.task_definition.arn
}

output "task_family_name" {
  description = "タスク定義の名前"
  value       = aws_ecs_task_definition.task_definition.family
}

output "container_definitions" {
  description = "タスク定義に含まれるコンテナ定義"
  value       = jsondecode(aws_ecs_task_definition.task_definition.container_definitions)
}