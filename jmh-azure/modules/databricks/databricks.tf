resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_databricks_workspace" "dbworkspace" {
  name                = "${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags = {
    Environment = var.environment
  }
  custom_parameters {
    no_public_ip = true
    public_subnet_network_security_group_association_id = var.nsg_association1
    private_subnet_network_security_group_association_id = var.nsg_association2
    virtual_network_id = var.vnet_id
    public_subnet_name = var.subnet1_name
    private_subnet_name = var.subnet2_name
  }
  depends_on = [
    var.nsg_association1, 
    var.nsg_association2
  ]  
}

