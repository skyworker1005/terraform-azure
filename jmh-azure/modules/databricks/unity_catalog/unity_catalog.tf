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

resource "databricks_metastore" "unity_catalog_metastore" {
  name           = var.unity_catalog_metastore_name
  storage_root   = "abfss://${var.unity_catalog_storage_container_name}@${var.unity_catalog_storage_account_name}.dfs.core.windows.net/"
  region         = var.location
  //catalog_name         = var.unity_catalog_name
  force_destroy        = true
}

# resource "databricks_unity_catalog" "unity_catalog" {
#   name         = var.unity_catalog_name
#   account_id   = var.databricks_account_id
#   metastore_id = databricks_metastore.unity_catalog_metastore.id
# }