
output "databricks_host" {
  #value = azurerm_databricks_workspace.dbworkspace.workspace_url
  value = module.kdp_databricks_workspace.databricks_host
}


output "databricks_token_value" {
    value = module.kdp_databricks_token.databricks_token_value
    sensitive = true
}