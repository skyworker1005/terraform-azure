output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet1_id" {
  value = azurerm_subnet.subnet1.id
}

output "subnet2_id" {
  value = azurerm_subnet.subnet2.id
}


output "subnet1_name" {
  value = azurerm_subnet.subnet1.name
}

output "subnet2_name" {
  value = azurerm_subnet.subnet2.name
}


output "nsg_association1" {
  value = azurerm_subnet_network_security_group_association.nsg_association1.id
}

output "nsg_association2" {
  value = azurerm_subnet_network_security_group_association.nsg_association2.id
}
