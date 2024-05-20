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