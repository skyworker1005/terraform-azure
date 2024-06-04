# 개인 Pilot project
- 개인 Azure 환경에서 테스트 용도로 진행하고 있는 Pilot project 입니다. 
- 테스트 진행 중이라 코드가 정리되지 않았습니다. 

# Terraform module 을 활용한 Data Platform 구성 자동화 
## Azure Cloud 환경 구성 
- Hub & Spoke network 환경에서 Data Platform 과 관련된 azure cloud 환경 구성 
  - private network 환경으로만 구성 예정 
  - vnet, subnet, storage, private endpoint, vnet peering, ad 연계 등  
## Data Analytics 환경 구성 
  1. Dedicated Zone 
     - ADF, ADLS Gen2, Databricks( workspace, cluster, token, sql warehouse)
     - Databricks 관련 구성 설정 
  2. Shared Zone 
     - ADLS Gen2, Synapse, AI/ML, API management, AKS



# 초기 필수 변수 값 셋팅 
- macos 에서 zshr을 사용할 경우 
vi ~/.zshrc 
```
# Tenant ID, Subscription ID 정보 
export TF_VAR_subscription_id="5f918871-00000-00000-00000-00000"
export TF_VAR_tenant_id="1fd5ae1e-3b59-00000-00000-00000"

# Terraform Service Principal 정보
export TF_VAR_terraform_client_id="61c8285a-00000-00000-00000-00000"
export TF_VAR_terraform_client_secret="qjJ8Q~00000000000000000000"
```

## terraform apply 

1. 첫 번째, apply 과정에서 아래와 같은 오류 발생
  
  - token 생성 오류 
    ```
    terraform apply 
    ...
    ...
    subscriptions/5f918871-6ae3-44a3-80dc-ba82deaf3190/resourceGroups/KDP-DEV-DATABRICKS/providers/Microsoft.Network/privateDnsZones/privatelink.databricks.azure.com/A/adb-compute-2486876672885990]
    null_resource.databricks_token_dependency: Creating...
    null_resource.databricks_token_dependency: Creation complete after 0s [id=1743624247961068119]
    ╷
    │ Error: cannot create token: Unauthorized access to workspace: 2486876672885990. Using azure-cli auth: host=https://adb-2486876672885990.10.azuredatabricks.net
    │ 
    │   with module.kdp_databricks_token.databricks_token.this,
    │   on modules/databricks/token/token.tf line 18, in resource "databricks_token" "this":
    │   18: resource "databricks_token" "this" {
    │ 
    ╵
    ➜  jmh-azure git:(main) ✗ 
    ```
2. Azure Portal 에서 생성된 Databricks Workspace 에 로그인하고 나서 terraform apply 시도하면 에러 없이 완료 됨 
  - 완료 메시지 
    ```
    terraform apply 
    ...
    ...
    Apply complete! Resources: 2 added, 2 changed, 0 destroyed.

    Outputs:

    databricks_host = "https://adb-2486876672885990.10.azuredatabricks.net/"
    databricks_token_value = <sensitive>
    ➜  jmh-azure git:(main) ✗ 
    ``` 


