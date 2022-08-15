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

variable "task_role_additional_tags" {
  type        = map(string)
  description = "タスクロールに追加するリソースタグ"
  default     = {}


  validation {
    condition = length(setintersection(keys(var.task_role_additional_tags), [
      "Name", "Env", "ServiceName", "ServiceSuffix", "Role"
    ])) == 0
    error_message = "Key names, Name and Env, ServiceName, ServiceSuffix, Role are reserved. Not allowed to use them."
  }
}

variable "task_exec_role_additional_tags" {
  type        = map(string)
  description = "タスク実行ロールに追加するリソースタグ"
  default     = {}


  validation {
    condition = length(setintersection(keys(var.task_exec_role_additional_tags), [
      "Name", "Env", "ServiceName", "ServiceSuffix", "Role"
    ])) == 0
    error_message = "Key names, Name and Env, ServiceName, ServiceSuffix, Role are reserved. Not allowed to use them."
  }
}

variable "task_role_maneged_policy_arns" {
  description = "タスクロールに付与する管理ポリシーARNのリストをしていします"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.task_role_maneged_policy_arns) < 10
    error_message = "Number of managed policies attached must be at most 10."
  }
  # ref) https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_iam-quotas.html
}

variable "task_role_inline_policies" {
  description = <<DESC
タスクロールに付与するインラインポリシーです。
キーにインラインポリシー名、値にインラインポリシーのボディ(JSON)を記述します。
DESC
  type        = map(string)
  default     = {}
}

locals {
  task_role_name      = var.service_suffix == "" ? "${var.service_name}-${var.env}-task-role" : "${var.service_name}-${var.service_suffix}-${var.env}-task-role"
  task_exec_role_name = var.service_suffix == "" ? "${var.service_name}-${var.env}-task-exec-role" : "${var.service_name}-${var.service_suffix}-${var.env}-task-exec-role"

  default_tags = var.service_suffix == "" ? {
    ServiceName = var.service_name
    Env         = var.env
  } : {
    ServiceName   = var.service_name
    ServiceSuffix = var.service_suffix
    Env           = var.env
  }

  task_role_tags = merge(
    var.task_role_additional_tags,
    local.default_tags,
    {
      Role = "task role"
    }
  )

  task_exec_role_tags = merge(
    var.task_exec_role_additional_tags,
    local.default_tags,
    {
      Role = "task exec role"
    }
  )
}