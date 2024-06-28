prefix                       = "KDP"
location                     = "koreacentral"
environment                  = "DEV"

databricks_rg_name           = "DATABRICKS"

vnet_name                    = "VNET"
vnet_cidr                    = "10.0.0.0/16"
public_subnet_name           = "PUBLIC"
public_subnet_cidr           = "10.0.1.0/24"
private_subnet_name          = "PRIVATE"
private_subnet_cidr          = "10.0.2.0/24"
private_endpoint_subnet_name = "PRIVATE_ENDPOINT"
private_endpoint_subnet_cidr = "10.0.3.0/24"
# adls_subnet_name             = "ADLS"
# adls_subnet_cidr             = "10.0.4.0/24"


# .zshrc 에 설정 
# databricks_token & databricks_host 2개 변수는 databricks workspace 생성 후에 확인 가능
#databricks_principal_id      = "48e1c7f2-9858-407d-983c-11dea10e78f4"
#databricks_token             = "dapid008aa048c0329e526c38b41a56eac16"
#databricks_host              = "https://adb-846561466085427.7.azuredatabricks.net"


access_connector_name        = "KDP-ADLS-AC"
metastore_storage_name       = "kdpmetastore"
azurerm_storage_container    = "kdpcatalog"
dbfs_storage_account_name    = "kdpdbfs"

unity_catalog_name = "kdpunitycatalog"
unity_catalog_metastore_name = "kdpunitycatalogmetastore"