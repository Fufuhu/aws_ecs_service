data "aws_acm_certificate" "cerfiticate" {
  domain = local.certificate_domain
}