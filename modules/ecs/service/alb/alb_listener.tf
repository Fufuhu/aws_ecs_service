
locals {
  http_default_action_type = var.alb_enable_redirect_http_to_https ? "redirect" : "forward"

}

# HTTP -> HTTPSリダイレクトをさせるか、直接HTTPリスナーで応答させるかを記述する。
# デフォルトの変数設定を利用する場合はHTTPリスナーは作成されるが、HTTPSにリダイレクトする。
# countで別アドレスで作り分ける方法とdynamicブロックを使って同一アドレスのリソース内で作り分ける方法がある。
# 今回はcountをつかって別アドレスで
resource "aws_alb_listener" "http_listener_forward" {
  # alb_enable_http_listenerがtrue、およびalb_enable_redirect_http_to_httpsがfalse
  # の場合にのみリソースを作成
  count = var.alb_enable_http_listener && !var.alb_enable_redirect_http_to_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  protocol = "HTTP"
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }

  tags = local.alb_tags
}

resource "aws_alb_listener" "http_listener_redirect" {
  # alb_enable_http_listenerがtrue、alb_enable_redirect_http_to_httpsがtrue
  # の場合にのみリソースを作成。HTTPSにリダイレクトする。
  count = var.alb_enable_http_listener && var.alb_enable_redirect_http_to_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  protocol = "HTTP"
  port = 80

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301" # 301 Moved Permanently
    }
  }

  tags = local.alb_tags
}

resource "aws_alb_listener" "https_listener" {
  # alb_enable_https_listenerがtrueの場合のみリソースを作成
  count = var.alb_enable_https_listener ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  protocol = "HTTPS"
  port = 443
  ssl_policy = var.alb_https_listener_ssl_policy
  certificate_arn = var.alb_https_certificate_arn
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }

  tags = local.alb_tags
}