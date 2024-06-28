locals {
  azurerm_resource_group_rg_name = "${var.prefix}-${var.environment}-${var.rg_name}"
  storage_account_name = "${lower(var.prefix)}${lower(var.environment)}sa"
  storage_account_name_dbfs = "${lower(var.prefix)}${lower(var.environment)}sadbfs"
}

resource "azurerm_resource_group" "rg" {
  name     = local.azurerm_resource_group_rg_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                = local.storage_account_name

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  is_hns_enabled           = true
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "sa_dbfs" {
  name                = var.dbfs_storage_account_name

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  is_hns_enabled           = true
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "${lower(var.prefix)}-${lower(var.environment)}-bronze"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on         = [azurerm_storage_account.sa]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name               = "${lower(var.prefix)}-${lower(var.environment)}-silver"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on         = [azurerm_storage_account.sa]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "${lower(var.prefix)}-${lower(var.environment)}-gold"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on         = [azurerm_storage_account.sa]
}

resource "azurerm_role_assignment" "databricks_sa_access" {
  principal_id        = var.databricks_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope               = azurerm_storage_account.sa.id
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
