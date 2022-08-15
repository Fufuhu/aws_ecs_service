variable "service_name" {
  description = "サービス名"
  type        = string
}

variable "service_suffix" {
  type        = string
  description = "サービス名のサフィックス(サブサービス名やコンポーネント名)"
  default     = ""
}

variable "env" {
  description = "環境識別子（dev, stg, prod）"
  type        = string
}

variable "log_retention_in_days" {
  description = "ロググループにログを保持する期間です"
  type        = number
  default     = 30
}

variable "log_group_additional_tags" {
  description = "ロググループに付与する追加タグです"
  type        = map(string)
  default     = {}


  validation {
    condition = length(setintersection(keys(var.log_group_additional_tags), [
      "Name", "Env", "ServiceName", "ServiceSuffix"
    ])) == 0
    error_message = "Key names, Name and Env, ServiceName, ServiceSuffix, Role are reserved. Not allowed to use them."
  }
}


locals {
  log_group_name = var.service_suffix == "" ? "${var.service_name}-${var.env}-log-group" : "${var.service_name}-${var.service_suffix}-${var.env}-log-group"

  default_resource_tags = var.service_suffix == "" ? {
    Name        = local.log_group_name
    ServiceName = var.service_name
    Env         = var.env
  } : {
    Name          = local.log_group_name
    ServiceName   = var.service_name
    ServiceSuffix = var.service_suffix
    Env           = var.env
  }

  log_group_tags = merge(
    var.log_group_additional_tags,
    local.default_resource_tags
  )
}