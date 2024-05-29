variable "databricks_host" {
  description = "The Databricks host URL"
  type        = string
}

variable "token_name" {
  description = "The name of the Databricks token"
  type        = string
}

variable "token_lifetime_days" {
  description = "The lifetime of the token in days"
  type        = number
}
