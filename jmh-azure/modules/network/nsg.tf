

# resource "azurerm_network_security_group" "kdp" {
#   name                = "${var.prefix}-nsg"
#   location            = azurerm_resource_group.kdp.location
#   resource_group_name = azurerm_resource_group.kdp.name
# }


# resource "azurerm_network_security_rule" "kdp" {
#   name                        = "${var.prefix}-nsgrule"
#   network_security_group_name = azurerm_network_security_group.kdp.name
#   resource_group_name         = azurerm_resource_group.kdp.name
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "Internet"  # 수정된 부분
# }

# resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg_association" {
#   subnet_id                 = azurerm_subnet.public.id
#   network_security_group_id = azurerm_network_security_group.kdp.id
# }



# NSG for Subnet 1
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG to Subnet 1
resource "azurerm_subnet_network_security_group_association" "nsg_association1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_security_rule" "inbound_http" {
  name                        = "${var.prefix}-allow-http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg1.name
  resource_group_name         = azurerm_network_security_group.nsg1.resource_group_name
}

resource "azurerm_network_security_rule" "inbound_https" {
  name                        = "${var.prefix}-allow-https"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"  
  network_security_group_name = azurerm_network_security_group.nsg1.name
  resource_group_name         = azurerm_network_security_group.nsg1.resource_group_name
}


# NSG for Subnet 2
resource "azurerm_network_security_group" "nsg2" {
  name                = "${var.prefix}-nsg2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG to Subnet 2
resource "azurerm_subnet_network_security_group_association" "nsg_association2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

resource "azurerm_network_security_rule" "subnet2_allow_http_from_subnet1" {
  name                        = "${var.prefix}-allow-http-from-subnet1"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = azurerm_subnet.subnet1.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}

resource "azurerm_network_security_rule" "subnet2_allow_https_from_subnet1" {
  name                        = "${var.prefix}-allow-https-from-subnet1"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = azurerm_subnet.subnet1.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}

resource "azurerm_network_security_rule" "subnet2_allow_all_to_subnet1" {
  name                        = "${var.prefix}-allow-all-to-subnet1"
  priority                    = 210
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.subnet2.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.subnet1.address_prefixes[0]
  network_security_group_name = azurerm_network_security_group.nsg2.name
  resource_group_name         = azurerm_network_security_group.nsg2.resource_group_name
}

