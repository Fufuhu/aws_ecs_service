locals {
  domain = "https://token.actions.githubusercontent.com"
  // OpenIDプロバイダの設定ドキュメントパス( OpenID Connect Discovery 1.0 )
  // ref) https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfigurationRequest
  openid_provider_configuration_path = "/.well-known/openid-configuration"
  // OpenIDプロバイダ設定の取得URL
  openid_configuration_url = "${local.domain}${local.openid_provider_configuration_path}"
}

data "http" "openid_configuration" {
  url = local.openid_configuration_url
}

data "tls_certificate" "encryption_key" {
  url = jsondecode(data.http.openid_configuration.body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = local.domain
  client_id_list  = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    data.tls_certificate.encryption_key.certificates[0].sha1_fingerprint
  ]
}