variable "service_name" {
  type        = string
  description = "サービス名"
}

variable "service_suffix" {
  type        = string
  description = <<DESC
サービス名のサフィックス(用途、サブサービス名、コンポーネント名など)
DESC
  default     = ""
}

variable "env" {
  type        = string
  description = "環境識別子(dev, stg, prod)など"
}

variable "security_group_additional_tags" {
  type        = map(string)
  description = "セキュリティグループに追加で付与するリソースタグです"
  default     = {}

  validation {
    condition = length(setintersection(keys(var.security_group_additional_tags), [
      "ServiceName", "ServiceSuffix", "Env"
    ])) == 0
    error_message = "Key names, ServiceName, ServiceSuffix, Env are reserved. Not allowed to use them. "
  }
}

variable "security_group_ingress_ports" {
  type = list(number)
  description = "内向け通信(ingress)として許可するポート番号のリストです"
  default = [
    80
  ]
}

variable "security_group_ingress_cidrs" {
  type        = list(string)
  description = "内向け通信(ingress)として許可するCIDRのリストです"
  default     = [
    "0.0.0.0/0"
  ]
}

variable "security_group_ingress_allow_self" {
  type        = bool
  description = "内向け通信(ingress)として自身のSGを許可するか否かです"
  default     = false
}

variable "security_group_ingress_sgs" {
  type        = list(string)
  description = "内向け通信(ingress)との送信元セキュリティグループとして許可するセキュリティグループIDのリストです"
  default     = []
}

variable "security_group_egress_cidrs" {
  type        = list(string)
  description = "外向け通信(egress)として許可するCIDRのリストです"
  default     = [
    "0.0.0.0/0"
  ]
}

variable "security_group_egress_allow_self" {
  type        = bool
  description = "外向け通信(egress)の宛先セキュリティグループとして自身のSGを許可するか否かです"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "セキュリティグループが所属するVPC ID"
}

locals {
  default_tags = var.service_suffix == "" ? {
    ServiceName = var.service_name
    Env         = var.env
    VpcId       = var.vpc_id
  } : {
    ServiceName   = var.service_name
    ServiceSuffix = var.service_suffix
    Env           = var.env
    VpcId         = var.vpc_id
  }
  security_group_name = var.service_suffix == "" ? "${var.service_name}-${var.env}-sg" : "${var.service_name}-${var.service_suffix}-${var.env}-sg"
  security_group_tags = merge(
    var.security_group_additional_tags,
    local.default_tags
  )
}

locals {
  # https://www.terraform.io/language/functions/setproduct
  # https://qiita.com/sekai/items/93aa4978f8cfc87e0913
  ingress_cidr_ports = [ for v in var.security_group_ingress_ports : tostring(v)]
  ingress_sg_rules = { for v in setproduct(var.security_group_ingress_ports, var.security_group_ingress_sgs) : join(",", v) => v }
  ingress_self_rules = var.security_group_ingress_allow_self ? [ for v in var.security_group_ingress_ports : tostring(v)] : []
}