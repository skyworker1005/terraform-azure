
module "kdp_network" {
  source      = "./modules/network"
  prefix      = var.prefix
  location    = var.location
  environment = var.environment
  vnet_cidr   = var.vnet_cidr
  vnet_name   = var.vnet_name
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
  adls_subnet_cidr = var.adls_subnet_cidr
}

// storage_account_name, filesystem_name 은 prefix, environment 등과 함께 조합하여 생성되고 있음. 차후 필요하면 사용하는 걸로 변경 예정
module "kdp_adls_gen2" {
  source                    = "./modules/storage/adls_gen2"
  prefix                    = var.prefix
  location                  = var.location
  environment               = var.environment
  # storage_account_name      = "mystorageaccount"
  # filesystem_name           = "myfilesystem"
  tags                      = {
    environment = var.environment
  }
  vnet_id                   = module.kdp_network.vnet_id
  private_subnet_id         = module.kdp_network.adls_subnet_id
  databricks_principal_id   = var.databricks_principal_id
  access_connector_name     = var.access_connector_name
  azurerm_storage_container = var.azurerm_storage_container
  metastore_storage_name   = var.metastore_storage_name
}

module "kdp_databricks_workspace" {
  source                   = "./modules/databricks/workspace"
  vnet_id                  = module.kdp_network.vnet_id
  public_subnet_id         = module.kdp_network.public_subnet_id
  private_subnet_id        = module.kdp_network.private_subnet_id
  private_endpoint_subnet_id = module.kdp_network.private_endpoint_subnet_id
  public_subnet_name       = module.kdp_network.public_subnet_name
  private_subnet_name      = module.kdp_network.private_subnet_name
  nsg_association1         = module.kdp_network.nsg_association_public_subnet
  nsg_association2         = module.kdp_network.nsg_association_private_subnet
  prefix                   = var.prefix
  location                 = var.location
  environment              = var.environment
  rg_name                  = var.databricks_rg_name
  sku                      = "premium"
}

# Ensure the databricks_token module runs after kdp_databricks_workspace
resource "null_resource" "databricks_token_dependency" {
  depends_on = [module.kdp_databricks_workspace]
}

module "kdp_databricks_token" {
  source                   = "./modules/databricks/token"
  databricks_host          = module.kdp_databricks_workspace.databricks_host
}

module "databricks_cluster" {
    source = "./modules/databricks/cluster"

    cluster_name = "my-cluster"
    spark_version = "7.3.x-scala2.12"
    node_type_id = "Standard_DS3_v2"
    autotermination_minutes = 20
    #databricks_token = module.kdp_databricks_token.databricks_token_value
    databricks_token = module.kdp_databricks_token.databricks_token_value
    databricks_host          = module.kdp_databricks_workspace.databricks_host
}

# module "unity_catalog" {
#   source                   = "./modules/databricks/unity_catalog"
#   location                 = var.location

#   //databricks_workspace_id  = module.databricks_workspace.databricks_workspace_id
#     databricks_token = module.kdp_databricks_token.databricks_token_value
#     databricks_host          = module.kdp_databricks_workspace.databricks_host

#   unity_catalog_metastore_name = var.unity_catalog_metastore_name
#   unity_catalog_storage_account_name = module.kdp_adls_gen2.unity_catalog_storage_account_name
#   unity_catalog_storage_container_name = module.kdp_adls_gen2.unity_catalog_storage_container_name
#   unity_catalog_name            = var.unity_catalog_name
# }