data "azurerm_role_definition" "rbac_role" {
  name = var.role_name
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "rgp_scope" {
  name = var.resource_group_name
}

module "active_assignments" {
  source   = "../active_assignment"
  for_each = local.active_assignments

  scope              = data.azurerm_resource_group.rgp_scope.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.rbac_role.id}"
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

module "eligible_assignments" {
  source   = "../eligible_assignment"
  for_each = local.eligible_assignments

  scope              = data.azurerm_resource_group.rgp_scope.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.rbac_role.id}"
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

data "azapi_resource_id" "roleManagementPolicy" {
  type      = "Microsoft.Authorization/roleManagementPolicies@2020-10-01"
  name      = "bd4d764e-b40d-4ed1-802b-533400abb6c4"
  parent_id = data.azurerm_resource_group.rgp_scope.id
}
