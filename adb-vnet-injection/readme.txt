# Azure CLI 로그인
az login

# 테라폼 초기화
terraform init

# 테라폼 계획
terraform plan --var-file=terraform.tfvars

# 테라폼 적용
terraform apply --var-file=terraform.tfvars -auto-approve

# 테라폼 삭제
terraform destroy --var-file=terraform.tfvars -auto-approve