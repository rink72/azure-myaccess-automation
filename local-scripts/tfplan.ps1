. ../.env.local.ps1

terraform init `
  -backend-config="subscription_id=$($ENV:TF_STATE_SUBSCRIPTION_ID)" `
  -backend-config="resource_group_name=$($ENV:TF_STATE_RESOURCE_GROUP)" `
  -backend-config="storage_account_name=$($ENV:TF_STATE_STORAGE_ACCOUNT)" `
  -backend-config="container_name=$($ENV:TF_STATE_CONTAINER)" `
  -backend-config="key=azure-pim-configuration/dev.terraform.tfstate"