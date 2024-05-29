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

variable "databricks_token" {
  description = "Databricks token for authentication"
  type        = string
}

variable "databricks_host" {
  description = "Databricks token for authentication"
  type        = string
  default = "https://adb-4425577002104615.15.azuredatabricks.net"
}





variable "token_name" {
  description = "A prefix used to name the resources."
  type        = string
  default     = "kdptoken"
}

variable "token_lifetime_days" {
  description = "The resource group name suffix."
  type        = string
  default     = "2"
}


variable "access_connector_name" {
  description = "The resource group name suffix."
  type        = string
  default     = "2"
}


variable "metastore_storage_name" {
  description = "The resource group name suffix."
  type        = string
  default     = "2"
}

variable "azurerm_storage_container" {
  description = "The resource group name suffix."
  type        = string
  default     = "2"
}


