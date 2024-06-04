resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                = "${lower(var.prefix)}${lower(var.environment)}sa"

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

resource "azurerm_private_endpoint" "adls_gen2_private_endpoint" {
  name                = "${var.prefix}-adls-gen2-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "${var.prefix}-adls-gen2-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "blob_private_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "${var.prefix}-blob-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob_private_dns.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "adls_gen2_a_record" {
  name                = azurerm_storage_account.sa.name
  zone_name           = azurerm_private_dns_zone.blob_private_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.adls_gen2_private_endpoint.private_service_connection[0].private_ip_address]
}
