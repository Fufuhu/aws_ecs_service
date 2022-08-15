module "roles" {
  source       = "../../modules/ecs/iam/roles"
  service_name = local.service_name
  env          = terraform.workspace

  # task_exec_role_additional_tags = {}

  # task_role_maneged_policy_arns = []
  # task_role_inline_policies = {}
  # task_exec_role_additional_tags = {}
}