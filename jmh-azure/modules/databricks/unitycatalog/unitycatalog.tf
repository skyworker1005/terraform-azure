
terraform {
    required_providers {
        databricks = {
            source = "databricks/databricks"
            // ...
        }
    }
}


resource "azurerm_databricks_workspace" "example" {
  name                        = var.databricks_workspace_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = "standard"
  managed_resource_group_name = "${var.databricks_workspace_name}_managed_resource_group"
}

resource "databricks_unity_catalog" "example" {
  name                        = var.unity_catalog_name
  workspace_id                = azurerm_databricks_workspace.example.id
}
