variable "databricks_host" {
  description = "The Databricks host URL"
  type        = string
}

variable "token" {
  description = "The Databricks token"
  type        = string
}

variable "cluster_name" {
  description = "The name of the Databricks cluster"
  type        = string
}

variable "cluster_config" {
  description = "Configuration for the Databricks cluster"
  type        = map(any)
}
