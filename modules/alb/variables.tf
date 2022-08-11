variable "service_name" {
  type        = string
  description = "サービス名"
}

variable "service_suffix" {
  type        = string
  description = <<DESC
サービス名のサフィックス
DESC
  default = ""
}

variable "env" {
  type        = string
  description = "環境識別子(dev, stg, prod)など"
}

# ALB固有設定

variable "alb_additional_tags" {
  type        = map(string)
  description = "ALBに付与する追加リソースタグ"
  default     = {}

  validation {
    condition     = length(setintersection(keys(var.alb_additional_tags), ["ServiceName", "ServiceSuffix","Env"])) == 0
    error_message = "Key names, ServiceName, ServiceSuffix, Env are reserved. Not allowed to use them. "
  }
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "ALBを配置するサブネットIDのリスト"

  validation {
    condition     = length(var.alb_subnet_ids) > 0
    error_message = "Specify at least 1 subnet to place application loadbalancer"
  }
}

variable "alb_security_group_ids" {
  type = list(string)
  description = "ALBに付与するセキュリティグループIDのリスト"
  default = []
}

# ALBのログ格納用S3バケット設定

variable "alb_log_transition_in_days" {
  type = number
  description = "ALBのログをS3に保管した後標準IAに移行するまでの期間"
  default = 90
}

variable "alb_log_expiration_in_days" {
  type = number
  description = "ALBのログをS3に保管した後、削除するまでの期間"
  default = 550
}


locals {

  default_tags = var.service_suffix == "" ? {
    ServiceName = var.service_name
    Env         = var.env
  } : {
    ServiceName   = var.service_name
    ServiceSuffix = var.service_suffix
    Env           = var.env
  }

  alb_name             = var.service_suffix == "" ? "${var.service_name}-${var.env}-alb" : "${var.service_name}-${var.service_suffix}-${var.env}-alb"
  alb_deletion_protect = can(regex("^prod$|^prd$", var.env)) ? true : false # var.envがprodまたはprdだったらALBは削除保護する
  alb_tags = merge(
    var.alb_additional_tags,
    local.default_tags
  )

  # ログ格納バケットの設定
  alb_log_bucket_name  = "${local.alb_name}-log-bucket"
  alb_log_bucket_force_destroy = can(regex("^prod$|^prd$", var.env)) ? false : true # var.envがprodまたはprdだったらログバケットのforce_destroyは無効
  alb_log_bucket_lifecycle_id = "${local.alb_name}-log-lifecycle"

}