
/*
  aws_ecs_cluster dataソースからARNを取得してECSサービスモジュールの呼び出しに渡す。
  aws_caller_identity dataソースと、ARNルールを組み合わせてECSクラスターのARNを生成しても良い
*/
data "aws_ecs_cluster" "cluster" {
  cluster_name = local.ecs_cluster_name
}
