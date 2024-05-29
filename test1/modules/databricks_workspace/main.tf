terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"
}

output "databricks_host" {
  value = azurerm_databricks_workspace.workspace.workspace_url
}
