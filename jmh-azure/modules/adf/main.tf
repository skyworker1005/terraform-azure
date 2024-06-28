resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}"
  location = var.location
}

# Azure Data Factory 리소스 생성
resource "azurerm_data_factory" "adf" {
    name                = "${var.prefix}-${var.environment}-adf"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

# ADLS Gen2 Linked Service 설정
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_gen2" {
    name                = "adlsGen2LinkedService"
    data_factory_id     = azurerm_data_factory.adf.id
    url                 = "https://${var.adls_gen2_account_name}.dfs.core.windows.net"
    use_managed_identity = true
}

# # Bronze Dataset
# resource "azurerm_data_factory_dataset_json" "bronze_dataset" {
#     name                = "BronzeDataset"
#     data_factory_id     = azurerm_data_factory.adf.id
#     linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_gen2.name
#     file_path           = "bronze"
#     file_name           = "*.json"
# }

# # Silver Dataset
# resource "azurerm_data_factory_dataset_json" "silver_dataset" {
#     name                = "SilverDataset"
#     data_factory_id     = azurerm_data_factory.adf.id
#     linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_gen2.name
#     file_path           = "silver"
#     file_name           = "*.json"
# }

# # Gold Dataset
# resource "azurerm_data_factory_dataset_json" "gold_dataset" {
#     name                = "GoldDataset"
#     data_factory_id     = azurerm_data_factory.adf.id
#     linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_gen2.name
#     file_path           = "gold"
#     file_name           = "*.json"
# }

# # 파이프라인 예시 (상세 구현은 프로젝트 요구사항에 따라 달라질 수 있음)
# resource "azurerm_data_factory_pipeline" "ingestion_pipeline" {
#     name                = "IngestionPipeline"
#     data_factory_id     = azurerm_data_factory.adf.id
#     description         = "Data ingestion pipeline for bronze, silver, gold layers."

#     # 파이프라인 액티비티 구성
#     # 이 부분은 실제 데이터 이동 및 변환 로직에 따라 구성해야 합니다.
# }