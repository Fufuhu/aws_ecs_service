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

variable "task_additional_tags" {
  description = "ECSタスク定義に付与する追加リソースタグ"
  type        = map(string)
  default     = {}


  validation {
    condition = length(setintersection(keys(var.task_additional_tags), [
      "Name", "Env", "ServiceName", "ServiceSuffix"
    ])) == 0
    error_message = "Key names, Name and Env, ServiceName, ServiceSuffix is reserved. Not allowed to use them."
  }
}

variable "task_cpu_allocation" {
  type        = number
  description = "タスク全体に割当てるCPU資源量(1024=1vCPU)"
  default     = 1024
}

variable "task_memory_allocation" {
  type        = number
  description = "タスク全体に割当てるメモリ量(MB)"
  default     = 2048
}

variable "container_definition" {
  type        = string
  description = "タスクのコンテナ定義"
  default     = <<DESC
[
  {
    "name": "nginx",
    "image": "nginx:1.21",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DESC
}

variable "task_role_arn" {
  type        = string
  description = "タスクロールのARN"
}

variable "task_exec_role_arn" {
  type        = string
  description = "タスク実行ロールのARN"
}

locals {
  task_family_name = var.service_suffix == "" ? "${var.service_name}-${var.env}-task" : "${var.service_name}-${var.service_suffix}-${var.env}-task"

  default_tags = var.service_suffix == "" ? {
    ServiceName = var.service_name
    Env         = var.env
  } : {
    ServiceName   = var.service_name
    ServiceSuffix = var.service_suffix
    Env           = var.env
  }

  task_resource_tags = merge(
    {
      Name = local.task_family_name
    },
    var.task_additional_tags,
    local.default_tags
  )
}