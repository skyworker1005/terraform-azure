

# # Azure AD Application 생성
# resource "azuread_application" "example" {
#   display_name = "your-service-principal-name"
# }

# # Azure AD Service Principal 생성
# resource "azuread_service_principal" "example" {
#   application_id = azuread_application.example.application_id
# }

# # AD Application 비밀키 생성
# resource "azuread_application_password" "example" {
#   application_object_id = azuread_application.example.id
#   display_name          = "Example Password"
# }

# # 특정 Storage 계정에 대한 권한 부여
# resource "azurerm_role_assignment" "example" {
#   scope                = "/subscriptions/<Subscription-ID>/resourceGroups/<Resource-Group>/providers/Microsoft.Storage/storageAccounts/<Storage-Account>"
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azuread_service_principal.example.object_id
# }

# output "service_principal_client_id" {
#   value = azuread_application.example.application_id
# }

# output "service_principal_client_secret" {
#   value = azuread_application_password.example.value
# }
