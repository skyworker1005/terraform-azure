output "databricks_host" {
  value = module.databricks_workspace.databricks_host
}

output "databricks_token" {
  value = module.databricks_token.token
}

output "databricks_cluster_id" {
  value = module.databricks_cluster.cluster_id
}
