output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.example.id
}

output "unity_catalog_id" {
  value = databricks_unity_catalog.example.id
}