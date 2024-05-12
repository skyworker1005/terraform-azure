# Azure
dbfs_prefix = "adbpocdbfs"
cidr        = "10.179.0.0/20"
rglocation = "koreacentral"
azurerm_resource_group = "adb-poc-ws-rg"
azurerm_virtual_network = "adb-poc-ws-vnet"
azurerm_network_security_group = "adb-poc-ws-nsg"
azurerm_subnet_public = "adb-poc-ws-sub-pub"
azurerm_subnet_private = "adb-poc-ws-sub-pri"
storage_account_name = "adbpocdbfsstorage"

# Databricks
workspace_prefix = "adb-poc"
azurerm_databricks_workspace = "adb-poc-ws"

# UC
shared_resource_group_name = "adb-poc-uc-rg"
location = "koreacentral"
metastore_storage_name = "adbpocucstorage" # 글로벌 고유값으로 변경
azurerm_storage_container = "adbpocucstorage-container" # 원하는 컨테이너 이름으로 변경
access_connector_name = "adb-uc-acc-con"
metastore_name = "adb-uc-meta-store"
tags = {
        Owner = "adb-poc-user",
        Name = "adb-poc-user"
    }