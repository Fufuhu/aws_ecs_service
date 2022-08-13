module "alb" {
  source = "../../modules/ecs/service/alb"
  service_name = local.service_name
  env = terraform.workspace

  # ALB本体設定
  alb_subnet_ids = data.aws_subnets.public_subnets.ids # ALBを紐付けるサブネットID
  # ALBに付与するセキュリティグループのID
  alb_security_group_ids = [
    module.alb_security_group.security_group_id
  ]
  # alb_additional_tags = {} # モジュール内の各種リソースに付与する追加タグ

  # ログ設定
  # alb_log_transition_in_days = 90 # ログをSTANDARDからSTANDARD IAに移動するまでの日数
  # alb_log_expiration_in_days = 550 # ログを削除するまでの保管期間

  # リスナー設定(HTTPリスナー)
  # alb_enable_http_listener = true # HTTPリスナーを有効化
  # alb_enable_redirect_http_to_https = true # HTTPリスナーではHTTP -> HTTPSにリダイレクト

  # リスナー設定(HTTPSリスナー)
  # alb_enable_https_listener = true # HTTPSリスナーを有効化
  # alb_https_listener_ssl_policy = "ELBSecurityPolicy-2016-08"
  alb_https_certificate_arn = data.aws_acm_certificate.cerfiticate.arn # HTTPSリスナーに紐付ける証明書ARNを指定

  # ターゲットグループ設定
  alb_vpc_id = data.aws_vpc.vpc.id # ターゲットグループを紐付けるVPC ID
  # alb_target_group_port = 80 # ターゲットグループの待受ポート
  # alb_target_group_health_check_port = 80 # ヘルスチェック用ポート
  # alb_target_group_health_check_path = "/" # ヘルスチェック用パス
  # alb_target_group_health_check_interval = 30 # ヘルスチェックの間隔
  # alb_target_group_health_check_timeout = 10 # ヘルスチェックのタイムアウト
  # alb_target_group_health_check_healthy_threshold = 3 # ヘルスチェック先をHealthyとみなすヘルスチェック回数
  # alb_target_group_health_check_unhealthy_threshold = 0 # ヘルスチェック先をUnhealthyとみなすヘルスチェック回数
}
