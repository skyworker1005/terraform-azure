terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  alias = "main"
  host  = azurerm_databricks_workspace.dbworkspace.workspace_url
  token = var.databricks_token
}

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

resource "databricks_token" "token" {
  provider = databricks.main
  lifetime_seconds = 600
  comment          = "Terraform generated token"
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

resource "databricks_cluster" "example_cluster" {
  provider            = databricks.main
  cluster_name        = "${var.prefix}-${var.environment}-cluster"
  spark_version       = "7.3.x-scala2.12"
  node_type_id        = "Standard_DS3_v2"
  autotermination_minutes = 30
  autoscale {
    min_workers = 1
    max_workers = 3
  }
}
