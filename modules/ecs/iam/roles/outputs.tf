output "task_role_arn" {
  description = "タスクロールのARNです"
  value = aws_iam_role.task_role.arn
}

output "task_role_name" {
  description = "タスクロールの名前です"
  value = aws_iam_role.task_role.name
}

output "task_exec_role_arn" {
  description = "タスク実行ロールのARNです"
  value = aws_iam_role.task_exec_role.arn
}

output "task_exec_role_name" {
  description = "タスク実行ロールの名前です"
  value = aws_iam_role.task_exec_role.name
}