resource "aws_alb_target_group" "target_group" {
  name = local.alb_target_group_name

  vpc_id      = var.alb_vpc_id
  target_type = "ip"

  port     = var.alb_target_group_port
  protocol = "HTTP"

  health_check {
    enabled             = true
    port                = local.alb_target_group_health_check_port
    path                = var.alb_target_group_health_check_path
    interval            = var.alb_target_group_health_check_interval
    healthy_threshold   = var.alb_target_group_health_check_healthy_threshold
    unhealthy_threshold = local.alb_target_group_health_check_unhealthy_threshold

    # 2XX系だとHealthyと判断する
    matcher = "200-299"
  }

  tags = local.alb_tags
}