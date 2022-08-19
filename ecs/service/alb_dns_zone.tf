data "aws_route53_zone" "zone" {
  name = local.dns_hosted_zone_domain
}