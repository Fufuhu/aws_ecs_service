locals {
  service_name = "sample"
  role = "web"
}

module "ecr" {
  source = "../modules/ecr"
  service_name = local.service_name
  env    = terraform.workspace
  role   = "web"
}

module "iam_role" {
  source       = "../modules/iam/role/oidc/github"
  service_name = "${local.service_name}-${local.role}"
  env = terraform.workspace
  inline_policy_documents = {
    "ImagePush" = module.ecr.image_push_policy_document
  }
  github_organization_name = "Fufuhu"
  github_repository_name = "aws_ecr"
}