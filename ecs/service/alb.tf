module "alb" {
  source = "../../modules/alb"
  service_name = local.service_name
  env = terraform.workspace
  alb_subnet_ids = data.aws_subnets.public_subnets.ids
}