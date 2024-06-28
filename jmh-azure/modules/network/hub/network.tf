resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.prefix}-hub-vnet"
  location            = var.location
  address_space       = [var.hub_vnet_cidr]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "${var.prefix}-firewall-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.firewall_subnet_cidr]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "${var.prefix}-private-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.private_endpoint_subnet_cidr]
}