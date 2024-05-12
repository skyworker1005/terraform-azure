

# terraform module 
terraform module 을 이용해서 Azure cloud 기반의 KDP(Korea Data Platform) 을 만들려고 한다. 
databricks 에서 adsl_gen2 에서 생성한 스토리지에 접근 및 processing 할 수 있도록 업데이트 해줘 

jmh-azure/main.tf
jmh-azure/variables.tf
jmh-azure/providers.tf

jmh-azure/network/main.tf  
jmh-azure/network/variables.tf 
jmh-azure/modules/network/nsg.tf
jmh-azure/modules/network/outputs.tf

jmh-azure/modules/databricks/databricks.tf
jmh-azure/modules/databricks/variables.tf

jmh-azure/modules/storage/adls_gen2/adls_gen2.tf
jmh-azure/modules/storage/adls_gen2/variables.tf


jmh-azure/modules/network/network.tf 코드는 아래와 같다. 
```
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-${var.vnet_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["${var.vnet_cidr}"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.prefix}-${var.subnet1_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet1_cidr]
  delegation {
    name = "databricks_delegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.prefix}-${var.subnet2_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet2_cidr]
  delegation {
    name = "databricks_delegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
```

jmh-azure/modules/network/outputs.tf 코드는 아래와 같다. 
```
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet1_id" {
  value = azurerm_subnet.subnet1.id
}

output "subnet2_id" {
  value = azurerm_subnet.subnet2.id
}


output "subnet1_name" {
  value = azurerm_subnet.subnet1.name
}

output "subnet2_name" {
  value = azurerm_subnet.subnet2.name
}


output "nsg_association1" {
  value = azurerm_subnet_network_security_group_association.nsg_association1.id
}

output "nsg_association2" {
  value = azurerm_subnet_network_security_group_association.nsg_association2.id
}

```



jmh-azure/modules/storage/adls_gen2/adls_gen2.tf 는 아래와 같다. 
```
resource "azurerm_resource_group" "rg" {
  #name     = var.rg_name
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  #name     = "${var.prefix}-${var.environment}-${var.storage_account_name}"
  name                = "${lower(var.prefix)}${lower(var.environment)}sa"

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name     = "${lower(var.prefix)}-${lower(var.environment)}-bronze"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on = [azurerm_storage_account.sa]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name     = "${lower(var.prefix)}-${lower(var.environment)}-silver"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on = [azurerm_storage_account.sa]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name     = "${lower(var.prefix)}-${lower(var.environment)}-gold"
  storage_account_id = azurerm_storage_account.sa.id
  depends_on = [azurerm_storage_account.sa]
}
```


현재 작성된 jmh-azure/modules/databricks/databricks.tf는 아래와 같다.
```

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

# modules/analytics/databricks.tf

resource "azurerm_databricks_workspace" "dbworkspace" {
  name                = "${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    Environment = var.environment
  }

  custom_parameters {
    no_public_ip = true
    public_subnet_network_security_group_association_id = var.nsg_association1
    private_subnet_network_security_group_association_id = var.nsg_association2
    virtual_network_id = var.vnet_id
    public_subnet_name = var.subnet1_name
    private_subnet_name = var.subnet2_name
  }
  depends_on = [
    var.nsg_association1, 
    var.nsg_association2
  ]  
}
```

jmh-azure/main.tf 코드는 아래와 같다. 
```


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
  # public_subnet_nsg_id = module.network.subnet1_id
  # private_subnet_nsg_id = module.network.subnet2_id
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
}
```

jmh-azure/outputs.tf 코드는 아래와 같다. 
```
variable "prefix" {
  type        = string
  default     = "KDP"
  description = "A prefix used to generate the names of the resources."
}

variable "location" {
  type        = string
  default     = "koreacentral"
  description = "The Azure region where the resources will be created."
}


variable "environment" {
  description = "Environment is development or production environment information."
  default     = "DEV"
}


variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default = "VNET"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default = "10.0.0.0/16"
}

variable "subnet1_name" {
  description = "The name of the first subnet."
  type        = string
  default = "PUBLIC"
}

variable "subnet1_cidr" {
  description = "CIDR block for the first subnet."
  type        = string
  default = "10.0.1.0/24"
}

variable "subnet2_name" {
  description = "The name of the second subnet."
  type        = string
  default = "PRIVATE"
}

variable "subnet2_cidr" {
  description = "CIDR block for the second subnet."
  type        = string
  default = "10.0.2.0/24"
}

```


jmh-azure/providers.tf 코드는 아래와 같다. 
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
  }
  
}



provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id   = "5f918871-6ae3-44a3-80dc-ba82deaf3190"
  tenant_id         = "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
  client_id         = "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
  client_secret     = "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY"
}

# remote state 
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "Korea Central"
}

