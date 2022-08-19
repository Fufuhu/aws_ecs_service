variable "service_name" {
  type        = string
  description = <<DESC
ECSサービスではなく、ECSサービスが構成する広義のサービス名
DESC
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

# ECSサービスの設定

variable "ecs_service_cluster_arn" {
  type = string
  description = "ECSサービスが所属するECSクラスタのARN"
}

variable "ecs_service_task_definition_arn" {
  type = string
  description = "ECSサービスで実行するECSタスク定義のARN"
}

variable "ecs_service_task_desired_count" {
  type = number
  description = "ECSサービスで実行するECSタスクの希望多重度"
  default = 3
}

variable "ecs_service_task_maximum_percent" {
  type = number
  description = <<DESC
ECSサービスで実行するECSタスクの希望多重度(ecs_service_task_desired_count)に対して
最大で何%までのタスク実行を許容するか？
DESC
  default = 200

  validation {
    condition = var.ecs_service_task_maximum_percent > 100
    error_message = "Value must be over 100."
  }
}

variable "ecs_service_task_minimum_percent" {
  type = number
  description = <<DESC
ECSサービスで実行するECSタスクの希望多重度(ecs_service_task_desired_count)に対して
最小で何%までのタスク実行を許容するか？
DESC
  default = 100

  validation {
    condition = var.ecs_service_task_minimum_percent <= 100
    error_message = "Value must be at most 100."
  }
}

variable "ecs_service_additional_tags" {
  type        = map(string)
  description = "ECSサービスとその関連リソースに付与する追加リソースタグ"
  default     = {}

  validation {
    condition     = length(setintersection(keys(var.ecs_service_additional_tags), ["ServiceName", "ServiceSuffix", "Env"])) == 0
    error_message = "Key names, ServiceName, ServiceSuffix, Env are reserved. Not allowed to use them. "
  }
}

# ECS Exec設定

variable "ecs_service_enable_execute_command" {
  type = bool
  description = "ECS Execの有効化の有無"
  default = false
}

# ECSサービスのネットワーク設定

variable "ecs_service_subnets" {
  type = list(string)
  description = "ECSサービスの所属するサブネットIDのリスト"
}

variable "ecs_service_security_groups" {
  type = list(string)
  description = "ECSサービスに付与するセキュリティグループIDのリスト"
}


# ECSサービスのロードバランサ設定
# ARN指定がない場合はロードバランサ配下のServiceにはならない(≒バッチ系の待受になる)

variable "ecs_service_alb_target_group_arn" {
  type = string
  description = "ECSサービスに付与するALBターゲットグループのARN"
  default = ""
}

variable "ecs_service_alb_target_group_container_name" {
  type = string
  description = <<DESC
ECSサービスでALBのターゲットグループでターゲットにするコンテナの名前を指定します。
コンテナの名前はタスク定義の中に含まれるものを指定します。
DESC
  default = ""
}

variable "ecs_service_alb_target_group_container_port" {
  type = string
  description = <<DESC
ecs_service_alb_target_group_container_nameでリッスンしているポート番号を指定します。
DESC
  default = 80
}


# ECSサービスのデプロイメントコントローラ設定

variable "ecs_service_deployment_controller" {
  type = string
  description = <<DESC
ECSサービスのデプロイに利用するコントローラ設定
DESC
  default = "ECS"

  validation {
    condition = contains(
      [
        "ECS",
        "CodeDeploy",
        "External"
      ],
      var.ecs_service_deployment_controller
    )

    error_message = "Deployment controller must be ECS, CodeDeploy or External."
  }
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

  # ECSサービスの設定
  ecs_service_name = var.service_suffix == "" ? "${var.service_name}-${var.env}-service" : "${var.service_name}-${var.service_suffix}-${var.env}-service"

  ecs_service_tags = merge(
    var.ecs_service_additional_tags,
    local.default_tags
  )

  ecs_service_is_load_balancer_active = var.ecs_service_alb_target_group_arn != "" ? [1] : []
}