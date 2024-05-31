# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~>3.0"
#     }
#     databricks = {
#       source  = "databricks/databricks"
#       version = "~>1.0.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

# provider "databricks" {
#   alias = "main"
#   //host  = "https://${var.databricks_workspace_name}.azuredatabricks.net"
#   host = azurerm_databricks_workspace.this.workspace_url
#   //token = var.databricks_pat_token
# }


resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_databricks_workspace" "dbworkspace" {
  name                = "${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  tags = {
    Environment = var.environment
  }
  custom_parameters {
    no_public_ip                                         = true
    public_subnet_network_security_group_association_id  = var.nsg_association1
    private_subnet_network_security_group_association_id = var.nsg_association2
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name

  }
  depends_on = [
    var.nsg_association1, 
    var.nsg_association2
  ]
}

resource "azurerm_private_endpoint" "databricks_control_plane" {
  name                = "${var.prefix}-control-plane-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = "${var.prefix}-control-plane-psc"
    private_connection_resource_id = azurerm_databricks_workspace.dbworkspace.id
    subresource_names              = ["databricks_ui_api"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "databricks_zone" {
  name                = "privatelink.databricks.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks_dns_link" {
  name                  = "${var.prefix}-dns-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.databricks_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "databricks_a_record" {
  name                = "adb-${azurerm_databricks_workspace.dbworkspace.workspace_id}"
  zone_name           = azurerm_private_dns_zone.databricks_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.databricks_control_plane.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_endpoint" "databricks_compute_plane" {
  name                = "${var.prefix}-compute-plane-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = "${var.prefix}-compute-plane-psc"
    private_connection_resource_id = azurerm_databricks_workspace.dbworkspace.id
    subresource_names              = ["databricks_ui_api"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "databricks_compute_a_record" {
  name                = "adb-compute-${azurerm_databricks_workspace.dbworkspace.workspace_id}"
  zone_name           = azurerm_private_dns_zone.databricks_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.databricks_compute_plane.private_service_connection[0].private_ip_address]
}



# resource "databricks_token" "this" {
#   provider = databricks.main
#   comment  = "Terraform managed token"
#   lifetime_seconds = 31536000
# }

# resource "databricks_cluster" "example_cluster" {
#   provider = databricks.main
#   cluster_name            = "example-cluster"
#   spark_version           = "7.3.x-scala2.12"
#   node_type_id            = "Standard_D3_v2"
#   autotermination_minutes = 20
#   num_workers             = 2
# }



// to-do 
/*
azurerm_databricks_access_connector는 Terraform에서 Azure Databricks와 Azure Active Directory(AD)를 통합하여 Databricks 자원에 대한 접근 관리를 간소화하는 리소스
이를 통해 Azure AD를 사용하여 Databricks 작업공간 및 자원에 대한 사용자의 접근과 권한을 관리할 수 있음 
주요 특징
- Azure AD 통합: Azure AD를 사용하여 Databricks에 대한 인증 및 인가를 관리할 수 있습니다.
- 향상된 보안: Azure의 보안 기능을 활용하여 Databricks 자원을 안전하게 보호할 수 있습니다.
- 간편한 접근 관리: Databricks 작업공간 및 자원에 대한 접근 관리를 간편하게 수행할 수 있습니다.

*/
/*
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_databricks_workspace" "example" {
  name                = "example-databricks"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
}

resource "azurerm_databricks_access_connector" "example" {
  name                    = "example-connector"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  databricks_workspace_id = azurerm_databricks_workspace.example.id
}

output "databricks_access_connector_id" {
  value = azurerm_databricks_access_connector.example.id
}

*/