resource "azurerm_storage_account" "tfstate" {
  #name                     = "tfstate${random_string.resource_code.result}"
  name                     = "tfstatesakdp"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment         = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
```

## 5/7 7:08
jmh-azure/modules/databricks/databricks.tf 에서 생성한 Databricks는 KDP-DEV-DATABRICKS 라는 리소스 그룹에 생성된다.
jmh-azure/modules/storage/adls_gen2/adls_gen2.tf 에서 생성한 azurerm_storage_account와 azurerm_storage_data_lake_gen2_filesystem 그리고 azurerm_role_assignment 는 KDP-DEV-STORAGE 라는 리소스 그룹에 생성된다.
그런데  jmh-azure/modules/storage/adls_gen2/adls_gen2.tf 에서 아래와 같이 azurerm_role_assignment을 생성할 때 고려할 것은 무엇인가?  
```
resource "azurerm_role_assignment" "databricks_sa_access" {
  principal_id        = var.databricks_workspace_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.sa.id
}
```

jmh-azure/providers.tf 소스 코드이다.  수정이 필요한 부분을 업데이트 해줘
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
  }
  
}



provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id   = "5f918871-6ae3-44a3-80dc-ba82deaf3190"
  tenant_id         = "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
  client_id         = "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
  client_secret     = "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY"
}

# remote state 
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "Korea Central"
}

resource "azurerm_storage_account" "tfstate" {
  #name                     = "tfstate${random_string.resource_code.result}"
  name                     = "tfstatesakdp"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment         = var.environment
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
```

### 이슈
#### User
아래 에러를 어떻게 해결해야 하나?  │ Error: authorization.RoleAssignmentsClient#Create: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailed" Message="The client 'f2bb46c6-b19e-4504-b5b2-ef896ef6f861' with object id 'f2bb46c6-b19e-4504-b5b2-ef896ef6f861' does not have authorization to perform action 'Microsoft.Authorization/roleAssignments/write' over scope '/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/resourceGroups/KDP-DEV-STORAGE/providers/Microsoft.Storage/storageAccounts/kdpdevsa/providers/Microsoft.Authorization/roleAssignments/63260411-e011-6d6a-5601-dbfc40476f52' or the scope is invalid. If access was recently granted, please refresh your credentials."
│ 
│   with module.adls_gen2.azurerm_role_assignment.databricks_sa_access,
│   on modules/storage/adls_gen2/adls_gen2.tf line 37, in resource "azurerm_role_assignment" "databricks_sa_access":
│   37: resource "azurerm_role_assignment" "databricks_sa_access" {
│ 
╵
#### GPT
이 에러는 서비스 주체에게 지정된 권한이 Microsoft.Authorization/roleAssignments/write 작업을 수행할 수 없다는 것을 나타냅니다. 이 문제를 해결하기 위해서는 Terraform에서 사용 중인 서비스 주체에 필요한 권한을 부여해야 합니다.

아래의 단계에 따라 문제를 해결할 수 있습니다:

1. 권한 확인
f2bb46c6-b19e-4504-b5b2-ef896ef6f861 객체 ID를 가진 서비스 주체가 적절한 역할(Role)을 갖고 있는지 확인합니다.
Contributor 또는 Owner 같은 상위 권한의 역할을 갖고 있거나, Role Assignment에 대해 쓰기 권한이 있는 커스텀 역할을 가지고 있어야 합니다.
2. 서비스 주체에 권한 부여
Azure CLI를 사용하여 서비스 주체에 권한을 부여할 수 있습니다.
Contributor 역할을 구독 범위에서 부여하려면 다음 명령을 실행합니다.
bash
Copy code
az role assignment create \
  --assignee "f2bb46c6-b19e-4504-b5b2-ef896ef6f861" \
  --role "Contributor" \
  --scope "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190"
특정 리소스 그룹이나 리소스에만 권한을 부여하려면 --scope 인자에 해당 리소스의 경로를 지정해야 합니다.
3. 역할 변경 적용
권한 부여가 완료된 후, 몇 분 동안 변경 사항이 적용될 때까지 기다립니다.
Terraform을 실행하는 시스템에서 Azure 인증 정보를 새로고침하거나 다시 로그인합니다.
4. 에러 해결 확인
Terraform을 다시 실행하여 문제가 해결되었는지 확인합니다.
이런 단계로 필요한 권한을 부여함으로써 해당 오류를 해결할 수 있습니다.

```
➜  jmh-azure git:(main) ✗ az role assignment create \
  --assignee "f2bb46c6-b19e-4504-b5b2-ef896ef6f861" \
  --role "Contributor" \
  --scope "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190"

{
  "condition": null,
  "conditionVersion": null,
  "createdBy": "64d465de-724d-4f46-9422-905578246b84",
  "createdOn": "2024-04-17T06:31:13.004505+00:00",
  "delegatedManagedIdentityResourceId": null,
  "description": null,
  "id": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/providers/Microsoft.Authorization/roleAssignments/bcdc9120-6f56-4559-86e4-717382daaa1b",
  "name": "bcdc9120-6f56-4559-86e4-717382daaa1b",
  "principalId": "f2bb46c6-b19e-4504-b5b2-ef896ef6f861",
  "principalName": "61c8285a-8bc7-4d60-a13d-f21e12d4b627",
  "principalType": "ServicePrincipal",
  "roleDefinitionId": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "roleDefinitionName": "Contributor",
  "scope": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190",
  "type": "Microsoft.Authorization/roleAssignments",
  "updatedBy": "64d465de-724d-4f46-9422-905578246b84",
  "updatedOn": "2024-04-17T06:31:13.004505+00:00"
}
➜  jmh-azure git:(main) ✗ 
```
