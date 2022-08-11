resource "aws_lb" "alb" {
  name                       = local.alb_name
  internal                   = false # 外部LBなのでfalse
  enable_deletion_protection = local.alb_deletion_protect

  load_balancer_type = "application" # ロードバランサーの種類(ALBなのでapplicationを指定)

  subnets = var.alb_subnet_ids # ロードバランサーを配置するサブネットIDのリスト

  access_logs {
    bucket  = aws_s3_bucket.log_bucket.bucket
    enabled = true
  }

  # 追加タグをデフォルトのタグで上書き
  tags = local.alb_tags
}