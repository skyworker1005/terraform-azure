# 개인 Pilot project
- 개인 Azure 환경에서 테스트 용도로 진행하고 있는 Pilot project 입니다. 
- 테스트 진행 중이라 코드가 정리되지 않았습니다. 

# Terraform module 을 활용한 Data Platform 구성 자동화 
## Azure Cloud 환경 구성 
- Hub & Spoke network 환경에서 Data Platform 과 관련된 azure cloud 환경 구성 
  - private network 환경으로만 구성 예정 
  - vnet, subnet, storage, private endpoint, vnet peering, Azure Key Vault, ad 연계 등  
## Data Analytics 환경 구성 
  1. Dedicated Zone 2개 
     - ADF, ADLS Gen2, Databricks( workspace, cluster, token, sql warehouse)
     - Databricks 관련 구성 설정 
  2. Shared Zone 1개 
     - ADLS Gen2, Synapse, AI/ML, API management, AKS, Power BI 



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



# 해야 할(해결해야할) 목록 
- 1. terraform apply 1차에서는 에러발생, Azure Portal 에서 생성된 Databricks Workspace 에 로그인하고 나서 terraform apply 시도하면 에러 없이 완료 현상 

- 2. Unity Catalog을 별도 생성했다가, 아래 문서보고 workspace 생성시 기본적으로 생성되는것을 확인 했음
https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/unity-catalog-default
  생성된 Catalog Metastores의 metastore_azure_koreacentral 을 클릭하면, ADLS Gen 2 path 을 설정하는 화면이 나오는데, 아래 코드에서 미리 생성된 ADLS Gen 2 path  "kdpcatalog@kdpmetastore.dfs.core.windows.net/"을 선택하고 Update 하면 에러 메시지나 변경 사항 반영이 안됨. 
   jmh-azure/modules/storage/adls_gen2/adls_gen2_catalog.tf

- 3. vnet peering 
  - Dedicate(2), Shared Zone은 Hub network 와 vnet peering 되어야 함.  

- 4. Private Endpoint을 Hub private_endpoint_subnet 으로 변경해야 함
  - 현재는, Dedicated Zone 에 private_endpoint_subnet 으로 되어 있음.  

- 5. Shared Zone 구성 
  - ADLS Gen2, Synapse, AI/ML, API management, AKS, Power BI 

- 6. Dedicated Zone에 있는 Data -> Shared Zone Synapse DW  
  - Shared Zone Synapse 에서 Dedicated Zone에 있는 gold data 가져오기 

- 7. Databricks AI/ML 구성 
  - Dedicated Zone(2)에 Databricks AI/ML 구성 

