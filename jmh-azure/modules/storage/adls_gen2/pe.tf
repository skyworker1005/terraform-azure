
resource "azurerm_private_endpoint" "adls_gen2_private_endpoint" {
  name                = "${var.prefix}-adls-gen2-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.prefix}-adls-gen2-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["dfs"]
    is_manual_connection           = false
  }

   private_dns_zone_group {
    name                 = "private-dns-zone-databricks-adls-gen2-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.dfs_zone.id]
  }
}

resource "azurerm_private_dns_zone" "dfs_zone" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs_dns_link" {
  name                  = "${var.prefix}-dfs-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dfs_zone.name
  virtual_network_id    = var.vnet_id
}
