
# Terraform module terraform module을 이용해서 azure databricks, adls gen2 을 만들때 Service Principal or AD 구성 관련 

## User
Terraform module terraform module을 이용해서 azure databricks, adls gen2 등의 리소스를 생성하고 있다.  databricks에서 adls gen2 스토리지에 데이터를 읽거나 쓰기 위해서 필요한게 뭔가?

## GPT
Databricks가 Azure Data Lake Storage (ADLS) Gen2에 액세스하여 데이터를 읽거나 쓰기 위해서는 몇 가지 중요한 구성이 필요합니다. 
Databricks와 ADLS Gen2 간의 통신을 설정하기 위한 주요 단계와 요구 사항은 다음과 같습니다.

1. Databricks Workspace 및 ADLS Gen2 준비
- Databricks Workspace를 이미 설정하고 있다면, ADLS Gen2 스토리지 계정을 만들어야 합니다.
- 이때 Hierarchical Namespace (HNS) 기능을 사용하도록 설정해야 합니다.

2. 서비스 주체 (Service Principal) 생성 및 권한 부여
- ADLS Gen2 스토리지 계정에 액세스할 수 있도록 서비스 주체를 생성하고 필요한 권한을 부여해야 합니다.
- 서비스 주체에 "Storage Blob Data Contributor" 또는 "Storage Blob Data Owner" 권한을 ADLS Gen2 스토리지 계정에 부여합니다.

3. Databricks의 서비스 주체 구성
- Databricks 클러스터 구성 시 서비스 주체를 설정해야 합니다.
- Azure Databricks에서는 서비스 주체를 사용하여 Azure 리소스에 액세스하기 위해서 클라이언트 ID와 **클라이언트 비밀 (Client Secret)**이 필요합니다.

4. Databricks 클러스터에 구성 정보 설정
- Databricks 클러스터의 스파크 설정에 서비스 주체의 클라이언트 ID, 비밀 및 테넌트 정보를 추가해야 합니다.
- 다음과 같은 스파크 구성 변수를 설정해야 합니다:
```
spark.hadoop.fs.azure.account.auth.type.<storage_account>.dfs.core.windows.net OAuth
spark.hadoop.fs.azure.account.oauth.provider.type.<storage_account>.dfs.core.windows.net org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider
spark.hadoop.fs.azure.account.oauth2.client.id.<storage_account>.dfs.core.windows.net <client-id>
spark.hadoop.fs.azure.account.oauth2.client.secret.<storage_account>.dfs.core.windows.net <client-secret>
spark.hadoop.fs.azure.account.oauth2.client.endpoint.<storage_account>.dfs.core.windows.net https://login.microsoftonline.com/<tenant-id>/oauth2/token
```
위에서 <storage_account>, <client-id>, <client-secret>, <tenant-id> 값을 실제로 사용 중인 서비스 주체 정보로 교체하십시오.

5. Databricks 노트북에서 ADLS Gen2 마운트
- Databricks 노트북이나 클러스터에서 ADLS Gen2 파일 시스템을 마운트하여 액세스할 수 있습니다.
```
# 예제 코드 (Python)
configs = {
  "fs.azure.account.auth.type": "OAuth",
  "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
  "fs.azure.account.oauth2.client.id": "<client-id>",
  "fs.azure.account.oauth2.client.secret": "<client-secret>",
  "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/<tenant-id>/oauth2/token"
}

dbutils.fs.mount(
  source = "abfss://<file-system>@<storage-account>.dfs.core.windows.net/",
  mount_point = "/mnt/<mount-point>",
  extra_configs = configs
)
``` 
이러한 단계를 통해 Databricks가 ADLS Gen2 스토리지에 안전하게 액세스할 수 있으며, 클러스터 내에서 데이터를 읽고 쓸 수 있습니다.



# Azure ADLS Gen2 에서 ierarchical Namespace (HNS) 기능을 사용하도록 설정하는 방법 알려줘 
Azure Data Lake Storage Gen2의 Hierarchical Namespace (HNS) 기능을 활성화하면 파일 시스템과 비슷한 디렉토리 구조를 지원할 수 있습니다. 이 기능은 데이터 관리와 성능을 향상시킵니다. Terraform을 사용하거나 Azure Portal을 통해 HNS를 활성화할 수 있습니다.

Terraform을 사용한 방법:
Terraform을 통해 HNS를 활성화하려면 스토리지 계정 리소스에서 is_hns_enabled 속성을 true로 설정하면 됩니다.

```
resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = "example-resources"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true  # Hierarchical Namespace 활성화

  tags = {
    environment = "dev"
  }
}
```

# 아래 서비스 주체 (Service Principal) 생성 및 권한 부여 방법 알려줘 
- ADLS Gen2 스토리지 계정에 액세스할 수 있도록 서비스 주체를 생성하고 필요한 권한을 부여해야 합니다.
- 서비스 주체에 "Storage Blob Data Contributor" 또는 "Storage Blob Data Owner" 권한을 ADLS Gen2 스토리지 계정에 부여합니다.


