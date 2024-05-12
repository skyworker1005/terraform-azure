
로그 분석 결과 azurerm_role_assignment 리소스 생성 시 PrincipalNotFound 오류가 발생하고 있는 것으로 보입니다. 이는 지정된 서비스 주체(Service Principal)가 Azure Active Directory에서 발견되지 않았기 때문에 발생합니다. 이 문제는 일반적으로 서비스 주체 생성 직후 역할 할당을 시도할 때 복제 지연(replication delay) 때문에 발생할 수 있습니다.

문제 해결 방법
서비스 주체 확인: 먼저 Azure 포털 또는 az CLI를 사용하여 서비스 주체가 존재하고 올바르게 구성되었는지 확인하세요. 예를 들어, 다음 명령어를 사용할 수 있습니다:

bash
Copy code
az ad sp show --id <Service-Principal-ID>
이를 통해 서비스 주체의 ID가 올바른지 확인하세요.

- 수행로그 
az ad sp show --id ab9625a7-1b22-4c98-a9e0-fb5b361b0178
```

➜  jmh-azure git:(main) ✗ az ad sp show --id ab9625a7-1b22-4c98-a9e0-fb5b361b0178
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#servicePrincipals/$entity",
  "accountEnabled": true,
  "addIns": [],
  "alternativeNames": [],
  "appDescription": null,
  "appDisplayName": "kdp-databricks",
  "appId": "ab9625a7-1b22-4c98-a9e0-fb5b361b0178",
  "appOwnerOrganizationId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
  "appRoleAssignmentRequired": false,
  "appRoles": [],
  "applicationTemplateId": null,
  "createdDateTime": "2024-05-08T07:58:24Z",
  "deletedDateTime": null,
  "description": null,
  "disabledByMicrosoftStatus": null,
  "displayName": "kdp-databricks",
  "homepage": null,
  "id": "48e1c7f2-9858-407d-983c-11dea10e78f4",
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
    "ab9625a7-1b22-4c98-a9e0-fb5b361b0178"
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
➜  jmh-azure git:(main) ✗ 
```

복제 지연 대응: Azure Active Directory의 복제 지연으로 인해 발생할 수 있는 문제에 대응하기 위해 Terraform 구성에서 서비스 주체 생성 후 일정 시간 대기하는 방법을 사용할 수 있습니다. 예를 들어, null_resource와 local-exec 프로비저너를 사용하여 몇 분간 대기한 후 역할 할당을 시도할 수 있습니다.

hcl
Copy code
resource "null_resource" "wait_for_sp_replication" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  triggers = {
    sp_id = azurerm_service_principal.example.id
  }
}

resource "azurerm_role_assignment" "example" {
  depends_on = [null_resource.wait_for_sp_replication]

  principal_id   = azurerm_service_principal.example.id
  role_definition_name = "Reader"
  scope            = azurerm_subscription.example.id
}
역할 할당 주체 타입 설정: 만약 복제 지연을 해결하는 위의 방법이 효과가 없다면, 역할 할당 시 principalType 속성을 명시적으로 설정해 보세요. 이 값으로 ServicePrincipal, User, 또는 Group 중 하나를 설정할 수 있습니다.

자세한 로그 분석: Terraform 및 Azure의 로그를 자세히 분석하여 추가적인 문제점을 확인하세요. 문제가 지속될 경우 Azure 지원팀에 문의하여 복제 지연 또는 다른 인프라 관련 문제가 있는지 확인할 수 있습니다.

Azure 서비스 상태 확인: Azure 서비스 상태가 이 문제에 영향을 주고 있지 않은지 확인하기 위해 Azure Service Health 대시보드를 확인하세요.

이러한 단계를 통해 문제를 해결할 수 있기를 바랍니다. 추가적인 지원이 필요하면 언제든지 문의해 주세요.

