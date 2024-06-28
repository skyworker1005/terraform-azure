# output "public_subnet_name" {
#   value = var.public_subnet_name
# }
output "databricks_workspace_resource_group_name" {
  value = azurerm_databricks_workspace.dbworkspace.resource_group_name
}

output "azurerm_databricks_workspace_rg_name" {
  value = azurerm_resource_group.rg.name 
}

output "private_subnet_name" {
  value = var.private_subnet_name
}

output "virtual_network_id" {
  value = var.vnet_id
}

output "databricks_workspace_id" {
  value       = azurerm_databricks_workspace.dbworkspace.id
  description = "The ID of the Databricks workspace."
}

output "databricks_workspace_url" {
  //value = azurerm_databricks_workspace.dbworkspace.workspace_url
  value = "https://${azurerm_databricks_workspace.dbworkspace.workspace_url}/"
}


# output "databricks_token" {
#   value = databricks_token.token.token_value
# }