output "cluster_arn" {
  description = "ECSクラスターのARN"
  value       = module.cluster.cluster_arn
}

output "cluster_tags" {
  description = "ECSクラスターのタグ"
  value       = module.cluster.cluster_tags
}