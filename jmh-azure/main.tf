module "network" {
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

module "databricks" {
  source                   = "./modules/databricks"
  vnet_id                  = module.network.vnet_id
  public_subnet_id         = module.network.public_subnet_id
  private_subnet_id        = module.network.private_subnet_id
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  public_subnet_name       = module.network.public_subnet_name
  private_subnet_name      = module.network.private_subnet_name
  nsg_association1         = module.network.nsg_association_public_subnet
  nsg_association2         = module.network.nsg_association_private_subnet
  prefix                   = var.prefix
  location                 = var.location
  environment              = var.environment
  sku                      = "premium"
}




module "adls_gen2" {
  source                    = "./modules/storage/adls_gen2"
  prefix                    = var.prefix
  location                  = var.location
  environment               = var.environment
  storage_account_name      = "mystorageaccount"
  filesystem_name           = "myfilesystem"
  tags                      = {
    environment = var.environment
  }
  vnet_id                   = module.network.vnet_id
  private_subnet_id         = module.network.adls_subnet_id
  databricks_principal_id   = var.databricks_principal_id
}
