
# 변수 값 셋팅 
- macos 에서 zshr을 사용할 경우 
vi ~/.zshrc 
```
# Tenant ID, Subscription ID 정보 
export TF_VAR_subscription_id="5f918871-00000-00000-00000-00000"
export TF_VAR_tenant_id="1fd5ae1e-3b59-00000-00000-00000"

# Terraform Service Principal 정보
export TF_VAR_terraform_client_id="61c8285a-00000-00000-00000-00000"
export TF_VAR_terraform_client_secret="qjJ8Q~00000000000000000000"

# databricks_token & databricks_host 2개 변수는 databricks workspace 생성 후에 확인 가능
export TF_VAR_databricks_principal_id="48e1c7f2-9858-00000-00000-00000"
export TF_VAR_databricks_token="dapie400000000000000000000ed2"
```

