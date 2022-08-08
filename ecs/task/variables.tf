locals {
  service_name = "sample"


  container_definitions = jsonencode([
    {
      name         = "nginx"
      image        = "nginx:1.21"
      cpu          = 1024
      memory       = 2048
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = module.log_group.log_group_name
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = local.service_name
        }
      }
    }
  ])
}