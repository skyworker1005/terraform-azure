module "databricks_workspace" {
  source = "./modules/databricks_workspace"
  providers = {
    azurerm   = azurerm
  }
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_name      = var.workspace_name
}

# module "databricks_token" {
#   source = "./modules/databricks_token"
#   providers = {
#     databricks = databricks.main
#   }
#   databricks_host = module.databricks_workspace.databricks_host
#   token_name      = var.token_name
#   token_lifetime_days = var.token_lifetime_days
# }

# module "databricks_cluster" {
#   source = "./modules/databricks_cluster"
#   providers = {
#     databricks = databricks.main
#   }
#   databricks_host = module.databricks_workspace.databricks_host
#   token           = module.databricks_token.token
#   cluster_name    = var.cluster_name
#   cluster_config  = var.cluster_config
# }
