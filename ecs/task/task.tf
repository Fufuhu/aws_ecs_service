module "task" {
  source               = "../../modules/ecs/task"
  service_name         = local.service_name
  env                  = terraform.workspace
  task_role_arn        = module.roles.task_role_arn
  task_exec_role_arn   = module.roles.task_exec_role_arn
  // CloudWatchLogsに対応したcontainer_definitionを作成して読み込ませる
  container_definition = local.container_definitions
}