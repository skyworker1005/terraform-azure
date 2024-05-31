
output "databricks_token_value" {
    value = databricks_token.this.token_value
    description = "The token value of the Databricks token."
    sensitive = true
}