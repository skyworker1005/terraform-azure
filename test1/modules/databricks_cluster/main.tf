terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      configuration_aliases = [databricks.main]
    }
  }
}

resource "databricks_cluster" "cluster" {
  cluster_name            = var.cluster_name
  spark_version           = var.cluster_config["spark_version"]
  node_type_id            = var.cluster_config["node_type_id"]
  autotermination_minutes = var.cluster_config["autotermination_minutes"]
  num_workers             = var.cluster_config["num_workers"]
}

output "cluster_id" {
  value = databricks_cluster.cluster.id
}
