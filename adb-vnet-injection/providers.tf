provider "azurerm" {
  features {}
}

provider "databricks" {
  host = azurerm_databricks_workspace.example.workspace_url
}
