output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoint_subnet.id
}

output "adls_subnet_id" {
  value = azurerm_subnet.adls_subnet.id
}

output "nsg_association_public_subnet" {
  value = azurerm_subnet_network_security_group_association.nsg_association_public_subnet.id
}

output "nsg_association_private_subnet" {
  value = azurerm_subnet_network_security_group_association.nsg_association_private_subnet.id
}

output "public_subnet_name" {
  value = azurerm_subnet.public_subnet.name
}

output "private_subnet_name" {
  value = azurerm_subnet.private_subnet.name
}

output "private_endpoint_subnet_name" {
  value = azurerm_subnet.private_endpoint_subnet.name
}

output "adls_subnet_name" {
  value = azurerm_subnet.adls_subnet.name
}