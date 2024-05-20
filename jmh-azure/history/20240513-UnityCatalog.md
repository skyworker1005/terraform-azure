
# 소스 코드 현행화 
jmh-azure/history/20240513-All.md

## GPT
이 Terraform 구성은 Azure cloud 기반의 Korea Data Platform (KDP)를 구축하기 위해 모듈화된 접근 방식을 사용합니다. 주요 구성 요소로는 네트워크, Databricks, 및 ADLS Gen2 스토리지가 포함되며, 이들을 통해 데이터 처리 및 스토리지 관리를 효율적으로 수행할 수 있습니다.

## 주요 구성 요소 설명
1. Network Module (network.tf):
- Virtual Network와 서브넷 설정을 포함하고 있으며, 퍼블릭과 프라이빗 서브넷이 정의되어 있습니다.
- 각 서브넷은 Databricks 서비스 위임을 통해 Databricks 클러스터가 Azure 서비스와 통합될 수 있도록 설정되어 있습니다.

2. Databricks Module (databricks.tf):
- Azure Databricks 워크스페이스를 생성합니다. 설정에서는 네트워크 모듈에서 생성된 VNet과 서브넷 정보를 사용하여 Databricks 인스턴스가 해당 네트워크 설정 내에서 운영될 수 있도록 합니다.
- no_public_ip 설정을 통해 보안을 강화하고 있으며, sku를 "premium"으로 설정하여 고급 기능을 사용할 수 있습니다.

3. ADLS Gen2 Module (adls_gen2.tf):
- Azure Data Lake Storage Gen2 계정을 생성하며, 여기에는 Bronze, Silver, Gold 각각의 파일 시스템(데이터 레이크)이 포함됩니다.
- Databricks에서 이 스토리지 계정에 접근할 수 있도록 하는 역할 할당도 설정되어 있습니다. 이를 통해 Databricks는 스토리지 데이터에 대한 처리를 수행할 수 있습니다.

## 업데이트 요청
Databricks가 ADLS Gen2에서 생성된 스토리지에 접근하여 데이터를 처리할 수 있도록 하려면 다음과 같은 업데이트가 필요합니다:
1. 역할 할당 검증: Databricks 워크스페이스에 대한 서비스 주체가 올바르게 설정되어 있고, 해당 주체에게 ADLS Gen2 리소스에 대한 접근 권한이 제대로 할당되었는지 확인해야 합니다. azurerm_role_assignment 리소스에서 사용되는 principal_id가 Databricks 서비스 주체의 ID와 일치하는지 검토합니다.
2. 네트워크 구성 검토: Databricks 워크스페이스가 해당 VNet과 서브넷을 통해 ADLS Gen2에 접근할 수 있도록 네트워크 구성이 적절한지 확인합니다. 필요한 경우 네트워크 보안 그룹(NSG) 설정을 조정하여 데이터 트래픽이 안전하게 관리되도록 합니다.

이 구성은 Terraform을 사용하여 Azure 리소스를 모듈화하여 관리하는 효율적인 방법을 제시하며, 각 컴포넌트의 역할과 상호 작용을 명확히 정의하여 플랫폼 전체의 보안과 통합성을 보장합니다.



# databricks unity catalog 을 생성하는 terraform module 코드 업데이트 해줘 