# GitHub Actionsのワークフローを使ってECSサービスのCDを行うためのIAMロールを準備

data "aws_caller_identity" "caller_identity" {}

data "aws_iam_policy_document" "ecr_login" {
  statement {
    sid     = "GetAuthorizationToken"
    effect  = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "docker_image_pull" {
  statement {
    sid     = "AllowPull"
    effect  = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.caller_identity.account_id}:repository/${local.service_name}-${terraform.workspace}-web"
    ]
  }
}

data "aws_iam_policy_document" "deploy_service" {
  statement {
    sid     = "RegisterTaskDefinition"
    effect  = "Allow"
    actions = [
      "ecs:RegisterTaskDefinition"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "DescribeTaskDefinition"
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid     = "DeployService"
    effect  = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices"
    ]
    resources = [
      module.ecs_service.ecs_service_arn
    ]
  }

  statement {
    sid     = "PassRolesInTaskDefinition"
    effect  = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      data.aws_ecs_task_definition.task_definition.task_role_arn,
      "arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:role/${local.service_name}-${terraform.workspace}-task-exec-role"
    ]
  }
}

module "github_actions_workflow_iam_role" {
  source = "../../modules/iam/role/oidc/github"

  github_organization_name = "Fufuhu"
  github_repository_name   = "aws_ecs_service"
  service_name             = local.service_name
  env                      = terraform.workspace

  inline_policy_documents = {
    ECRLogin           = data.aws_iam_policy_document.ecr_login.json
    PullContainerImage = data.aws_iam_policy_document.docker_image_pull.json
    DeployECSService   = data.aws_iam_policy_document.deploy_service.json
  }
}