# Solution
## Action.1
로그 분석 결과 azurerm_role_assignment 리소스 생성 시 PrincipalNotFound 오류가 발생하고 있는 것으로 보입니다. 이는 지정된 서비스 주체(Service Principal)가 Azure Active Directory에서 발견되지 않았기 때문에 발생합니다. 이 문제는 일반적으로 서비스 주체 생성 직후 역할 할당을 시도할 때 복제 지연(replication delay) 때문에 발생할 수 있습니다.

문제 해결 방법
서비스 주체 확인: 먼저 Azure 포털 또는 az CLI를 사용하여 서비스 주체가 존재하고 올바르게 구성되었는지 확인하세요. 예를 들어, 다음 명령어를 사용할 수 있습니다:

bash
Copy code
az ad sp show --id <Service-Principal-ID>
이를 통해 서비스 주체의 ID가 올바른지 확인하세요.

```
➜  jmh-azure git:(main) ✗ az ad sp show --id ab9625a7-1b22-4c98-a9e0-fb5b361b0178
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#servicePrincipals/$entity",
  "accountEnabled": true,
  "addIns": [],
  "alternativeNames": [],
  "appDescription": null,
  "appDisplayName": "kdp-databricks",
  "appId": "ab9625a7-1b22-4c98-a9e0-fb5b361b0178",
  "appOwnerOrganizationId": "1fd5ae1e-3b59-4db5-a2c5-5764441925b9",
  "appRoleAssignmentRequired": false,
  "appRoles": [],
  "applicationTemplateId": null,
  "createdDateTime": "2024-05-08T07:58:24Z",
  "deletedDateTime": null,
  "description": null,
  "disabledByMicrosoftStatus": null,
  "displayName": "kdp-databricks",
  "homepage": null,
  "id": "48e1c7f2-9858-407d-983c-11dea10e78f4",
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
    "ab9625a7-1b22-4c98-a9e0-fb5b361b0178"
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
➜  jmh-azure git:(main) ✗ 
```

## 해결 방안 
서비스 주체 정보를 확인했습니다. 이 정보에 따르면, 서비스 주체는 활성화된 상태이며, 해당 주체의 ID는 "48e1c7f2-9858-407d-983c-11dea10e78f4"입니다. 그러나 이전에 문제가 발생했던 역할 할당 시 사용된 ID는 "ab9625a7-1b22-4c98-a9e0-fb5b361b0178"로, 이는 실제 애플리케이션(서비스 주체가 연결된)의 ID입니다. 역할 할당에는 서비스 주체의 ID가 사용되어야 합니다.

해결 방법
역할 할당을 위해 서비스 주체의 ID를 올바르게 지정해야 합니다. 즉, "ab9625a7-1b22-4c98-a9e0-fb5b361b0178" 대신 "48e1c7f2-9858-407d-983c-11dea10e78f4"를 사용해야 합니다. Terraform 구성을 업데이트하여 올바른 ID를 사용하도록 수정하세요.

```
resource "azurerm_role_assignment" "example" {
  principal_id           = "48e1c7f2-9858-407d-983c-11dea10e78f4"  # 서비스 주체의 올바른 ID 사용
  role_definition_name   = "Reader"  # 역할 정의
  scope                  = azurerm_subscription.example.id  # 적용 범위
}
```



/subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/resourceGroups/KDP-DEV-DATABRICKS/providers/Microsoft.Databricks/workspaces/KDP-DEV

Name
Object ID
Application ID
Homepage URL
Created on
Certificate Expiry Status
Active Certificate Expiry Date
Application Status
Application Visibility
Identifier URI (Entity ID)
K

kdp-databricks
48e1c7f2-9858-407d-983c-11dea10e78f4
ab9625a7-1b22-4c98-a9e0-fb5b361b0178
5/8/2024
-
-
Enabled
Visible
ab9625a7-1b22-4c98-a9e0-fb5b361b0178
K

kdp-terraform
f2bb46c6-b19e-4504-b5b2-ef896ef6f861
61c8285a-8bc7-4d60-a13d-f21e12d4b627
4/17/2024
-
-
Enabled