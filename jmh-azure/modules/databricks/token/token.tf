terraform {
    required_providers {
        databricks = {
            source = "databricks/databricks"
            // ...
        }
    }
}



# resource "databricks_token" "this" {
#     comment = "Managed by Terraform"
#     lifetime_seconds = 3600
# }

resource "databricks_token" "token" {
  
  comment          = var.token_name
  lifetime_seconds = var.token_lifetime_days * 24 * 60 * 60
}
