variable "service_name" {
  description = "サービス名"
  type = string
}

variable "env" {
  description = "環境識別子(dev, stg, prod)"
  type = string
}

variable "role" {
  description = "リポジトリに格納するイメージのサービス内におけるロール"
  type = string
}

variable "image_tag_mutability" {
  description =<<DESC
タグの上書きを許容するか否かを指定します。
- `MUTABLE` 上書き可能
- `IMMUTABLE` 上書き不可
DESC
  type = string
  default = "MUTABLE"
}

variable "image_scanning_scan_on_push_enabled" {
  description = "リポジトリへのイメージプッシュ時の脆弱性スキャンを有効化するか否かを指定します。"
  type = bool
  default = false
}

variable "repository_additional_tags" {
  description =<<DESC
ECRリポジトリに付与したい追加タグ
- ServiceName
- Env
- Role
は予約済みのため利用できません。
DESC
  type = map(string)
  default = {}
  validation {
    condition     = length(setintersection(keys(var.repository_additional_tags), ["ServiceName", "Env", "Role"])) == 0
    error_message = "Key names, ServiceName, Env and Role is reserved. Not allowed to use them."
  }
}

variable "repository_lifecycle_policy" {
  description =<<DESC
リポジトリのライフサイクルポリシーをJSON形式で指定します。
デフォルト値を指定した場合は、タグのないイメージのうちプッシュから30日以上経過したイメージを削除します。
具体的な記述内容は`lifecycle_policy/default_policy.json`を
参考) https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/LifecyclePolicies.html
DESC
  type = string
  default = ""
}