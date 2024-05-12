
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-${var.vnet_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["${var.vnet_cidr}"]
}

# Public 
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.prefix}-${var.subnet1_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet1_cidr]
  delegation {
    name = "databricks_delegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.prefix}-${var.subnet2_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet2_cidr]
  delegation {
    name = "databricks_delegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}



