# NSG for Public Subnet
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG to Public Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association_public_subnet" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

# NSG for Private Subnet
resource "azurerm_network_security_group" "nsg2" {
  name                = "${var.prefix}-nsg2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG to Private Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association_private_subnet" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

resource "azurerm_network_security_rule" "subnet2_allow_http_from_subnet1" {
  name                        = "${var.prefix}-allow-http-from-public"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = azurerm_subnet.public_subnet.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.private_subnet.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}

resource "azurerm_network_security_rule" "subnet2_allow_https_from_subnet1" {
  name                        = "${var.prefix}-allow-https-from-public"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = azurerm_subnet.public_subnet.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.private_subnet.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}

resource "azurerm_network_security_rule" "subnet2_allow_all_to_subnet1" {
  name                        = "${var.prefix}-allow-all-to-public"
  priority                    = 220
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.private_subnet.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.public_subnet.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}
