terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      configuration_aliases = [databricks.main]
    }
  }
}


provider "databricks" {
  alias = "main"
}

resource "databricks_token" "token" {
  lifecycle {
    ignore_changes = [created, expiry]
  }
  
  comment    = var.token_name
  lifetime_seconds = var.token_lifetime_days * 24 * 60 * 60
}

output "token" {
  value = databricks_token.token.token_value
}
