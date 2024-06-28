

# resource "azurerm_databricks_access_connector" "access_connector" {
#   name     = "${var.prefix}-${var.environment}-${var.access_connector_name}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_storage_account" "unity_catalog" {
#   name                     = var.metastore_storage_name
#   location                 = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   tags                     = var.tags
#   account_tier             = "Standard"
#   account_replication_type = var.account_replication_type
#   is_hns_enabled           = true
# }

# resource "azurerm_storage_container" "unity_catalog" {
#   name                  = var.azurerm_storage_container
#   storage_account_name  = azurerm_storage_account.unity_catalog.name
#   container_access_type = "private"
# }

# locals {
#   uc_roles = [
#     "Storage Blob Data Contributor",  # Normal data access
#     "Storage Queue Data Contributor", # File arrival triggers
#     "EventGrid EventSubscription Contributor",
#   ]
# }

# # resource "azurerm_storage_data_lake_gen2_filesystem" "unity_catalog_fs" {
# #   name               = var.azurerm_storage_container
# #   storage_account_id = azurerm_storage_account.unity_catalog.id
# # }


# # resource "databricks_metastore" "unity_catalog" {
# #   name             = "${var.prefix}-metastore"
# #   storage_root     = "abfss://${azurerm_storage_container.unity_catalog.name}@${azurerm_storage_account.unity_catalog.name}.dfs.core.windows.net/"
# #   force_destroy    = true
# #   //comment          = "Unity Catalog Metastore for Databricks"
# # }



# resource "azurerm_role_assignment" "unity_catalog" {
#   for_each             = toset(local.uc_roles)
#   scope                = azurerm_storage_account.unity_catalog.id
#   role_definition_name = each.value
#   principal_id         = azurerm_databricks_access_connector.access_connector.identity[0].principal_id
# }