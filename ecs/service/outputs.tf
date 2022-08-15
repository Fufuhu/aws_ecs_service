output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids
}

output "alb_fqdn" {
  value = module.alb.alb_fqdn
}

output "alb_tags" {
  value = module.alb.alb_tags
}

output "alb_target_group_arn" {
  value = module.alb.alb_target_group_arn
}


output "security_group_name" {
  value = module.alb_security_group.security_group_name
}

output "security_group_tags" {
  value = module.alb_security_group.security_group_tags
}


output "https_endpoint_url" {
  value = "https://${aws_route53_record.record.name}"
}