locals {
  service_name = "sample"

  ecs_cluster_name = "${local.service_name}-${terraform.workspace}-cluster"
  ecs_task_family = "${local.service_name}-${terraform.workspace}-task"


  dns_hosted_zone_domain = "web.ryoma0923.work."
  dns_a_record = "terraform-sample.web.ryoma0923.work."
  certificate_domain = "terraform-sample.web.ryoma0923.work"
}