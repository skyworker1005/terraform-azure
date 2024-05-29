terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "5f918871-6ae3-44a3-80dc-ba82deaf3190"
  tenant_id       = "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
  client_id       = "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
  client_secret   = "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY"
}

provider "databricks" {
  alias   = "main"
}