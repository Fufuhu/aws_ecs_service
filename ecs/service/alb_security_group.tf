
module "alb_security_group" {
  source = "../../modules/vpc/security_group"
  service_name = local.service_name
  env    = terraform.workspace
  vpc_id = data.aws_vpc.vpc.id
  security_group_ingress_cidrs = [
    "0.0.0.0/0" # 環境ごとに変えられるようにしておくとより良い
  ]
  security_group_ingress_ports = [
    80,
    443
  ]
}
