data "azurerm_role_definition" "rbac_role" {
  name = var.role_name
}

data "azurerm_subscription" "current" {}

module "active_assignments" {
  source   = "../active_assignment"
  for_each = { for assignment in local.active_assignments : assignment.name => assignment }

  scope              = var.scope
  parent_scope       = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.value.name
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

module "eligible_assignments" {
  source   = "../eligible_assignment"
  for_each = { for assignment in local.eligible_assignments : assignment.name => assignment }

  scope              = var.scope
  parent_scope       = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.value.name
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

data "azapi_resource_id" "roleManagementPolicy" {
  type      = "Microsoft.Authorization/roleManagementPolicies@2020-10-01"
  name      = "bd4d764e-b40d-4ed1-802b-533400abb6c4"
  parent_id = var.scope
}


# resource "azapi_resource_action" "pim_configuration" {
#   type        = "Microsoft.Authorisation/roleManagementPolicies@2020-10-01"
#   method      = "PATCH"
#   resource_id = "${var.scope}${data.azurerm_role_definition.rbac_role.id}"
# }
