module "log_group" {
  source       = "../../modules/cloudwatch/logs"
  service_name = local.service_name
  env          = terraform.workspace
}