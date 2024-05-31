


# to-do
## 1. 
databricks_host, databricks_token 값을 셋팅하기 위해 terraform을 2번 실행하게 된다. 
이 부분을 한번에 자동화 할 수 있는 방법은?

## 2. 
terraform은 Service Principal 을 사용했다. 
databricks 도 Service Principal 로 했는데, Managed Identity 로 변경하는 쪽으로 계획 중.. 

|Display name|Application (client) ID|Created on|Certificates & secrets|
|---|---|---|---|
|KD kdp-databricks | ab9625a7-1b22-4c98-a9e0-fb5b361b0178 |5/8/2024 |Current|
|KD kdp-terraform  | 61c8285a-8bc7-4d60-a13d-f21e12d4b627 |4/17/2024|Current|

## 3. 
databricks workspace 생성 중에 Unity Catalog 을 사용하는 것으로 설정하는 테스트 진행 

