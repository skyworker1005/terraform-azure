
resource "azurerm_private_endpoint" "databricks_frontend" {
  name                = "${var.prefix}-databricks_frontend"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.prefix}-databricks_frontend-psc"
    private_connection_resource_id = azurerm_databricks_workspace.dbworkspace.id
    subresource_names              = ["databricks_ui_api"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-databricks-frontend-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.databricks_zone.id]
  }
}

resource "azurerm_private_dns_zone" "databricks_zone" {
  name                = "privatelink.databricks.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks_dns_link" {
  name                  = "${var.prefix}-dns-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.databricks_zone.name
  virtual_network_id    = var.vnet_id
}


# resource "azurerm_private_endpoint" "databricks_backend" {
#   name                = "${var.prefix}-databricks_backend"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = var.private_endpoint_subnet_id
#   private_service_connection {
#     name                           = "${var.prefix}-databricks_backend-psc"
#     private_connection_resource_id = azurerm_databricks_workspace.dbworkspace.id
#     subresource_names              = ["databricks_ui_api"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "${var.prefix}-private-dns-zone-databricks-backend"
#     private_dns_zone_ids = [azurerm_private_dns_zone.databricks_zone.id]
#   }
# }



