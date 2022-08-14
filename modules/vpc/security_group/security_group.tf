resource "aws_security_group" "security_group" {
  name   = local.security_group_name
  vpc_id = var.vpc_id
  tags   = local.security_group_tags
}


resource "aws_security_group_rule" "ingress_cidr_security_group_rules" {
  for_each = toset(local.ingress_cidr_ports)
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  protocol          = "TCP"
  from_port         = each.value
  to_port           = each.value
  cidr_blocks = var.security_group_ingress_cidrs
}

resource "aws_security_group_rule" "ingress_sg_security_group_rules" {
  for_each = local.ingress_sg_rules
  type              = "ingress"
  security_group_id = aws_security_group.security_group.id
  protocol          = "TCP"
  from_port         = each.value[0]
  to_port           = each.value[0]
  source_security_group_id = each.value[1]
}

resource "aws_security_group_rule" "ingress_self_security_group_rule" {
  for_each = toset(local.ingress_self_rules)
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  self              = true
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
  for_each                 = toset(var.security_group_egress_sgs)
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