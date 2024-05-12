output "public_subnet_name" {
  value = var.subnet1_name
}

output "private_subnet_name" {
  value = var.subnet2_name
}

output "virtual_network_id" {
  value = var.vnet_id
}

output "dbworkspace_id" {
  value       = azurerm_databricks_workspace.dbworkspace.id
  description = "The ID of the Databricks workspace."
}

# output "workspace_managed_identity_id" {
#   description = "The managed identity of the Databricks workspace."
#   value       = azurerm_databricks_workspace.dbworkspace.managed_resource_group_id
# }

# output "workspace_managed_identity_id" {
#   value = azurerm_databricks_workspace.dbworkspace.identity[0].principal_id
# }

