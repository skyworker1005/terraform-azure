resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

output "rg" {
  value = azurerm_resource_group.rg
}

resource "azurerm_databricks_workspace" "dbworkspace" {
  name                = "${var.prefix}-${var.environment}-workspace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  tags = {
    Environment = var.environment
  }
  # public_network_access_enabled         = false                    //use private endpoint
  # network_security_group_rules_required = "NoAzureDatabricksRules" //use private endpoint
  # customer_managed_key_enabled          = false
  # infrastructure_encryption_enabled = true
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = var.nsg_association1
    private_subnet_network_security_group_association_id = var.nsg_association2
    #storage_account_name                                = var.dbfs_storage_account_name
    
    //enable_unity_catalog = true

  }
  depends_on = [
    var.nsg_association1, 
    var.nsg_association2
  ]
}

