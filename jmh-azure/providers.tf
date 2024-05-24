terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id   = "5f918871-6ae3-44a3-80dc-ba82deaf3190"
  tenant_id         = "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
  client_id         = "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
  client_secret     = "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY"
}

provider "databricks" {
  alias = "main"
  host  = azurerm_databricks_workspace.dbworkspace.workspace_url
  token = var.databricks_token
}

# remote state
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "Korea Central"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatesakdp"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment         = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
