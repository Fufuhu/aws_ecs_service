resource "aws_security_group" "security_group" {
  name   = local.security_group_name
  vpc_id = var.vpc_id
  tags   = local.security_group_tags
}

resource "aws_security_group_rule" "security_group_rule_ingress_cidr_http" {
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.security_group_ingress_cidrs
}

resource "aws_security_group_rule" "security_group_rule_ingress_cidr_https" {
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.security_group_ingress_cidrs
}

resource "aws_security_group_rule" "security_group_rule_ingress_http_self" {
  count             = var.security_group_ingress_allow_self ? 1 : 0
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  self              = var.security_group_ingress_allow_self
}

resource "aws_security_group_rule" "security_group_rule_ingress_https_self" {
  count             = var.security_group_ingress_allow_self ? 1 : 0
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  self              = var.security_group_ingress_allow_self
}


resource "aws_security_group_rule" "security_group_rule_ingress_http_sgs" {
  for_each                 = toset(var.security_group_ingress_sgs)
  security_group_id        = aws_security_group.security_group.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "security_group_rule_ingress_https_sgs" {
  for_each                 = toset(var.security_group_ingress_sgs)
  security_group_id        = aws_security_group.security_group.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "security_group_rule_egress" {
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = var.security_group_egress_cidrs
}

resource "aws_security_group_rule" "security_group_rule_egress_sgs" {
  for_each                 = toset(var.security_group_ingress_sgs)
  security_group_id        = aws_security_group.security_group.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "security_group_rule_egress_self" {
  count             = var.security_group_egress_allow_self ? 1 : 0
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  self              = var.security_group_egress_allow_self
}