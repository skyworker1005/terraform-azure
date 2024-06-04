# output "unity_catalog_name" {
#   value       = databricks_unity_catalog.unity_catalog.name
#   description = "The name of the Unity Catalog."
# }

output "databricks_metastore_id" {
  value       = databricks_metastore.unity_catalog_metastore.id
  description = "The ID of the Databricks metastore."
}

# output "unity_catalog_storage_account_name" {
#   value       = azurerm_storage_account.unity_catalog.name
#   description = "The name of the Unity Catalog storage account."
# }

# output "unity_catalog_storage_container_name" {
#   value       = azurerm_storage_container.unity_catalog.name
#   description = "The name of the Unity Catalog storage container."
# }