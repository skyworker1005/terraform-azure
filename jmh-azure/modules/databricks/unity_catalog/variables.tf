variable "unity_catalog_storage_account_name" {
  description = "The name of the storage account for Unity Catalog."
  type        = string
}

variable "unity_catalog_storage_container_name" {
  description = "The name of the storage container for Unity Catalog."
  type        = string
}

variable "unity_catalog_metastore_name" {
  description = "The name of the metastore for Unity Catalog."
  type        = string
}

variable "unity_catalog_name" {
  description = "The name of the Unity Catalog."
  type        = string
}

# variable "databricks_account_id" {
#   description = "The account ID of the Databricks workspace."
#   type        = string
# }


variable "databricks_token" {
    description = "The Databricks token"
    type        = string
    default     = "module.kdp_databricks_token.databricks_token_value"
}

variable "databricks_host" {
    description = "The Databricks host"
    type        = string
}



# variable "metastore_storage_name" {
#     description = "metastore_storage_name"
#     type        = string
# }

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

