variable "service_name" {
  type        = string
  description = "サービス名"
}

variable "service_suffix" {
  type        = string
  description = <<DESC
サービス名のサフィックス
DESC
  default     = ""
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
    condition     = length(setintersection(keys(var.alb_additional_tags), ["ServiceName", "ServiceSuffix", "Env"])) == 0
    error_message = "Key names, ServiceName, ServiceSuffix, Env are reserved. Not allowed to use them. "
  }
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "ALBを配置するサブネットIDのリスト"

  validation {
    condition     = length(var.alb_subnet_ids) > 0
    error_message = "Specify at least 1 subnet to place application load balancer."
  }
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "ALBに付与するセキュリティグループIDのリスト"
  default     = []
}

# ALBのログ格納用S3バケット設定

variable "alb_log_transition_in_days" {
  type        = number
  description = "ALBのログをS3に保管した後標準IAに移行するまでの期間"
  default     = 90
}

variable "alb_log_expiration_in_days" {
  type        = number
  description = "ALBのログをS3に保管した後、削除するまでの期間"
  default     = 550
}

# ALBのリスナー設定

# HTTPリスナー設定
variable "alb_enable_http_listener" {
  type        = bool
  description = "ALBのHTTPリスナーを有効にするか否かを指定します"
  default     = true
}

variable "alb_enable_redirect_http_to_https" {
  type        = bool
  description = <<DESC
ALBのHTTPリスナーからHTTPSへとリダイレクトするか否かを指定します。
alb_listener_enable_httpが有効(true)な場合のみ有効です。
DESC
  default     = true
}

# HTTPSリスナー設定

variable "alb_enable_https_listener" {
  type        = bool
  description = "ALBのHTTPSリスナーを有効にするか否かを指定します"
  default     = true
}

variable "alb_https_listener_ssl_policy" {
  type        = string
  description = "ALBのHTTPリスナーのSSLポリシーを指定します"
  default     = "ELBSecurityPolicy-2016-08"

  validation {
    # 定期的にSSLポリシーが改廃された場合は対応する必要がある。
    condition = contains([
        "ELBSecurityPolicy-2016-08",
        "ELBSecurityPolicy-TLS-1-0-2015-04",
        "ELBSecurityPolicy-TLS-1-1-2017-01",
        "ELBSecurityPolicy-TLS-1-2-2017-01",
        "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
        "ELBSecurityPolicy-FS-2018-06",
        "ELBSecurityPolicy-FS-1-1-2019-08",
        "ELBSecurityPolicy-FS-1-2-2019-08",
        "ELBSecurityPolicy-FS-1-2-Res-2019-08",
        "ELBSecurityPolicy-2015-05",
        "ELBSecurityPolicy-FS-1-2-Res-2020-10"
      ],
      var.alb_https_listener_ssl_policy
    )
    error_message = "Policy must be the value defined in https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies."
  }
}

variable "alb_https_certificate_arn" {
  # terraform ver 1.13.0であればobjectとoptionの組み合わせを活用するほうが良い
  type        = string
  description = "ALBのHTTPリスナーに付与するSSL/TLS証明書のARN"
  default     = ""
}

# ターゲットグループ設定

variable "alb_vpc_id" {
  type        = string
  description = "ALBを配置するVPC ID、ターゲットグループ設定に必要"
}

variable "alb_target_group_port" {
  type        = number
  description = "ターゲットグループの待受ポート番号"
  default     = 80
}

variable "alb_target_group_health_check_port" {
  type        = number
  description = <<DESC
ターゲットグループのヘルスチェック用ポート番号指定
指定しない場合は、alb_target_group_portと同じ番号を指定
DESC
  default     = 0
}

variable "alb_target_group_health_check_path" {
  type        = string
  description = "ターゲットグループのヘルスチェックに使うパス"
  default     = "/"
}

variable "alb_target_group_health_check_interval" {
  type        = number
  description = "ターゲットグループのヘルスチェック間隔(秒)"
  default     = 30
}

variable "alb_target_group_health_check_timeout" {
  type        = number
  description = "ターゲットグループのヘルスチェックのタイムアウト(秒)"
  default     = 10
}


variable "alb_target_group_health_check_healthy_threshold" {
  type        = number
  description = "ヘルスチェック先をHealthyと判断するヘルスチェック回数"
  default     = 3 # 仏の顔も3度まで
}

variable "alb_target_group_health_check_unhealthy_threshold" {
  type        = number
  description = <<DESC
ヘルスチェック先をUnhealthyと判断するヘルスチェック回数
指定しない場合はalb_target_group_health_check_healthy_thresholdの値を利用します
DESC
  default     = 0
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

  # ALBの設定
  alb_name             = var.service_suffix == "" ? "${var.service_name}-${var.env}-alb" : "${var.service_name}-${var.service_suffix}-${var.env}-alb"
  alb_deletion_protect = can(regex("^prod$|^prd$", var.env)) ? true : false # var.envがprodまたはprdだったらALBは削除保護する
  alb_tags             = merge(
    var.alb_additional_tags,
    local.default_tags
  )

  # ログ格納バケットの設定
  alb_log_bucket_name          = "${local.alb_name}-log-bucket"
  alb_log_bucket_force_destroy = can(regex("^prod$|^prd$", var.env)) ? false : true
  # var.envがprodまたはprdだったらログバケットのforce_destroyは無効
  alb_log_bucket_lifecycle_id  = "${local.alb_name}-log-lifecycle"

  # ALBターゲットグループの設定
  alb_target_group_name                             = "${local.alb_name}-tg"
  alb_target_group_health_check_port                = var.alb_target_group_health_check_port == 0 ? var.alb_target_group_port : var.alb_target_group_health_check_port
  alb_target_group_health_check_unhealthy_threshold = var.alb_target_group_health_check_unhealthy_threshold == 0 ? var.alb_target_group_health_check_healthy_threshold : var.alb_target_group_health_check_unhealthy_threshold
}