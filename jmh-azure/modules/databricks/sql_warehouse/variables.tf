variable "databricks_host" {
  description = "The Databricks host URL"
  type        = string
}

variable "databricks_token" {
  description = "Databricks token for authentication"
  type        = string
}

variable "sql_warehouse_name" {
  description = "The name of the SQL warehouse"
  type        = string
  default     = "my-sql-warehouse"
}

variable "cluster_size" {
  description = "The size of the cluster"
  type        = string
  default     = "Small"
}

variable "max_num_clusters" {
  description = "The maximum number of clusters"
  type        = number
  default     = 1
}

variable "auto_stop_mins" {
  description = "The number of minutes of inactivity before auto-stopping the cluster"
  type        = number
  default     = 30
}

variable "min_num_clusters" {
  description = "The minimum number of clusters"
  type        = number
  default     = 1
}

variable "enable_photon" {
  description = "Enable Photon for the SQL warehouse"
  type        = bool
  default     = true
}

variable "spot_instance_policy" {
  description = "Spot instance policy"
  type        = string
  default     = "COST_OPTIMIZED"
}

variable "tags" {
  description = "Tags to apply to the SQL warehouse"
  type        = map(string)
  default     = {}
}
