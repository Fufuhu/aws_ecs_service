locals {
  iam_role_tags = merge(
    var.iam_role_additional_tags,
    {
      ServiceName = var.service_name
      Env = var.env
    }
  )
}

data "aws_caller_identity" "caller_identity" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${var.github_organization_name}/${var.github_repository_name}:*"
      ]
    }

    condition {
      test = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.service_name}-${var.env}-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}