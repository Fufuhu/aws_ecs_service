
resource "aws_ecs_service" "service" {
  name = local.ecs_service_name

  cluster = var.ecs_service_cluster_arn

  # 起動タイプはFARGATE, スケジューリング戦略はREPLICA固定
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"

  task_definition = var.ecs_service_task_definition_arn

  desired_count = var.ecs_service_task_desired_count
  deployment_maximum_percent = var.ecs_service_task_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_service_task_minimum_percent

  enable_execute_command = var.ecs_service_enable_execute_command

  network_configuration {
    subnets = var.ecs_service_subnets
    security_groups = var.ecs_service_security_groups
    assign_public_ip = false # パブリックIPは割り当てないようハードコード
  }

  dynamic "load_balancer" {
    for_each = local.ecs_service_is_load_balancer_active
    content {
      target_group_arn = var.ecs_service_alb_target_group_arn
      container_name = var.ecs_service_alb_target_group_container_name
      container_port = var.ecs_service_alb_target_group_container_port
    }
  }

  deployment_controller {
    type = var.ecs_service_deployment_controller
  }


  tags = local.ecs_service_tags


  # タスク定義はCDの中で変わるので無視
  # TODO: ロードバランサー設定がBGデプロイで変わるかはチェックする
  lifecycle {
    ignore_changes = [
      # task_definition,
      # load_balancer,
    ]
  }
}