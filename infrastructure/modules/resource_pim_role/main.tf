data "azurerm_role_definition" "rbac_role" {
  name = var.role_name
}

data "azurerm_subscription" "current" {}

module "active_assignments" {
  source   = "../active_assignment"
  for_each = local.active_assignments

  scope              = var.scope
  parent_scope       = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

module "eligible_assignments" {
  source   = "../eligible_assignment"
  for_each = local.eligible_assignments

  scope              = var.scope
  parent_scope       = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

data "azapi_resource_id" "roleManagementPolicy" {
  type      = "Microsoft.Authorization/roleManagementPolicies@2020-10-01"
  name      = "bd4d764e-b40d-4ed1-802b-533400abb6c4"
  parent_id = var.scope
}
