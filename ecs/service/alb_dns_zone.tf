data "aws_route53_zone" "zone" {
  name = local.hosted_zone_domain
}