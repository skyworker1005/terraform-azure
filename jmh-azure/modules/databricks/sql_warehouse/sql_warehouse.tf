terraform {
    required_providers {
        databricks = {
            source = "databricks/databricks"
            // ...
        }
    }
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}

resource "databricks_sql_endpoint" "sql_warehouse" {
  name        = var.sql_warehouse_name
  cluster_size = var.cluster_size
  max_num_clusters = var.max_num_clusters
  auto_stop_mins = var.auto_stop_mins
  min_num_clusters = var.min_num_clusters
  enable_photon = var.enable_photon
  spot_instance_policy = var.spot_instance_policy
  //tags = var.tags

  depends_on = [
    databricks_cluster.this
  ]
}
