
module "alb_security_group" {
  source = "../../modules/vpc/security_group"
  service_name = local.service_name
  env    = terraform.workspace
  vpc_id = data.aws_vpc.vpc.id
  #　内向き通信(ingress)設定
  security_group_ingress_cidrs = [
    "0.0.0.0/0"
  ]
  # security_group_ingress_sgs = []
  # security_group_ingress_allow_self = false
  security_group_ingress_ports = [
    80,
    443
  ]

  # 外向け通信(egress)設定
  # security_group_egress_cidrs = ["0.0.0.0/0"]
  # security_group_egress_allow_self = false
}
