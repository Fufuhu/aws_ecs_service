
output "task_role_arn" {
  value = module.roles.task_role_arn
}

output "task_exec_role_arn" {
  value = module.roles.task_exec_role_arn
}

output "log_group_arn" {
  value = module.log_group.log_group_arn
}