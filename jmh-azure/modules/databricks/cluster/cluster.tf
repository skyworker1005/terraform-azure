terraform {
    required_providers {
        databricks = {
            source = "databricks/databricks"
            // ...
        }
    }
}



provider "databricks" {
  #host  = var.databricks_host
  #host = "https://${azurerm_databricks_workspace.dbworkspace.workspace_url}/"
  token = var.databricks_token
  host = var.databricks_host
}

resource "databricks_cluster" "this" {
    cluster_name = var.cluster_name
    spark_version = var.spark_version
    node_type_id = var.node_type_id
    autotermination_minutes = var.autotermination_minutes
    num_workers = 1
    

    custom_tags = {
        "ResourceClass" = "SingleNode"
    }

    spark_conf = {
        "spark.speculation" = "true"
        "spark.databricks.optimizer.enabled" = "true"
    }

    azure_attributes {
        availability = "ON_DEMAND"
        first_on_demand = 1
        spot_bid_max_price = -1.0
    }
}