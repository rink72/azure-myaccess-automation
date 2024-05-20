data "azurerm_role_definition" "rbac_role" {
  name = var.role_name
}

data "azurerm_subscription" "current" {}

data "azurerm_resources" "resource_scope" {
  name                = var.resource_name
  type                = var.resource_type
  resource_group_name = var.resource_group_name
}

module "active_assignments" {
  source   = "../active_assignment"
  for_each = local.active_assignments

  scope              = data.azurerm_resources.resource_scope.resources[0].id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.rbac_role.id}"
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

module "eligible_assignments" {
  source   = "../eligible_assignment"
  for_each = local.eligible_assignments

  scope              = data.azurerm_resources.resource_scope.resources[0].id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.rbac_role.id}"
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

data "azapi_resource_id" "roleManagementPolicy" {
  type      = "Microsoft.Authorization/roleManagementPolicies@2020-10-01"
  name      = data.azurerm_role_definition.rbac_role.id
  parent_id = data.azurerm_resources.resource_scope.resources[0].id
}

resource "terraform_data" "pim_role_configuration" {

  provisioner "local-exec" {
    command = "az account show > /tmp/az_account_show.json"
  }
}

module "pim_role_configuration" {
  source = "../pim_role_configuration"

  resource_id        = data.azurerm_resources.resource_scope.resources[0].id
  role_definition_id = data.azurerm_role_definition.rbac_role.role_definition_id
}

output "pim_role_configuration" {
  value = data.azapi_resource_id.roleManagementPolicy
}

output "rbac_role" {
  value = data.azurerm_role_definition.rbac_role
}
