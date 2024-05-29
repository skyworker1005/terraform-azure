resource_group_name = "my-resource-group"
location = "eastus"
workspace_name = "my-databricks-workspace"
token_name = "my-databricks-token"
token_lifetime_days = 30
cluster_name = "my-databricks-cluster"
cluster_config = {
  spark_version = "6.4.x-scala2.11"
  node_type_id = "Standard_D3_v2"
  autotermination_minutes = 20
  num_workers = 2
}
