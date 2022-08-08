resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_in_days
  tags              = local.log_group_tags
}