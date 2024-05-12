output "workspace_url" {
  value = "https://${azurerm_databricks_workspace.example.workspace_url}/"
}

output "region" {
  value = var.rglocation
}

output "adls_gen2_path" {
  value = "${var.azurerm_storage_container}@${var.metastore_storage_name}.dfs.core.windows.net/"
}

output "azurerm_databricks_access_connector_id" {
  value = azurerm_databricks_access_connector.access_connector.id
}
