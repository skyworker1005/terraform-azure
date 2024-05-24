
vscode 프로젝트에 아래와 같은 폴더와 파일이 있다 

jmh-azure/main.tf
jmh-azure/variables.tf
jmh-azure/providers.tf
jmh-azure/terraform.tfvars

jmh-azure/network/main.tf  
jmh-azure/network/variables.tf 
jmh-azure/modules/network/nsg.tf
jmh-azure/modules/network/outputs.tf

jmh-azure/modules/databricks/databricks.tf
jmh-azure/modules/databricks/variables.tf
jmh-azure/modules/databricks/outputs.tf

jmh-azure/modules/storage/adls_gen2/adls_gen2.tf
jmh-azure/modules/storage/adls_gen2/variables.tf
jmh-azure/modules/storage/adls_gen2/outputs.tf

파일의 내용을 읽어서 아래와 같은 형식으로 result.txt 파일에 쓰는  python code 만들어줘 

- jmh-azure/providers.tf
```
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
  #name                     = "tfstate${random_string.resource_code.result}"
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
```

- jmh-azure/variables.tf
```
variable "prefix" {
  type        = string
  default     = "KDP"
  description = "A prefix used to generate the names of the resources."
}

variable "location" {
  type        = string
  default     = "koreacentral"
  description = "The Azure region where the resources will be created."
}

variable "environment" {
  description = "Environment is development or production environment information."
  default     = "DEV"
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "VNET"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_name" {
  description = "The name of the public subnet."
  type        = string
  default     = "PUBLIC"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_name" {
  description = "The name of the private subnet."
  type        = string
  default     = "PRIVATE"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoint_subnet_name" {
  description = "The name of the private endpoint subnet."
  type        = string
  default     = "PRIVATE_ENDPOINT"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet."
  type        = string
  default     = "10.0.3.0/24"
}

variable "adls_subnet_name" {
  description = "The name of the ADLS subnet."
  type        = string
  default     = "ADLS"
}

variable "adls_subnet_cidr" {
  description = "CIDR block for the ADLS subnet."
  type        = string
  default     = "10.0.4.0/24"
}

variable "databricks_principal_id" {
  description = "databricks_principal_id"
  type        = string
  default     = "48e1c7f2-9858-407d-983c-11dea10e78f4"
}

```