

module "network" {
  source      = "./modules/network"
  prefix      = var.prefix
  location    = var.location
  environment = var.environment
  vnet_cidr = var.vnet_cidr
  vnet_name = var.vnet_name
  subnet1_cidr =var.subnet1_cidr
  subnet2_cidr = var.subnet2_cidr
}


# # jmh-azure/main.tf

module "databricks" {
  source              = "./modules/databricks"
  vnet_id = module.network.vnet_id
  subnet1_name = module.network.subnet1_name
  subnet2_name = module.network.subnet2_name
  nsg_association1 = module.network.nsg_association1
  nsg_association2 = module.network.nsg_association2
  prefix              = var.prefix
  location            = var.location
  environment         = var.environment
  sku                 = "premium"
}


module "adls_gen2" {
  source               = "./modules/storage/adls_gen2"
  prefix              = var.prefix
  location            = var.location
  environment         = var.environment
  
  storage_account_name = "mystorageaccount"
  filesystem_name      = "myfilesystem"
  tags                 = {
    environment         = var.environment
  }
  # Databricks 워크스페이스 ID 전달
  databricks_principal_id = var.databricks_principal_id
}


