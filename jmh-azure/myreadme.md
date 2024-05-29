
# Azure에 Terraform 인증
https://learn.microsoft.com/ko-kr/azure/developer/terraform/authenticate-to-azure?tabs=bash

## Microsoft 계정을 통해 Azure에 인증
- az login 
```
az login
az account show
```

* 실행 로그 
```
➜  jmh-azure az account show
{
  "environmentName": "AzureCloud",
  "homeTenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
  "id": "5f918871-6ae3-44a3-80dc-ba82deaf3190",
  "isDefault": true,
  "managedByTenants": [],
  "name": "KDP-DEV",
  "state": "Enabled",
  "tenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
  "user": {
    "name": "jmh1005@gmail.com",
    "type": "user"
  }
}
➜  jmh-azure git:(main) az account list
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "id": "9933b71b-14bf-4fec-a1ce-da880d531131",
    "isDefault": false,
    "managedByTenants": [],
    "name": "IT-subscription",
    "state": "Enabled",
    "tenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "user": {
      "name": "jmh1005@gmail.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "id": "810248c2-2190-43d9-a3ac-440f6e673ec9",
    "isDefault": false,
    "managedByTenants": [],
    "name": "라이나생명",
    "state": "Enabled",
    "tenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "user": {
      "name": "jmh1005@gmail.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "id": "7f6feb61-efa1-489d-9815-858042fad227",
    "isDefault": false,
    "managedByTenants": [],
    "name": "KDP-PRD",
    "state": "Enabled",
    "tenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "user": {
      "name": "jmh1005@gmail.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "id": "5f918871-6ae3-44a3-80dc-ba82deaf3190",
    "isDefault": true,
    "managedByTenants": [],
    "name": "KDP-DEV",
    "state": "Enabled",
    "tenantId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "user": {
      "name": "jmh1005@gmail.com",
      "type": "user"
    }
  }
]
➜  jmh-azure git:(main) 
```

- 특정 Azure 구독을 사용하려면 az account set를 실행
```
az account set --subscription "<subscription_id_or_subscription_name>"
```
* 실행로그 
```
az account set --subscription 5f918871-6ae3-44a3-80dc-ba82deaf3190
```


## 서비스 주체(service principal) 만들기
1. 서비스 주체 생성하기
- Terraform과 같은 Azure 서비스를 배포하거나 사용하는 자동화된 도구에는 항상 제한된 권한이 있어야 합니다. 애플리케이션이 완전한 권한이 있는 사용자로 로그인하는 대신 Azure는 서비스 주체를 제공합니다.
- 이 명령은 서비스 주체를 생성하고, appId, displayName, password, tenant 등의 정보를 반환합니다. 여기서:
  - appId는 client_id에 해당합니다.
  - password는 client_secret에 해당합니다.
```
az ad sp create-for-rbac --name [YOUR-SP-NAME] --role Contributor --scopes /subscriptions/[YOUR-SUBSCRIPTION-ID]
```
* 실행로그 *
```
➜  jmh-azure git:(main) ✗ az ad sp create-for-rbac --name kdp-terraform --role Contributor --scopes /subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190
Creating 'Contributor' role assignment under scope '/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "61c8285a-8bc7-4d60-a13d-f21e12d4b627",
  "displayName": "kdp-terraform",
  "password": "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY",
  "tenant": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
}
➜  jmh-azure git:(main) ✗ 
```

2. 기존 서비스 주체 확인하기
만약 서비스 주체가 이미 생성되어 있고, 해당 정보를 확인하고자 한다면 다음 명령을 사용할 수 있습니다.
```
az ad sp list --display-name [YOUR-SP-NAME]
```
* 실행로그 
```
 jmh-azure git:(main) ✗ az ad sp list --display-name kdp-terraform
[
  {
    "accountEnabled": true,
    "addIns": [],
    "alternativeNames": [],
    "appDescription": null,
    "appDisplayName": "kdp-terraform",
    "appId": "61c8285a-8bc7-4d60-a13d-f21e12d4b627",
    "appOwnerOrganizationId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
    "appRoleAssignmentRequired": false,
    "appRoles": [],
    "applicationTemplateId": null,
    "createdDateTime": "2024-04-17T06:31:10Z",
    "deletedDateTime": null,
    "description": null,
    "disabledByMicrosoftStatus": null,
    "displayName": "kdp-terraform",
    "homepage": null,
    "id": "f2bb46c6-b19e-4504-b5b2-ef896ef6f861",
    "info": {
      "logoUrl": null,
      "marketingUrl": null,
      "privacyStatementUrl": null,
      "supportUrl": null,
      "termsOfServiceUrl": null
    },
    "keyCredentials": [],
    "loginUrl": null,
    "logoutUrl": null,
    "notes": null,
    "notificationEmailAddresses": [],
    "oauth2PermissionScopes": [],
    "passwordCredentials": [],
    "preferredSingleSignOnMode": null,
    "preferredTokenSigningKeyThumbprint": null,
    "replyUrls": [],
    "resourceSpecificApplicationPermissions": [],
    "samlSingleSignOnSettings": null,
    "servicePrincipalNames": [
      "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
    ],
    "servicePrincipalType": "Application",
    "signInAudience": "AzureADMyOrg",
    "tags": [],
    "tokenEncryptionKeyId": null,
    "verifiedPublisher": {
      "addedDateTime": null,
      "displayName": null,
      "verifiedPublisherId": null
    }
  }
]
➜  jmh-azure git:(main) ✗ 
```
3. 주의 사항
서비스 주체와 관련된 정보, 특히 client_secret은 매우 민감한 정보이므로 안전하게 보관하고, 코드나 공개 저장소에 직접적으로 포함시키지 않아야 합니다.
서비스 주체에 부여된 역할(Role)에 따라 리소스에 대한 권한이 결정됩니다. Contributor 역할은 리소스를 관리할 수 있는 충분한 권한을 부여하지만, 필요에 따라 더 제한적인 역할을 설정할 수 있습니다.
이러한 단계를 통해 Azure에서 서비스 주체의 client_id와 client_secret을 생성하고 관리할 수 있습니다.









