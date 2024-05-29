variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location where the Databricks workspace will be created"
  type        = string
}

variable "workspace_name" {
  description = "The name of the Databricks workspace"
  type        = string
}
