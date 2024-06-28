# resource "random_string" "unique" {
#   length  = 6
#   special = false
# }

# module "kdp_network" {
#   source      = "../../modules/network/hub"
#   prefix      = var.prefix
#   location    = var.location
#   environment = var.environment
#   vnet_cidr   = var.vnet_cidr
#   vnet_name   = var.vnet_name
#   public_subnet_cidr = var.public_subnet_cidr
#   private_subnet_cidr = var.private_subnet_cidr
#   private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
  
# }
