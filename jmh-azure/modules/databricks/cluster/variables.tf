/*
    cluster_name = "my-cluster"
    spark_version = "7.3.x-scala2.12"
    node_type_id = "Standard_DS3_v2"
    autotermination_minutes = 20
    databricks_token = module.kdp_databricks_token.databricks_token_value
*/

variable "cluster_name" {
    description = "The name of the cluster"
    type        = string
    default     = "my-cluster"
}

variable "spark_version" {
    description = "The version of Spark to use"
    type        = string
    default     = "7.3.x-scala2.12"
}

variable "node_type_id" {
    description = "The node type id"
    type        = string
    default     = "Standard_DS3_v2"
}

variable "autotermination_minutes" {
    description = "The autotermination minutes"
    type        = number
    default     = 20
}

variable "databricks_token" {
    description = "The Databricks token"
    type        = string
    default     = "module.kdp_databricks_token.databricks_token_value"
}