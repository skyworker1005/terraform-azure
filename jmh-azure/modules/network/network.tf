resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-${var.vnet_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet_cidr]
}

# Public Subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.prefix}-${var.public_subnet_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.public_subnet_cidr]

  delegation {
    name = "databricks_delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# Private Subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.prefix}-${var.private_subnet_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.private_subnet_cidr]

  delegation {
    name = "databricks_delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}


# Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "${var.prefix}-${var.private_endpoint_subnet_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.private_endpoint_subnet_cidr]
}


# ADLS Subnet
resource "azurerm_subnet" "adls_subnet" {
  name                 = "${var.prefix}-${var.adls_subnet_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.adls_subnet_cidr]
}
