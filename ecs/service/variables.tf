locals {
  service_name = "sample"

  ecs_cluster_name = "${local.service_name}-${terraform.workspace}-cluster"
  ecs_task_family = "${local.service_name}-${terraform.workspace}-task"


  hosted_zone_domain = "web.ryoma0923.work."
}