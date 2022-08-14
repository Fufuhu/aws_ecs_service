data "aws_ecs_task_definition" "task_definition" {
  task_definition = local.ecs_task_family
}