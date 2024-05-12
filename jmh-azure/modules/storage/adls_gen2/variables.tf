
variable "prefix" {
  description = "A prefix used to name the resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., DEV, STG, PRD)."
  type        = string
  default = "DEV"
}

variable "rg_name" {
  description = "The resource group name suffix."
  type        = string
  default = "STORAGE"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}


variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create."
}

variable "filesystem_name" {
  type        = string
  description = "The name of the filesystem to create in the storage account."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# variable "databricks_workspace_id" {
#   description = "The ID of the Databricks workspace that will access the ADLS Gen2 storage."
#   type        = string
# }

# variable "databricks_workspace_managed_identity_id" {
#   description = "The managed identity of the Databricks workspace that will access the ADLS Gen2 storage."
#   type        = string
# }

variable "databricks_principal_id" {
  description = "databricks_principal_id"
  type        = string
}
