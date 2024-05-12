terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.13.0"
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.azurerm_resource_group
  location = var.rglocation
  tags     = var.tags
}

locals {
  location = var.rglocation
  tags = merge({
    Environment = "azure-databricks-poc"
  }, var.tags)
}