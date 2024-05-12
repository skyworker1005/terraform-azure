
# resource "azurerm_resource_group" "kdp" {
#   name     = "${var.prefix}-${var.environment}-STORAGE"
#   location = var.location
# }


# resource "azurerm_storage_account" "kdp" {
#   name                     = "${var.prefix}"
#   resource_group_name      = azurerm_resource_group.kdp.name
#   location                 = azurerm_resource_group.kdp.location
#   account_tier             = var.account_tier
#   account_replication_type = var.account_replication_type
#   is_hns_enabled           = var.is_hns_enabled  # 인용부호 제거 및 변수 직접 참조

#   tags = {
#     Environment = var.environment
#   }
# }


# resource "azurerm_storage_data_lake_gen2_filesystem" "kdp" {
#   name                = "${var.prefix}"
#   storage_account_id = azurerm_storage_account.kdp.id
# }

