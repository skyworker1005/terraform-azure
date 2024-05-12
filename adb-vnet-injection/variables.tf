variable "no_public_ip" {
  type        = bool
  default     = true
  description = "If Secure Cluster Connectivity (No Public IP) should be enabled. Default: true"
}

variable "azurerm_resource_group" {
  type        = string
  default     = "adb-poc-ws-rg"
}

variable "azurerm_virtual_network" {
  type        = string
  default     = "adb-poc-ws-vnet"
}

variable "azurerm_network_security_group" {
  type        = string
  default     = "adb-poc-ws-nsg"
}

variable "azurerm_subnet_public" {
  type        = string
  default     = "adb-poc-ws-sub-pub"
}

variable "azurerm_subnet_private" {
  type        = string
  default     = "adb-poc-ws-sub-pri"
}

variable "storage_account_name" {
  type        = string
  default     = "adbpocdbfsstorage"
}

variable "azurerm_storage_container" {
  type        = string
  default     = "adbpocucstorage-container"
}

variable "rglocation" {
  type        = string
  default     = "koreacentral"
  description = "Location of resource group to create"
}

variable "dbfs_prefix" {
  type        = string
  default     = "dbfs"
  description = "Name prefix for DBFS Root Storage account"
}

variable "workspace_prefix" {
  type        = string
  default     = "adb-poc"
  description = "Name prefix for Azure Databricks workspace"
}

variable "azurerm_databricks_workspace" {
  type        = string
  default     = "adb-poc-ws"
}

variable "cidr" {
  type        = string
  default     = "10.179.0.0/20"
  description = "Network range for created VNet"
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to add to resources"
  default     = {}
}

# UC
variable "shared_resource_group_name" {
  type        = string
  description = "Name of the shared resource group"
}

variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "metastore_storage_name" {
  type        = string
  description = "Name of the storage account for Unity Catalog metastore"
}

variable "access_connector_name" {
  type        = string
  description = "Name of the access connector for Unity Catalog metastore"
}

variable "metastore_name" {
  type        = string
  description = "the name of the metastore"
}