## Terraform 공급자 블록에서 서비스 주체 자격 증명 지정
```
provider "azurerm" {
  features {}

  subscription_id   = "5f918871-6ae3-44a3-80dc-ba82deaf3190"
  tenant_id         = "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
  client_id         = "61c8285a-8bc7-4d60-a13d-f21e12d4b627"
  client_secret     = "qjJ8Q~tHgsWx39O2ClSSsHMgOIgCG3FUp32cdcEY"
}
```


# Azure Storage에 Terraform 상태 저장
https://learn.microsoft.com/ko-kr/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli


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



jmh-azure/modules/storage/adls2.tf 코드는 아래와 같다. 

resource "azurerm_resource_group" "kdp" {
  name     = "${var.prefix}-${var.environment}-STORAGE"
  location = var.location
}


resource "azurerm_storage_account" "example" {
  name                = "${var.prefix}"
  resource_group_name = azurerm_resource_group.kdp.name
  location            = azurerm_resource_group.kdp.location
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
  is_hns_enabled           = "${var.is_hns_enabled}"  # Hierarchical Namespace를 활성화하여 Data Lake Storage Gen2로 만듭니다.

  tags = {
    Environment = "${var.environment}"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "kdp" {
  name                = "${var.prefix}"
  storage_account_id = azurerm_storage_account.kdp.id
}


jmh-azure/modules/analytics/variables.tf 코드는 아래와 같다. 
```
variable "location" {
  description = "The Azure location where all resources in this example should be created"
}

variable "environment" {
  description = "Environment is DEV(development) or PRD(production) environment information."
}

validation {
  condition = length(var.environment) <= 3
  error_message = "Err: Environment cannot be longer than three characters."
}

variable "prefix" {
  description = "The prefix used for all resources in this example"
}

variable "sku" {
  description = "The prefix used for all resources in this example"
}
```


jmh-azure/network/main.tf 에 아래와 같이 코딩되어 있다. 
network 모듈에서 생성된 azurerm_virtual_network와 azurerm_subnet 정보를 databircks 모듈에서 사용해야 한다. 


module "network" {
  source      = "./modules/network"
  prefix      = var.prefix
  location    = var.location
  environment = var.environment
  vnet_cidr = "10.0.0.0/16"
  public_cidr = "10.0.1.0/24"
  private_cidr = "10.0.2.0/24"
}


module "databricks" {
  source              = "./modules/analytics"
  custom_virtual_network_id = module.network.virtual_network_id
  public_subnet_id     = module.network.public_subnet_id
  private_subnet_id    = module.network.private_subnet_id
  prefix      = var.prefix
  location    = var.location
  environment = var.environment
  sku         = "premium"
}

jmh-azure/main.tf 에 정의된 코드는 맞는건가?
아래 databricks module 에서는 azurerm_virtual_network와 azurerm_subnet 정보를 어떻게 사용하는건가?
jmh-azure/modules/analytics/databricks.tf







# databricks 코드 생성 
아래와 같은 구조로 azure resource를 생성하는 terraform 코드를 만들려고 한다.
각 모듈별로 resouce group을 만들고, network 모듈에는 vnet, public/private subnet, netazurerm_network_security_group 을 만들고, analytics 모듈에도 별도의 resource group을 만들고 databricks 리소스를 생성하려고 한다.
그런데 databricks에서 사용하는 network 정보는 network 모듈에서 만든 vnet, public/private subnet 정보가 필요하다. 
이와 같은 terraform 코드를 만들어줘 

jmh-azure/main.tf
jmh-azure/variables.tf
jmh-azure/providers.tf

jmh-azure/network/main.tf  
jmh-azure/network/variables.tf 
jmh-azure/network/nsg.tf
jmh-azure/network/outputs.tf

jmh-azure/analytics/adls.tf
jmh-azure/analytics/databricks.tf
jmh-azure/analytics/variables.tf


## 5/7(Tue)
jmh-azure/history/20240507-databricks.md

terraform module 을 이용해서 Azure cloud 기반의 KDP(Korea Data Platform) 을 만들려고 한다. 
databricks 에서 adsl_gen2 에서 생성한 스토리지에 접근 및 processing 할 수 있도록 업데이트 해줘 


terraform import azurerm_resource_group.tfstate /subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/resourceGroups/tfstate


--- 
## 5/10(Fri)


# 5/29
databricks configure --token
