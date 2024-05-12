
# Entra ID - Enterprise Application - SP
![SP](../images/AzureEntraID-SP.png)
|---|---|
|Name|Application ID|
|---|---|
|kdp-databricks | ab9625a7-1b22-4c98-a9e0-fb5b361b0178|
|kdp-terraform | 61c8285a-8bc7-4d60-a13d-f21e12d4b627 | 


# KDP 에서 필요한 Service Pricipal 생성 
- kdp-terraform
- kdp-databricks 

# Terraform 에서 사용할 Service Pricipal 생성 

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

# Databricks에서 ADLS Gen2 접근용 
jmh-azure/history/20240508-ADLS-databricks.md


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

