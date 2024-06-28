
# output "databricks_host" {
#   #value = azurerm_databricks_workspace.dbworkspace.workspace_url
#   value = module.kdp_databricks_workspace.databricks_host
# }


# output "databricks_token_value" {
#     value = module.kdp_databricks_token.databricks_token_value
#     sensitive = true
# }

output "kdp_network_resource_group_name" {
  value = module.kdp_network.network_resource_group_name
  
}

output "storage_resource_group_name" {
   value = module.kdp_adls_gen2.storage_resource_group_name
 }
# output "databricks_workspace_resource_group_name" {
#   value = module.kdp_databricks_workspace.databricks_workspace_resource_group_name
# }

output "print_dbfs_storage_account_name" {
  value = module.kdp_adls_gen2.dbfs_storage_account_name
}


output "print2_dbfs_storage_account_name" {
  value = module.kdp_adls_gen2.dbfs_storage_account_name
}
# output "kdp_databricks_workspace" {
#     value = module.kdp_databricks_workspace.
# }

output "databricks_workspace_resource_group_name" {
  value = module.kdp_databricks_workspace.databricks_workspace_resource_group_name  
}

output "azurerm_databricks_workspace_rg_name" {
  value = module.kdp_databricks_workspace.azurerm_databricks_workspace_rg_name
  
}
output "databricks_workspace_url" {
  value = module.kdp_databricks_workspace.databricks_workspace_url
}