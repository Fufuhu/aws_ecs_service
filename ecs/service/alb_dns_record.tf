resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.id
  name = local.dns_a_record
  type = "A"

  alias {
    name                   = module.alb.alb_fqdn
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }

}