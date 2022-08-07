module "cluster" {
  source                  = "git@github.com:Fufuhu/aws_ecs_cluster.git//modules/ecs/cluster?ref=v0.0.1"
  service_name            = "sample"
  env                     = terraform.workspace
  cluster_additional_tags = {}
}