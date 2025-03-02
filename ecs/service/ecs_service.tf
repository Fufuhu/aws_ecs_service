
module "ecs_service" {
  source = "../../modules/ecs/service"
  service_name = local.service_name
  # service_suffix = ""
  env = terraform.workspace

  # サービス設定
  ecs_service_cluster_arn = data.aws_ecs_cluster.cluster.arn
  # ecs_service_task_desired_count = 3
  # ecs_service_task_maximum_percent = 200
  # ecs_service_task_minimum_percent = 100

  # サービスネットワーク設定
  ecs_service_subnets = data.aws_subnets.private_subnets.ids
  ecs_service_security_groups = [
    module.ecs_security_group.security_group_id
  ]
  ecs_service_task_definition_arn = data.aws_ecs_task_definition.task_definition.arn_without_revision

  # ロードバランサ設定
  ecs_service_alb_target_group_arn = module.alb.alb_target_group_arn
  ecs_service_alb_target_group_container_name = "nginx"
  # ecs_service_alb_target_group_container_port = 80

  # ECS Exec設定
  # ecs_service_enable_execute_command = false

  # デプロイ設定
  # ecs_service_deployment_controller = "ECS"

  # 追加タグ設定
  ecs_service_additional_tags = {}
}