Azure Data Lake Storage Gen2 스토리지 계정에 액세스할 수 있도록 서비스 주체를 생성하고 권한을 부여하려면 Azure CLI나 Azure Portal을 사용할 수 있습니다. 아래 단계별 가이드를 통해 "Storage Blob Data Contributor" 또는 "Storage Blob Data Owner" 역할을 부여할 수 있습니다.

## Azure CLI 사용 방법
- Azure CLI 설치: Azure CLI가 설치되어 있지 않다면 Azure CLI 설치 가이드를 참조하여 설치합니다.
- Azure 로그인: CLI를 사용하여 Azure에 로그인합니다.
```
az login
```
- 서비스 주체 생성: 원하는 이름으로 서비스 주체를 생성합니다. 이때 --role 및 --scope 옵션을 통해 필요한 권한과 범위를 지정합니다.
```
az ad sp create-for-rbac \
  --name "your-service-principal-name" \
  --role "Storage Blob Data Contributor" \
  --scopes "/subscriptions/<Subscription-ID>/resourceGroups/<Resource-Group>/providers/Microsoft.Storage/storageAccounts/<Storage-Account>"
```  
  - <Subscription-ID>: 구독 ID
  - <Resource-Group>: 스토리지 계정이 속한 리소스 그룹 이름
  - <Storage-Account>: 대상 스토리지 계정 이름

  - Storage Account 은 지속적으로 변경되고 있어서. 
az ad sp create-for-rbac --name kdp-databricks --role Contributor --scopes /subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190


```
➜  jmh-azure git:(main) ✗ az ad sp create-for-rbac --name kdp-databricks --role Contributor --scopes /subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190
Creating 'Contributor' role assignment under scope '/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "ab9625a7-1b22-4c98-a9e0-fb5b361b0178",
  "displayName": "kdp-databricks",
  "password": "N0-8Q~IEWdgvFWCdsQJ0MbfKfHOT~mMO~3rrJbvh",
  "tenant": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9"
}
➜  jmh-azure git:(main) ✗ 
```

- 역할 변경: 필요에 따라 역할을 "Storage Blob Data Owner"로 변경할 수 있습니다.
```
az role assignment create \
  --assignee "<Service-Principal-ID>" \
  --role "Storage Blob Data Owner" \
  --scope "/subscriptions/<Subscription-ID>/resourceGroups/<Resource-Group>/providers/Microsoft.Storage/storageAccounts/<Storage-Account>"
  ```

az role assignment create \
  --assignee "ab9625a7-1b22-4c98-a9e0-fb5b361b0178" \
  --role "Databricks Storage Blob Data Owner" \
  --scope "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/resourceGroups/<Resource-Group>/providers/Microsoft.Storage/storageAccounts/<Storage-Account>"


- 5/10 수행로그 
```

➜  jmh-azure git:(main) ✗ az role assignment create \
  --assignee "f2bb46c6-b19e-4504-b5b2-ef896ef6f861" \
  --role "User Access Administrator" \
  --scope "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190"

{
  "condition": null,
  "conditionVersion": null,
  "createdBy": null,
  "createdOn": "2024-05-10T05:21:21.241884+00:00",
  "delegatedManagedIdentityResourceId": null,
  "description": null,
  "id": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/providers/Microsoft.Authorization/roleAssignments/00010934-db89-4247-a47f-69530d4898f9",
  "name": "00010934-db89-4247-a47f-69530d4898f9",
  "principalId": "f2bb46c6-b19e-4504-b5b2-ef896ef6f861",
  "principalType": "ServicePrincipal",
  "roleDefinitionId": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9",
  "scope": "/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190",
  "type": "Microsoft.Authorization/roleAssignments",
  "updatedBy": "64d465de-724d-4f46-9422-905578246b84",
  "updatedOn": "2024-05-10T05:21:21.421526+00:00"
}
➜  jmh-azure git:(main) ✗ 
```



## Azure Portal 사용 방법
1. Azure Portal에 로그인: Azure Portal에 로그인합니다.
2. 서비스 주체 생성:
   - "Azure Active Directory"로 이동하여 "앱 등록" 메뉴를 선택합니다.
   - "새 등록"을 클릭하여 앱을 등록합니다.
   - 이름과 URI 등을 설정하고 앱을 생성합니다.
   - 생성된 앱을 선택하고 "인증서 및 비밀"에서 클라이언트 비밀을 생성합니다.
3. 역할 할당:
   - 스토리지 계정으로 이동합니다.
   - "액세스 제어 (IAM)" 섹션을 선택합니다.
   - "역할 할당 추가"를 클릭하고 "Storage Blob Data Contributor" 또는 "Storage Blob Data Owner" 역할을 선택합니다.
   - 생성한 서비스 주체를 선택하여 역할을 할당합니다.
이렇게 하면 서비스 주체를 생성하고 스토리지 계정에 필요한 권한을 부여할 수 있습니다.

