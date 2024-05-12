output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the resource group created for the data lake."
}

output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the storage account used for the data lake."
}

output "storage_account_id" {
  value       = azurerm_storage_account.sa.id
  description = "The ID of the storage account used for the data lake."
}

output "bronze_filesystem_id" {
  value       = azurerm_storage_data_lake_gen2_filesystem.bronze.id
  description = "The resource ID of the Bronze data lake filesystem."
}

output "silver_filesystem_id" {
  value       = azurerm_storage_data_lake_gen2_filesystem.silver.id
  description = "The resource ID of the Silver data lake filesystem."
}

output "gold_filesystem_id" {
  value       = azurerm_storage_data_lake_gen2_filesystem.gold.id
  description = "The resource ID of the Gold data lake filesystem."
}

output "bronze_filesystem_name" {
  value       = azurerm_storage_data_lake_gen2_filesystem.bronze.name
  description = "The name of the Bronze data lake filesystem."
}

output "silver_filesystem_name" {
  value       = azurerm_storage_data_lake_gen2_filesystem.silver.name
  description = "The name of the Silver data lake filesystem."
}

output "gold_filesystem_name" {
  value       = azurerm_storage_data_lake_gen2_filesystem.gold.name
  description = "The name of the Gold data lake filesystem."
}
