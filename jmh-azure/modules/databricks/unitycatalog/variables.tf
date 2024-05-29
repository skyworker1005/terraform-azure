
variable "resource_group_name" {
  description = "The name of the resource group in which to create the Databricks Workspace"
  type        = string
}

variable "location" {
  description = "The location/region in which to create the Databricks Workspace"
  type        = string
}

variable "databricks_workspace_name" {
  description = "The name of the Databricks Workspace"
  type        = string
}

variable "unity_catalog_name" {
  description = "The name of the Unity Catalog"
  type        = string
}